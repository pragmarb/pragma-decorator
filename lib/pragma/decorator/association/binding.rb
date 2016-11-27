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
        end

        # Renders the unexpanded or expanded associations, depending on the +expand+ user option
        # passed to the decorator.
        #
        # @param expand [Array<String>] the associations to expand for this representation
        #
        # @return [Hash|Pragma::Decorator::Base]
        def render(expand)
          expand ||= []
          associated_object = decorator.decorated.send(reflection.property)

          unless expand.any? { |value| value.to_s == reflection.property.to_s }
            return {
              id: associated_object.id
            }
          end

          if reflection.options[:decorator]
            associated_object = reflection.options[:decorator].new(
              associated_object
            )
          end

          associated_object.to_hash(user_options: {
            expand: flatten_expand(expand)
          })
        end

        private

        def flatten_expand(expand)
          expected_beginning = "#{reflection.property}."

          expand.reject { |value| value.to_s == reflection.property.to_s }.map do |value|
            if value.start_with?(expected_beginning)
              value.sub(expected_beginning, '')
            else
              value
            end
          end
        end
      end
    end
  end
end
