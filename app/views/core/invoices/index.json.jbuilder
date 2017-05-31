json.array!(@core_invoices) do |core_invoice|
  json.extract! core_invoice, :id, :due_date, :organization_unit_id, :project, :task, :cost, :split_type_id
  json.url core_invoice_url(core_invoice, format: :json)
end
