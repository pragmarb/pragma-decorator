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

      def to_hash(options = {}, binding_builder = Representable::Hash::Binding)
        @last_options = options
        super(options, binding_builder)
      end

      def options
        @last_options
      end

      def user_options
        @last_options[:user_options] || {}
      end
    end
  end
end
