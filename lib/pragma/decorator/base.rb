# frozen_string_literal: true
require 'roar/decorator'
require 'roar/json'

module Pragma
  module Decorator
    # This is the base decorator that all your resource-specific decorators should extend from.
    #
    # It is already configured to render your resources in JSON.
    #
    # @author Alessandro Desantis
    class Base < Roar::Decorator
      feature Roar::JSON

      property :type, exec_context: :decorator, render_nil: false

      # Returns the type of the decorated object (i.e. its underscored class name).
      #
      # @return [String]
      def type
        decorated.class.name
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .downcase
      end

      # Overrides Representable's default +#to_hash+ to save the last options the method was run
      # with.
      #
      # This allows accessing the options from property getters and is required by {Association}.
      #
      # @param options [Hash]
      #
      # @return [Hash]
      def to_hash(options = {}, *args)
        @last_options = options
        super(options, *args)
      end

      protected

      # Returns the options +#to_hash+ was last run with.
      #
      # @return [Hash]
      def options
        @last_options
      end

      # Returns the user options +#to_hash+ was last run with.
      #
      # @return [Hash]
      #
      # @see #options
      def user_options
        @last_options[:user_options] || {}
      end
    end
  end
end
