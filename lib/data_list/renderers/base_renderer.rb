module DataList
  module Renderers
    class BaseRenderer
      def initialize(collection, builder)
        @collection = collection
        @builder = builder
      end

      def render
        raise StandardError.new("Implement this method in your class")
      end

      protected
      def output_for_attribute(attribute)
        if attribute.is_a? Symbol
          @object.send attribute
        elsif attribute.is_a? String
          @object.send attribute.to_sym
        elsif attribute.is_a? Proc
          attribute.call(@object)
        else
          raise ArgumentError.new("#{attribute.class} type parameters are not supported by DataList")
        end
      end
    end
  end
end