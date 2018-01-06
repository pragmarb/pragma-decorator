# frozen_string_literal: true

module Pragma
  module Decorator
    # Pagination provides support for including pagination metadata in your collection.
    #
    # It is particularly useful when used in conjunction with {Collection}.
    #
    # It supports both {https://github.com/kaminari/kaminari Kaminari} and
    # {https://github.com/mislav/will_paginate will_paginate}.
    #
    # @example Including pagination metadata
    #   class ArticlesDecorator < Pragma::Decorator::Base
    #     feature Pragma::Decorator::Collection
    #     feature Pragma::Decorator::Pagination
    #   end
    #
    #   # {
    #   #   "data": [
    #   #     { "...": "..." },
    #   #     { "...": "..." },
    #   #     { "...": "..." }
    #   #   ],
    #   #   "total_entries": 150,
    #   #   "per_page": 30,
    #   #   "total_pages": 5,
    #   #   "previous_page": 2,
    #   #   "current_page": 3,
    #   #   "next_page": 4
    #   # }
    #   ArticlesDecorator.new(Article.all).to_hash
    module Pagination
      module InstanceMethods # :nodoc:
        # Returns the current page of the collection.
        #
        # @return [Integer] current page number
        def current_page
          represented.current_page.to_i
        end

        # Returns the next page of the collection.
        #
        # @return [Integer|NilClass] next page number, if any
        def next_page
          represented.next_page
        end

        # Returns the number of items per page in the collection.
        #
        # @return [Integer] items per page
        def per_page
          per_page_method = if represented.respond_to?(:per_page)
            :per_page
          else
            :limit_value
          end

          represented.public_send(per_page_method)
        end

        # Returns the previous page of the collection.
        #
        # @return [Integer|NilClass] previous page number, if any
        def previous_page
          previous_page_method = if represented.respond_to?(:previous_page)
            :previous_page
          else
            :prev_page
          end

          represented.public_send(previous_page_method)
        end

        # Returns the total number of items in the collection.
        #
        # @return [Integer] number of items
        def total_entries
          total_entries_method = if represented.respond_to?(:total_entries)
            :total_entries
          else
            :total_count
          end

          represented.public_send(total_entries_method)
        end
      end

      def self.included(klass)
        klass.include InstanceMethods

        klass.class_eval do
          property :total_entries, exec_context: :decorator
          property :per_page, exec_context: :decorator
          property :total_pages
          property :previous_page, exec_context: :decorator
          property :current_page, exec_context: :decorator
          property :next_page, exec_context: :decorator
        end
      end
    end
  end
end
