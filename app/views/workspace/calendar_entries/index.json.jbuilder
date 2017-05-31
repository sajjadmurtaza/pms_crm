json.array! @calendar_entries do |entry|
  json.id entry.id
  json.title strip_tags(entry.title)
  json.start entry.start_date
  json.end entry.end_date
  json.editable false
  json.textColor entry.reference.respond_to?(:status) ? entry.reference.status.value : 'black'
  json.color entry.reference.respond_to?(:status) ? 'white' : entry.calendar.color
  #json.color entry.reference.respond_to?(:status) ? entry.reference.status.value : entry.calendar.color
  json.type entry.reference_type
  json.reference_id entry.reference_id
  json.showUrl "/#{entry.reference_type.split('::').last.pluralize.downcase}/#{entry.reference_id}"
  json.className "calendar-#{entry.calendar.id}"
end