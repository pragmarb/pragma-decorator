# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      # This is a generic class for all errors during association expansion.
      class ExpansionError < StandardError
      end

      # This is raised when a non-existing association is expanded.
      class AssociationNotFound < ExpansionError
        # @!attribute [r] property
        #   @return [String|Sybmol] the property the user tried to expand
        attr_reader :property

        # Initializes the rror.
        #
        # @param property [String|Symbol] the property the user tried to expand
        def initialize(property)
          @property = property
          super "The '#{property}' association is not defined."
        end
      end

      # This is raised when the user expanded a nested association without expanding its parent.
      class UnexpandedAssociationParent < ExpansionError
        # @!attribute [r] child
        #   @return [String|Symbol] the name of the child association
        #
        # @!attribute [r] parent
        #   @return [String|Symbol] the name of the parent association
        attr_reader :child, :parent

        # Initializes the error.
        #
        # @param child [String|Symbol] the name of the child association
        # @param parent [String|Symbol] the name of the parent association
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
