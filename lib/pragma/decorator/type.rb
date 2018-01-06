# frozen_string_literal: true

module Pragma
  module Decorator
    # Adds a +type+ property containing the machine-readable type of the represented object.
    #
    # @author Alessandro Desantis
    module Type
      TYPE_OVERRIDES = {
        'array' => 'list',
        'active_record::relation' => 'list'
      }.freeze

      def self.included(klass)
        klass.class_eval do
          property :type, exec_context: :decorator, render_nil: false
        end
      end

      # Returns the type of the decorated object (i.e. its underscored class name).
      #
      # @return [String]
      def type
        type = decorated.class.name
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .downcase

        TYPE_OVERRIDES[type] || type
      end
    end
  end
end
