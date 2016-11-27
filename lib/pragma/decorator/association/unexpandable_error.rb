# frozen_string_literal: true
module Pragma
  module Decorator
    module Association
      # This error is raised when expansion of an unexpandable association is attempted.
      #
      # @author Alessandro Desantis
      class UnexpandableError < StandardError
        # Initializes the error.
        #
        # @param reflection [Reflection] the unexpandable association
        def initialize(reflection)
          super "Association '#{reflection.property}' cannot be expanded."
        end
      end
    end
  end
end
