# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      def self.included(klass)
        klass.extend ClassMethods
        klass.include InstanceMethods
      end

      module ClassMethods # :nodoc:
        def associations
          @associations ||= {}
        end

        def belongs_to(property_name, options = {})
          define_association :belongs_to, property_name, options
        end

        def has_one(property_name, options = {}) # rubocop:disable Naming/PredicateName
          define_association :has_one, property_name, options
        end

        private

        def define_association(type, property_name, options = {})
          create_association_definition(type, property_name, options)
          create_association_property(type, property_name, options)
        end

        def create_association_definition(type, property_name, options)
          associations[property_name.to_sym] = Reflection.new(type, property_name, options)
        end

        def create_association_property(_type, property_name, options)
          property_options = options.dup.tap { |po| po.delete(:decorator) }.merge(
            exec_context: :decorator,
            as: options[:as] || property_name,
            getter: (lambda do |decorator:, user_options:, **_args|
              Bond.new(
                reflection: decorator.class.associations[property_name],
                decorator: decorator
              ).render(user_options)
            end)
          )

          property("_#{property_name}_association", property_options)
        end
      end

      module InstanceMethods # :nodoc:
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
