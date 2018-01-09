# frozen_string_literal: true

module Pragma
  module Decorator
    # This module is used to represent collections of objects.
    #
    # It will wrap the collection in a +data+ property so that you can include meta-data about the
    # collection at the root level.
    #
    # @example Using Collection to include a total count
    #   class ArticlesDecorator < Pragma::Decorator::Base
    #     include Pragma::Decorator::Collection
    #
    #     decorate_with ArticleDecorator
    #
    #     property :total_count, exec_context: :decorator
    #
    #     def total_count
    #       represented.count
    #     end
    #   end
    #
    #   # {
    #   #   "data": [
    #   #     { "...": "..." },
    #   #     { "...": "..." },
    #   #     { "...": "..." }
    #   #   ],
    #   #   "total_count": 150
    #   # }
    #   ArticlesDecorator.new(Article.all).to_hash
    module Collection
      def self.included(klass)
        klass.include InstanceMethods
        klass.extend ClassMethods

        klass.class_eval do
          collection :represented, as: :data, exec_context: :decorator
        end
      end

      module InstanceMethods # :nodoc:
        # Overrides the type of the resource to be +list+, for compatibility with {Type}.
        #
        # @see Type
        def type
          'list'
        end
      end

      module ClassMethods # :nodoc:
        # Defines the decorator to use for each resource in the collection.
        #
        # @param decorator [Class] a decorator class
        #
        # @todo Accept a callable/block or document how to decorate polymorphic collections
        def decorate_with(decorator)
          collection :represented, as: :data, exec_context: :decorator, decorator: decorator
        end
      end
    end
  end
end
