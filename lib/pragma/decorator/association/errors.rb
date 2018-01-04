# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      class ExpansionError < StandardError
      end

      class AssociationNotFound < ExpansionError
        attr_reader :property

        def initialize(property)
          @property = property
          super "The '#{property}' association is not defined."
        end
      end

      class UnexpandedAssociationParent < ExpansionError
        attr_reader :child, :parent

        def initialize(child, parent)
          @child = child
          @parent = parent

          super "The '#{child}' association is expanded, but its parent '#{parent}' is not."
        end
      end

      # This error is raised when an association's type is different from its type as reported by
      # the model's reflection.
      #
      # @author Alessandro Desantis
      class InconsistentTypeError < StandardError
        # Initializes the error.
        #
        # @param decorator [Base] the decorator where the association is defined
        # @param reflection [Reflection] the reflection of the inconsistent association
        # @param model_type [Symbol|String] the real type of the association
        def initialize(decorator:, reflection:, model_type:)
          message = <<~MSG.tr("\n", ' ')
            #{decorator.class}: Association #{reflection.property} is defined as #{model_type} on
            the model, but as #{reflection.type} in the decorator.
          MSG

          super message
        end
      end
    end
  end
end
