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

        # Returns the associated object.
        #
        # @return [Object]
        def associated_object
          case reflection.options[:exec_context]
          when :decorated
            decorator.decorated.send(reflection.property)
          when :decorator
            decorator.send(reflection.property)
          end
        end

        # Returns the unexpanded hash for the associated object (i.e. a hash with only the +id+
        # property).
        #
        # @return [Hash]
        def unexpanded_hash
          return unless associated_object

          {
            id: associated_object.id
          }
        end

        # Returns the expanded hash for the associated object.
        #
        # If a decorator was specified for the association, first decorates the associated object,
        # then calls +#to_hash+ to render it as a hash.
        #
        # If no decorator was specified, calls +#as_json+ on the associated object.
        #
        # In any case, passes all nested associations as the +expand+ user option of the method
        # called.
        #
        # @param expand [Array<String>] the associations to expand
        #
        # @return [Hash]
        #
        # @raise [UnexpandableError] if the association is not expandable
        def expanded_hash(expand)
          fail UnexpandableError, reflection unless reflection.expandable?

          return unless associated_object

          options = {
            user_options: {
              expand: flatten_expand(expand)
            }
          }

          if reflection.options[:decorator]
            reflection.options[:decorator].new(associated_object).to_hash(options)
          else
            associated_object.as_json(options)
          end
        end

        # Renders the unexpanded or expanded associations, depending on the +expand+ user option
        # passed to the decorator.
        #
        # @param expand [Array<String>] the associations to expand
        #
        # @return [Hash|Pragma::Decorator::Base]
        def render(expand)
          return unless associated_object

          expand ||= []

          if expand.any? { |value| value.to_s == reflection.property.to_s }
            expanded_hash(expand)
          else
            unexpanded_hash
          end
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
