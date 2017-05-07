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
    end
  end
end
