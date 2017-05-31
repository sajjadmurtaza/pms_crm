module DataList
  module DataListHelper
    def data_listing_for(collection, options={}, &block)
      # Two options available Grid or Table
      show_as = options[:show_as] || 'grid'
      builder = DataList::DataListBuilder.new
      yield(builder, block)
      renderer = show_as == 'table' ? DataList::Renderers::TableRenderer : DataList::Renderers::GridRenderer
      renderer.new(collection, builder).render
    end
  end
end
