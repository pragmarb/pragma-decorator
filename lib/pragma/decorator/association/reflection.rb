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
        # @option options [Symbol] :exec_context (`decorated`) whether to call the getter on the
        #   decorator (+decorator+) or the decorated object (+decorated+)
        def initialize(type, property, **options)
          @type = type
          @property = property
          @options = options

          normalize_options
          validate_options
        end

        # Returns whether the association is expandable.
        #
        # @return [Boolean]
        def expandable?
          options[:expandable]
        end

        private

        def normalize_options
          @options = {
            expandable: false,
            render_nil: false,
            exec_context: :decorated
          }.merge(options).tap do |opts|
            opts[:exec_context] = opts[:exec_context].to_sym
          end
        end

        def validate_options
          return if [:decorator, :decorated].include?(options[:exec_context])

          fail(
            ArgumentError,
            "'#{options[:exec_context]}' is not a valid value for :exec_context."
          )
        end
      end
    end
  end
end
