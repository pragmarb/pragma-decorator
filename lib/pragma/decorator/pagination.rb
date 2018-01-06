# frozen_string_literal: true

module Pragma
  module Decorator
    module Pagination
      module InstanceMethods # :nodoc:
        def current_page
          represented.current_page.to_i
        end

        def next_page
          represented.next_page
        end

        def per_page
          per_page_method = if represented.respond_to?(:per_page)
            :per_page
          else
            :limit_value
          end

          represented.public_send(per_page_method)
        end

        def previous_page
          previous_page_method = if represented.respond_to?(:previous_page)
            :previous_page
          else
            :prev_page
          end

          represented.public_send(previous_page_method)
        end

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
