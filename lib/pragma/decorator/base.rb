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
      include Wisper::Publisher

      feature Roar::JSON

      defaults render_nil: true

      def initialize(*)
        super

        broadcast(:after_initialize, self)
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

        broadcast(:before_render, self, options: options, user_options: user_options)

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
