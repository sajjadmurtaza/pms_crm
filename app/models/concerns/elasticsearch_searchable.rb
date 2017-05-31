require 'active_support/concern'

module ElasticsearchSearchable
  extend ActiveSupport::Concern

  # Search model instance code:
  included do

    # require and include Elasticsearch libraries
    require 'elasticsearch/model'
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    include Elasticsearch::Model::Indexing

    # debug logging
    if Rails.env == 'development'
      Elasticsearch::Model.client = Elasticsearch::Client.new log: true
    end

    # index document on model touch
    # @see: http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
    # after_touch() { __elasticsearch__.index_document }
    after_update :update_index

    def update_index
      attributes_require_update = ['first_name', 'last_name', 'invoice_project', 'email', 'title']
      attributes_changed = self.changed
      attribute_matches = attributes_require_update & attributes_changed
      if !attribute_matches.empty?
        self.class.find(self.id).__elasticsearch__.update_document
      end
    end

    # Customize the JSON serialization for Elasticsearch
    def as_indexed_json(options={})

      # define JSON structure (including nested model associations)
      _include = self.class.reflect_on_all_associations.each_with_object({}) { |a, hsh|
        hsh[a.name] = {}
        hsh[a.name][:only] = a.klass.attribute_names
      }

      self.as_json(include: _include)
    end

  end
end
