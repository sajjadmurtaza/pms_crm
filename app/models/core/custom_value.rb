# == Schema Information
#
# Table name: core_custom_values
#
#  id              :integer          not null, primary key
#  customized_id   :integer
#  customized_type :string(255)
#  custom_field_id :integer
#  value           :text
#  created_at      :datetime
#  updated_at      :datetime
#

class Core::CustomValue < ActiveRecord::Base
  belongs_to :custom_field, class_name: 'Core::CustomField'
  belongs_to :customized, polymorphic: true
  delegate :name, :field_format, :possible_values, :form_input_format, :editable?, :required?, :searchable?, :scheduleable?, to: :custom_field

  after_initialize :set_default_value
  after_save :make_calendar_entries
  after_destroy :remove_calendar_entries
  validate :validate_presence_of_required_value,
           :validate_format_of_value,
           :validate_type_of_value,
           :validate_length_of_value


  def set_default_value
    if new_record? && custom_field && (customized_type.blank? || (customized && customized.new_record?))
      self.value ||= custom_field.default_value
    end
  end

  def to_s
    value.to_s
  end

  private
  def validate_presence_of_required_value
    errors.add(:value, :blank) if required? && value.blank?
  end

  def validate_format_of_value
    if value.present?
      errors.add(:value, :invalid) unless custom_field.regexp.blank? or value =~ Regexp.new(custom_field.regexp)
    end
  end

  def validate_type_of_value
    if value.present?
      # Format specific validations
      case custom_field.field_format
        when 'int'
          errors.add(:value, :not_a_number) unless value =~ /\A[+-]?\d+\z/
        when 'float'
          begin
            ; Kernel.Float(value);
          rescue;
            errors.add(:value, :invalid)
          end
        when 'date'
          errors.add(:value, :not_a_date) unless value =~ /\A\d{4}-\d{2}-\d{2}\z/
        when 'list'
          errors.add(:value, :inclusion) unless custom_field.possible_values.include?(value)
      end
    end
  end

  def validate_length_of_value
    if value.present?
      errors.add(:value, :too_short, :count => custom_field.min_length) if custom_field.min_length > 0 and value.length < custom_field.min_length
      errors.add(:value, :too_long, :count => custom_field.max_length) if custom_field.max_length > 0 and value.length > custom_field.max_length
    end
  end

  def make_calendar_entries
    if scheduleable? and field_format == 'date'
      calendar_title = custom_field.meta.match(/\[calendar_title:(.*)\]/)[1]
      calendar = Workspace::Calendar.find_or_create_by(name: calendar_title, system_user_id: Core::EmbeddedUser.find_by_username('system_user').id)
      if calendar.new_record?
        calendar.color =  '#F15F74 '
      end
      entry = Workspace::CalendarEntry.new
      entry.title = "#{Core::NoteType.find(customized.note_type_id).try(:name)} : #{customized.notable.send(:calendar_entry_title)} "
      entry.description = customized.content
      entry.reference = customized.notable
      entry.calendar = calendar
      entry.start_date = Date.parse(value)
      entry.end_date = Date.parse(value)
      entry.save
    end
  end

  def remove_calendar_entries
    if scheduleable? and field_format == 'date'
      calendar_title = custom_field.meta.match(/\[calendar_title:(.*)\]/)[1]
      calendar = Workspace::Calendar.find_or_create_by(name: calendar_title, system_user_id: Core::EmbeddedUser.find_by_username('system_user').id)
      entry = Workspace::CalendarEntry.where(reference: customized.notable, calendar: calendar).first
      entry.destroy if entry
    end
  end
end
