# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      module Adapter
        # The ActiveRecord association adapter is used in AR environments and tries to minimize the
        # number of SQL queries that are made to retrieve the associated object's data.
        #
        # @api private
        class ActiveRecord < Base
          class << self
            # Returns whether the adapter supports the given model.
            #
            # @param model [Object] the model to check
            #
            # @return [Boolean] whether the object is an instance of +ActiveRecord::Base+
            def supports?(model)
              Object.const_defined?('ActiveRecord::Base') && model.is_a?(ActiveRecord::Base)
            end
          end

          # Initializes the adapter.
          #
          # @param bond [Bond] the bond to use in the adapter
          #
          # @raise [InconsistentTypeError] when the association's real type is different from the
          #   one defined on the decorator ()e.g. decorator defines the association as +belongs_to+,
          #   but ActiveRecord reports its type is +has_one+)
          def initialize(bond)
            super
            check_type_consistency
          end

          # Returns the primary key of the associated object.
          #
          # If the +exec_context+ of the association is +decorator+, this will simply return early
          # with the value returned by +#id+ on the associated object.
          #
          # If the association is a +belongs_to+, this will compute the PK by calling the foreign
          # key on the parent model (e.g. +Article#author_id+).
          #
          # If the association is a +has_one+ and it has already been loaded, this will compute the
          # PK by retrieving the PK attribute from the loaded object (e.g. +user.avatar.id+), since
          # it will not trigger a new query.
          #
          # If the association is a +has_one+ and it has not been loaded, this will compute the PK
          # by +pluck+ing the PK column of the associated object (e.g.
          # +Avatar.where(user_id: user.id).pluck(:id).first+).
          #
          # +nil+ values are handled gracefully in all cases.
          #
          # @return [String|Integer|NilClass] the PK of the associated object
          #
          # @todo Allow to specify a different PK attribute when +exec_context+ is +decorator+
          def primary_key
            return associated_object&.id if reflection.options[:exec_context] == :decorator

            case reflection.type
            when :belongs_to
              compute_belongs_to_primary_key
            when :has_one
              compute_has_one_primary_key
            else
              fail "Cannot compute primary key for #{reflection.type} association"
            end
          end

          # Returns the expanded associated object.
          #
          # This will simply return the associated object itself, delegating caching to AR.
          #
          # @return [Object] the associated object
          #
          # @todo Ensure the required attributes are present on the associated object
          def full_object
            associated_object
          end

          private

          def compute_belongs_to_primary_key
            model.public_send(model_reflection.foreign_key)
          end

          def compute_has_one_primary_key
            if model.association(reflection.property).loaded?
              return associated_object&.public_send(associated_object.class.primary_key)
            end

            pk = model.public_send(association_reflection.active_record_primary_key)

            association_reflection
              .klass
              .where(association_reflection.foreign_key => pk)
              .pluck(association_reflection.klass.primary_key)
              .first
          end

          def association_reflection
            @association_reflection ||= model.class.reflect_on_association(reflection.property)
          end

          def check_type_consistency
            return if association_reflection.macro.to_sym == reflection.type.to_sym

            fail InconsistentTypeError.new(
              decorator: decorator,
              reflection: reflection,
              model_type: association_reflection.macro
            )
          end
        end
      end
    end
  end
end
