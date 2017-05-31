class ESSearch
  include ActiveData::Model

  # -------------------------------------------------------------
  # Provide search hash in format
  # {field_name: ["Search Value"]}
  # Special field_name '_all' will search on all text fields
  # -------------------------------------------------------------
  attribute :search_params, type: Hash, default: {}
  attribute :aggregate_params, type: Hash, default: {}
  attribute :filter_params, type: Hash, default: {}
  attribute :sort_params, type: Hash, default: {}

  attribute :klass, type: Object
  attribute :page, type: Integer, default: 1
  attribute :per_page, type: Integer, default: 10
  attribute :sort, type: String
  attribute :load_records, type: Boolean, default: true
  attribute :es_response, type: Object
  attribute :notable_id, type: Integer, default: nil
  attribute :notable_type, type: String, default: nil
  attribute :note_type_id, typpe: Integer, default: nil

  def search
    response = klass.__elasticsearch__.search([filtered_query, aggregates, sort_query].compact.reduce(:merge)).page(page).per(per_page)
    self.es_response = response.response
    if load_records
      response.records
    else
      response
    end
  end

  def filtered_query
    f_query = {
      "query" => {
        "filtered" => {
        }
      }
    }
    f_query["query"]["filtered"] = f_query["query"]["filtered"].merge(query)
    f_query["query"]["filtered"] = f_query["query"]["filtered"].merge(filters)
    f_query
  end

  def query
    query = {}.tap do |q|
      if search_params.keys.blank?
        q[:match_all] = {}
      else
        q[:bool] = {must: [], should: [], minimum_number_should_match: 1}
        search_params.keys.each do |search_key|
          if search_params[search_key].is_a? String
            search_query = "*#{search_params[search_key]}*"
            operator = 'OR'
          elsif search_params[search_key].is_a? Array
            search_query = search_params[search_key].map { |q| "*#{q}*" }.join(' OR ')
            operator = 'AND'
          end
          fields = (search_key == :_all ? search_text_fields : [search_key])
          q[:bool][:must] << {
              query_string: {query: search_query, default_operator: operator, fields: fields, allow_leading_wildcard: true}
          }
        end
      end
    end

    {query: query}
  end

  def filters
    # example filter params
    # filter_params = {"created_at"=>{"lte" => "2015-02-05"}}
    filter = {}.tap do |q|
      if !filter_params.keys.blank?
        q[:bool] = {must: []}
        filter_params.each do |field, conditions|
          conditions.each do |operator, value|
            q[:bool][:must] << {range: {"#{field}"=> {"#{operator}"=> "#{value}"}}}
          end
        end
      end
    end
    {filter: filter}
  end

  def sort_query
    sort = [].tap do |s|
      sort_params.each do |field, order|
        s << {"#{field}" => {'order' => "#{order}"}}
      end
    end
    {sort: sort}
    # {sort: [{'created_date' => {'order' => 'Done any discusii'}}]}
  end

  def aggregates
    query = {aggregations: {}, filter: {}}

    klass.filter_options[:filter_aggregates].each do |aggr|
      query[:aggregations][aggr[:key]] = {terms: {field: aggr[:key]}}
    end

    self.aggregate_params.keys.each do |key|
      query[:filter] = {terms: {key => self.aggregate_params[key]}}
    end

    unless notable_id.blank? or notable_type.blank?
      query[:filter] = {and: [{term: {notable_id: notable_id}}, {term: {notable_type: notable_type}}]}
    end
    query
  end

  def init_params(params, paginate=true)
    puts '################checking##########'
    puts params
    puts '##########################'
    query = params["q"] || {}
    query = query.to_hash.deep_symbolize_keys
    self.search_params = query[:search_params] if query[:search_params]
    self.aggregate_params = query[:aggregate_params] if query[:aggregate_params]
    self.filter_params = query[:filter_params] if query[:filter_params]
    self.sort_params = query[:sort_params] if query[:sort_params]
    if paginate
      self.per_page = params[:per_page]
      self.page = params[:page]
    end
    self.notable_id = params[:notable_id]
    self.notable_type = params[:notable_type]
    self.note_type_id = params[:note_type_id]
  end

  def to_param
    {search_params: self.search_params, aggregate_params: self.aggregate_params}.to_param
  end

  private

  # return array of model attributes to search on
  def search_text_fields
    klass.filter_options[:filter_box].collect { |hash| hash[:key] }
    #self.content_columns.select {|c| [:string,:text].include?(c.type) }.map {|c| c.name }
  end

  # return array of model attributes to facet
  def search_aggregate_fields
    klass.filter_options[:filter_aggregates].collect { |hash| hash[:key] }
  end
end