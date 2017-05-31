json.array!(@core_quotes) do |core_quote|
  json.extract! core_quote, :id, :price, :description, :split_type_id, :quote_date, :project_id, :lead_id, :reference_id, :reference_type
  json.url core_quote_url(core_quote, format: :json)
end
