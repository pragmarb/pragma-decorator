# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      # Adapters make associations ORM-independent by providing support for multiple underlying
      # libraries like ActiveRecord and simple POROs.
      #
      # @api private
      module Adapter
        # The list of supported adapters, in order of priority.
        SUPPORTED_ADAPTERS = [ActiveRecord, Poro].freeze

        # Loads the adapter for the given association bond.
        #
        # This will try {SUPPORTED_ADAPTERS} in order until it finds an adapter that supports the
        # bond's model. When the adapter is found, it will return a new instance of it.
        #
        # @param bond [Bond] the bond to load the adapter for
        #
        # @return [Adapter::Base]
        #
        # @see Adapter::Base.supports?
        def self.load_for(bond)
          SUPPORTED_ADAPTERS.find do |adapter|
            adapter.supports?(bond.model)
          end.new(bond)
        end
      end
    end
  end
end
