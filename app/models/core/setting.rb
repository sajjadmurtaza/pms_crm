# == Schema Information
#
# Table name: core_settings
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  value      :text
#  updated_on :datetime
#
# Indexes
#
#  index_core_settings_on_name  (name)
#

class Core::Setting < ActiveRecord::Base
  audited
  validates_uniqueness_of :name
  validates_inclusion_of :name, :in => lambda { |setting| @@available_settings.keys } # lambda, because @available_settings changes at runtime
  validates_numericality_of :value, :only_integer => true, :if => Proc.new { |setting| @@available_settings[setting.name]['format'] == 'int' }

  DATE_FORMATS = [
      '%Y-%m-%d',
      '%d/%m/%Y',
      '%d.%m.%Y',
      '%d-%m-%Y',
      '%m/%d/%Y',
      '%d %b %Y',
      '%d %B %Y',
      '%b %d, %Y',
      '%B %d, %Y'
  ]

  TIME_FORMATS = [
      '%H:%M',
      '%I:%M %p'
  ]

  cattr_accessor :available_settings

  def self.create_setting(name, value = nil)
    @@available_settings[name] = value
  end

  def self.create_setting_accessors(name)
    # Defines getter and setter for each setting
    # Then setting values can be read using: Setting.some_setting_name
    # or set using Setting.some_setting_name = "some value"
    src = <<-END_SRC
      def self.#{name}
        # when runnung too early, there is no settings table. do nothing
        self[:#{name}]
      end

      def self.#{name}?
        # when runnung too early, there is no settings table. do nothing
        self[:#{name}].to_i > 0
      end

      def self.#{name}=(value)
          self[:#{name}] = value
      end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end

  @@available_settings = YAML::load(File.open(Rails.root.join('config/settings.yml')))

  # Defines getter and setter for each setting
  # Then setting values can be read using: Setting.some_setting_name
  # or set using Setting.some_setting_name = "some value"
  @@available_settings.each do |name, params|
    self.create_setting_accessors(name)
  end

  def value
    v = read_attribute(:value)
    # Unserialize serialized settings
    v = YAML::load(v) if @@available_settings[name]['serialized'] && v.is_a?(String)
    v = v.to_sym if @@available_settings[name]['format'] == 'symbol' && !v.blank?
    v
  end

  def value=(v)
    v = v.to_yaml if v && @@available_settings[name] && @@available_settings[name]['serialized']
    write_attribute(:value, v.to_s)
  end

  # Returns the value of the setting named name
  def self.[](name)
    Marshal.load(Rails.cache.fetch(self.cache_key(name)) { Marshal.dump(find_or_default(name).value) })
  end

  def self.[]=(name, v)
    setting = find_or_default(name)
    setting.value = (v ? v : "")
    Rails.cache.delete(cache_key(name))
    setting.save
    setting.value
  end

  def self.cache_key(name)
    return name
    # RequestStore.store[:settings_updated_on] ||= Setting.maximum(:updated_on)
    # most_recent_settings_change = (RequestStore.store[:settings_updated_on] || Time.now.utc).to_i
    # base_cache_key(name, most_recent_settings_change)
  end


  # Check whether a setting was defined
  def self.exists?(name)
    @@available_settings.has_key?(name)
  end

  private
  # Returns the Setting instance for the setting named name
  # (record found in database or new record with default value)
  def self.find_or_default(name)
    name = name.to_s
    raise "There's no setting named #{name}" unless exists? name
    find_by_name(name) or new do |s|
      s.name = name
      s.value = @@available_settings[name]['default']
    end
  end
end
