# frozen_string_literal: true

module Pragma
  module Decorator
    # Adds a +type+ property containing the machine-readable type of the represented object.
    #
    # This is useful for the client to understand what kind of resource it's dealing with
    # and trigger related logic.
    #
    # @example Including the resource's type
    #   class ArticleDecorator < Pragma::Decorator::Base
    #     feature Pragma::Decorator::Type
    #   end
    #
    #   # {
    #   #   "type": "article"
    #   # }
    #   ArticleDecorator.new(article).to_hash
    module Type
      # Type overrides, to avoid exposing internal details of the app.
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
      # Takes any {TYPE_OVERRIDES} into account.
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
