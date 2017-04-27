# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      class AssociationNotFound < StandardError
        attr_reader :property

        def initialize(property)
          @property = property
          super "The '#{property}' association is not defined."
        end
      end

      class UnexpandedAssociationParent < StandardError
        attr_reader :child, :parent

        def initialize(child, parent)
          @child = child
          @parent = parent

          super "The '#{child}' association is expanded, but its parent '#{parent}' is not."
        end
      end
    end
  end
end
