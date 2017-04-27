# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      class Subscriber
        class << self
          def before_render(decorator, user_options:, **)
            check_parent_associations_are_expanded(decorator, expand: user_options[:expand])
            check_expanded_associations_exist(decorator, expand: user_options[:expand])
          end

          private

          def check_parent_associations_are_expanded(decorator, expand:)
            return unless decorator.class.respond_to?(:associations) && expand.is_a?(Array)

            expanded_properties = expand.map(&:to_s)

            expanded_properties.each do |property|
              next unless property.include?('.')

              parent_path = property.split('.')[0..-2].join('.')
              next if expanded_properties.include?(parent_path)

              fail Association::UnexpandedAssociationParent.new(property, parent_path)
            end
          end

          def check_expanded_associations_exist(decorator, expand:)
            return unless decorator.class.respond_to?(:associations) && expand.is_a?(Array)

            expanded_properties = expand.map(&:to_s)

            expanded_properties.each do |property|
              next if decorator.class.associations.key?(property.to_sym) || property.include?('.')
              fail Association::AssociationNotFound, property
            end
          end
        end
      end
    end
  end
end
