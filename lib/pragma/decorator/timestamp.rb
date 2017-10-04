# frozen_string_literal: true

module Pragma
  module Decorator
    # Supports rendering timestamps as UNIX times.
    #
    # @author Alessandro Desantis
    module Timestamp
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods # rubocop:disable Style/Documentation
        # Defines a timestamp property which will be rendered as UNIX time.
        #
        # @param name [Symbol] the name of the property
        # @param options [Hash] the options of the property
        def timestamp(name, options = {})
          create_timestamp_getter(name, options)
          create_timestamp_property(name, options)
        end

        private

        def create_timestamp_getter(name, options = {})
          define_method "_#{name}_timestamp" do
            if options[:exec_context]&.to_sym == :decorator
              send(name)
            else
              decorated.send(name)
            end&.to_i
          end
        end

        def create_timestamp_property(name, options = {})
          property "_#{name}_timestamp", options.merge(
            as: options[:as] || name,
            exec_context: :decorator
          )
        end
      end
    end
  end
end
