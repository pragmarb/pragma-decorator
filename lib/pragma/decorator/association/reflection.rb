# frozen_string_literal: true
module Pragma
  module Decorator
    module Association
      # Holds the information about an association.
      #
      # @author Alessandro Desantis
      class Reflection
        # @!attribute [r] type
        #   @return [Symbol] the type of the association
        #
        # @!attribute [r] property
        #   @return [Symbol] the property holding the associated object
        #
        # @!attribute [r] options
        #   @return [Hash] additional options for the association
        attr_reader :type, :property, :options

        # Initializes the association.
        #
        # @param type [Symbol] the type of the association
        # @param property [Symbol] the property holding the associated object
        # @param options [Hash] additional options
        #
        # @option options [Boolean] :expandable (`false`) whether the association is expandable
        # @option options [Class] :decorator the decorator to use for the associated object
        # @option options [Boolean] :render_nil (`true`) whether to render a +nil+ association
        def initialize(type, property, **options)
          @type = type
          @property = property
          @options = options
        end

        # Renders the unexpanded or expanded associations, depending on the +expand+ user option
        # passed to the decorator.
        #
        # @param expand [Array|Hash] the associations to expand for this representation
        #
        # @return [Hash|Pragma::Decorator::Base]
        def render(_user_options)
          {
            id: @decorator.decorated.send(property).id
          }
        end
      end
    end
  end
end
