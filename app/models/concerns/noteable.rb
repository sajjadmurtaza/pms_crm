module Noteable
  extend ActiveSupport::Concern

  included do
    has_many :notes, class_name: 'Core::Note', as: :notable
    after_destroy :remove_notes, :remove_calendar_entries
  end

  def remove_notes
    notes = Core::Note.where(notable: self)
    notes.destroy_all unless notes.nil?
  end

  def remove_calendar_entries
    entries = Workspace::CalendarEntry.where(reference: self)
    entries.destroy_all unless entries.nil?
    puts entries.inspect
  end

end