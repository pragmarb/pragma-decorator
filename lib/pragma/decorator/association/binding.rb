# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      # Links an association definition to a specific decorator instance, allowing to render it.
      #
      # @author Alessandro Desantis
      class Binding
        # @!attribute [r] reflection
        #   @return [Reflection] the association reflection
        #
        # @!attribute [r] decorator
        #   @return [Pragma::Decorator::Base] the decorator instance
        attr_reader :reflection, :decorator

        # Initializes the binding.
        #
        # @param reflection [Reflection] the association reflection
        # @param decorator [Pragma::Decorator::Base] the decorator instance
        def initialize(reflection:, decorator:)
          @reflection = reflection
          @decorator = decorator

          check_type_consistency
        end

        # Returns the associated object.
        #
        # @return [Object]
        def associated_object
          case reflection.options[:exec_context]
          when :decorated
            model.public_send(reflection.property)
          when :decorator
            decorator.public_send(reflection.property)
          end
        end

        # Returns whether the association belongs to the model.
        #
        # @return [Boolean]
        def model_context?
          reflection.options[:exec_context].to_sym == :decorated
        end

        # Returns whether the association belongs to the decorator.
        #
        # @return [Boolean]
        def decorator_context?
          reflection.options[:exec_context].to_sym == :decorator
        end

        # Returns the unexpanded value for the associated object (i.e. its +id+ property).
        #
        # @return [String]
        def unexpanded_value
          if decorator_context? || model_reflection.nil?
            return associated_object&.public_send(associated_object.class.primary_key)
          end

          case reflection.type
          when :belongs_to
            model.public_send(model_reflection.foreign_key)
          when :has_one
            if model.association(reflection.property).loaded?
              return associated_object&.public_send(associated_object.class.primary_key)
            end

            pk = model.public_send(model_reflection.active_record_primary_key)

            model_reflection
              .klass
              .where(model_reflection.foreign_key => pk)
              .pluck(model_reflection.klass.primary_key)
              .first
          else
            associated_object&.public_send(associated_object.class.primary_key)
          end
        end

        # Returns the expanded value for the associated object.
        #
        # If a decorator was specified for the association, first decorates the associated object,
        # then calls +#to_hash+ to render it as a hash.
        #
        # If no decorator was specified, calls +#as_json+ on the associated object.
        #
        # In any case, passes all nested associations as the +expand+ user option of the method
        # called.
        #
        # @param user_options [Array]
        #
        # @return [Hash]
        def expanded_value(user_options)
          return unless associated_object

          options = {
            user_options: user_options.merge(
              expand: flatten_expand(user_options[:expand])
            )
          }

          decorator_klass = compute_decorator

          if decorator_klass
            decorator_klass.new(associated_object).to_hash(options)
          else
            associated_object.as_json(options)
          end
        end

        # Renders the unexpanded or expanded associations, depending on the +expand+ user option
        # passed to the decorator.
        #
        # @param user_options [Array]
        #
        # @return [Hash|Pragma::Decorator::Base]
        def render(user_options)
          return unless associated_object

          if user_options[:expand]&.any? { |value| value.to_s == reflection.property.to_s }
            expanded_value(user_options)
          else
            unexpanded_value
          end
        end

        private

        def flatten_expand(expand)
          expand ||= []

          expected_beginning = "#{reflection.property}."

          expand.reject { |value| value.to_s == reflection.property.to_s }.map do |value|
            if value.start_with?(expected_beginning)
              value.sub(expected_beginning, '')
            else
              value
            end
          end
        end

        def compute_decorator
          if reflection.options[:decorator].respond_to?(:call)
            reflection.options[:decorator].call(associated_object)
          else
            reflection.options[:decorator]
          end
        end

        def model
          decorator.decorated
        end

        def model_reflection
          # rubocop:disable Metrics/LineLength
          @model_reflection ||= if Object.const_defined?('ActiveRecord') && model.is_a?(ActiveRecord::Base)
            model.class.reflect_on_association(reflection.property)
          end
          # rubocop:enable Metrics/LineLength
        end

        def model_association_type
          return unless model_reflection

          if Object.const_defined?('ActiveRecord') && model.is_a?(ActiveRecord::Base)
            model_reflection.macro
          end
        end

        def check_type_consistency
          return if !model_association_type || model_association_type == reflection.type

          fail InconsistentTypeError.new(
            decorator: decorator,
            reflection: reflection,
            model_type: model_association_type
          )
        end
      end
    end
  end
end
