# frozen_string_literal: true

module Pragma
  module Decorator
    module Collection
      def self.included(klass)
        klass.extend ClassMethods

        klass.class_eval do
          collection :represented, as: :data, exec_context: :decorator
        end
      end

      module ClassMethods
        def decorate_with(decorator)
          collection :represented, as: :data, exec_context: :decorator, decorator: decorator
        end
      end
    end
  end
end
