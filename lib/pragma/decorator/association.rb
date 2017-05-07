# frozen_string_literal: true

module Pragma
  module Decorator
    # Adds association expansion to decorators.
    #
    # @author Alessandro Desantis
    module Association
      def self.included(klass)
        klass.extend ClassMethods
        klass.include InstanceMethods
      end

      module ClassMethods # rubocop:disable Style/Documentation
        def associations
          @associations ||= {}
        end

        # Defines a +belongs_to+ association.
        #
        # See {Association::Reflection#initialize} for the list of available options.
        #
        # @param property [Symbol] the property containing the associated object
        # @param options [Hash] the options of the association
        def belongs_to(property, options = {})
          define_association :belongs_to, property, options
        end

        # Defines a +has_one+ association.
        #
        # See {Association::Reflection#initialize} for the list of available options.
        #
        # @param property [Symbol] the property containing the associated object
        # @param options [Hash] the options of the association
        def has_one(property, options = {}) # rubocop:disable Style/PredicateName
          define_association :has_one, property, options
        end

        private

        def define_association(type, property, options = {})
          create_association_definition(type, property, options)
          create_association_getter(property)
          create_association_property(property)
        end

        def create_association_definition(type, property, options)
          associations[property.to_sym] = Reflection.new(type, property, options)
        end

        def create_association_getter(property)
          class_eval <<~RUBY
            def _#{property}_association
              Binding.new(
                reflection: self.class.associations[:#{property}],
                decorator: self
              ).render(user_options[:expand])
            end
          RUBY
        end

        def create_association_property(property_name)
          options = {
            exec_context: :decorator,
            as: property_name
          }.tap do |opts|
            if associations[property_name].options.key?(:render_nil)
              opts[:render_nil] = associations[property_name].options[:render_nil]
            end
          end

          property("_#{property_name}_association", options)
        end
      end

      module InstanceMethods
        def validate_expansion(expand)
          check_parent_associations_are_expanded(expand)
          check_expanded_associations_exist(expand)
        end

        private

        def check_parent_associations_are_expanded(expand)
          expand = normalize_expand(expand)

          expand.each do |property|
            next unless property.include?('.')

            parent_path = property.split('.')[0..-2].join('.')
            next if expand.include?(parent_path)

            fail Association::UnexpandedAssociationParent.new(property, parent_path)
          end
        end

        def check_expanded_associations_exist(expand)
          expand = normalize_expand(expand)

          expand.each do |property|
            next if self.class.associations.key?(property.to_sym) || property.include?('.')
            fail Association::AssociationNotFound, property
          end
        end

        def normalize_expand(expand)
          [expand].flatten.map(&:to_s).reject(&:blank?)
        end
      end
    end
  end
end
