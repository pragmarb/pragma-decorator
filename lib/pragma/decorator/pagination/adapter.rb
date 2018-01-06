# frozen_string_literal: true

module Pragma
  module Decorator
    module Pagination
      # Adapters make pagination library-independent by providing support for multiple underlying
      # libraries like Kaminari and will_paginate.
      #
      # @api private
      module Adapter
        # The list of supported adapters, in order of priority.
        SUPPORTED_ADAPTERS = [Kaminari, WillPaginate].freeze

        # Loads the adapter for the given collection.
        #
        # This will try {SUPPORTED_ADAPTERS} in order until it finds an adapter that supports the
        # collection. When the adapter is found, it will return a new instance of it.
        #
        # @param collection [Object] the collection to load the adapter for
        #
        # @return [Adapter::Base]
        #
        # @see Adapter::Base.supports?
        #
        # @raise [AdapterError] if no adapter supports the collection
        def self.load_for(collection)
          adapter_klass = SUPPORTED_ADAPTERS.find do |klass|
            klass.supports?(collection)
          end

          fail NoAdapterError unless adapter_klass

          adapter_klass.new(collection)
        end

        # This error is raised when no adapter can be found for a collection.
        class NoAdapterError < StandardError
          # Initializes the adapter.
          def initialize
            message = <<~MESSAGE.tr("\n", ' ')
              No adapter found for the collection. The available adapters are:
              #{SUPPORTED_ADAPTERS.map { |a| a.to_s.split('::').last }.join(', ')}.
            MESSAGE

            super message
          end
        end
      end
    end
  end
end
