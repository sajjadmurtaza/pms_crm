json.array!(@events )do |event|
json.extract! event, :id, :title, :calendar_id
json.start event.start
json.end event.end
json.url nil
end