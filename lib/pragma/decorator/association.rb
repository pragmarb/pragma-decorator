module Pragma
  module Decorator
    # Adds association expansion to decorators.
    #
    # @author Alessandro Desantis
    module Association
      def self.included(klass)
        klass.extend ClassMethods

        klass.class_eval do
          @associations = {}

          def self.associations
            @associations
          end
        end
      end

      # Inizialies the decorator and bindings for all the associations.
      #
      # @see Association::Binding
      def initialize(*)
        super

        @association_bindings = {}
        self.class.associations.each_pair do |property, reflection|
          @association_bindings[property] = Binding.new(reflection: reflection, decorator: self)
        end
      end

      module ClassMethods
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
        def has_one(property, options = {})
          define_association :has_one, property, options
        end

        private

        def define_association(type, property, options = {})
          create_association_definition(type, property, options)
          create_association_getter(property)
          create_association_property(property)
        end

        def create_association_definition(type, property, options)
          @associations[property.to_sym] = Reflection.new(type, property, options)
        end

        def create_association_getter(property)
          class_eval <<~RUBY
            def #{property}
              @association_bindings[:#{property}].render(user_options[:expand])
            end
          RUBY
        end

        def create_association_property(property)
          property(
            property,
            exec_context: :decorator,
            render_nil: @associations[property].options[:render_nil]
          )
        end
      end
    end
  end
end