# frozen_string_literal: true

module Pragma
  module Decorator
    module Collection
      def self.included(klass)
        klass.include InstanceMethods
        klass.extend ClassMethods

        klass.class_eval do
          collection :represented, as: :data, exec_context: :decorator
        end
      end

      module InstanceMethods # :nodoc:
        def type
          'collection'
        end
      end

      module ClassMethods # :nodoc:
        def decorate_with(decorator)
          collection :represented, as: :data, exec_context: :decorator, decorator: decorator
        end
      end
    end
  end
end
