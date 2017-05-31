namespace :heyday do
  require 'json'
  require 'csv'
  desc 'Import Lead Data From a JSON file into Database'
  task import_leads: :environment do
    if ENV['LEAD_FILE_JSON'].nil? and ENV['LEAD_FILE_CSV'].nil?
      puts "Please specify path argument like this 'rake heyday:import_leads LEAD_FILE_JSON=path_to_your_json_file LEAD_FILE_CSV=path_to_your_csv_file'."
    else
      csv_file = File.read(ENV['LEAD_FILE_CSV'])
      csv = CSV.parse(csv_file, :headers => true)

      json_file = File.read(ENV['LEAD_FILE_JSON'])
      json_data = JSON.parse(json_file)
      json_data.each do |record|
        # lead = Crm::Lead.find_or_initialize_by(first_name: record['name'].split(' ').first, last_name: record['name'].split(' ').last,  email: record['contacts'].first['primary_email'] )
        lead = Crm::Lead.create(first_name: record['name'].split(' ').first, last_name: record['name'].split(' ').last,  email: record['contacts'].first['primary_email'] )
        # if lead.new_record?
        lead.created_at = record['created_at'],
            lead.user = Directory::User.find_or_initialize_by(first_name: record['created_by'].split(' ').first)
        if lead.user.new_record?
          lead.user.last_name = record['created_by'].split(' ').last
          lead.user.set_default_picture
          lead.user.save(validate:false)
        end

        csv_status = csv.find {|row| row['Name'] == record['name']}
        status = csv_status['New Status'].present? ? csv_status['New Status'] : csv_status['Status']

        lead.send "#{lead.state_column}=", status

        lead.technology_list.add(record['technology'])
        lead.save

        record['notes'].each do |record_note|
          note = Core::Note.new(content: record_note['note_content'], notable: lead, note_type: Core::NoteType.find_by_name(record_note['type']), created_at: record_note['created_at'], updated_at: record_note['updated_at'])
          note.user = Directory::User.find_or_initialize_by(first_name: record_note['created_by'].split(' ').first)
          if note.user.new_record?
            note.user.last_name = record_note['created_by'].split(' ').last
            note.user.set_default_picture
            note.user.save(validate:false)
          end
          note.save
          puts 'Saved Note'
        end

        record['contacts'].each do |record_contact|
          contact = Directory::Contact.find_or_initialize_by(email: record['contacts'].first['primary_email'])
          contact.build_contact_detail unless contact.contact_detail.present?
          if contact.new_record?
            record_contact['first_name'].blank? ? contact.first_name = 'Not Specified' : contact.first_name = record_contact['first_name']
            record_contact['last_name'].blank? ? contact.last_name = 'Not Specified' : contact.last_name = record_contact['last_name']
            contact.created_at = record_contact['created_at'] unless record_contact['created_at'].nil?
            contact.created_at = record_contact['updated_at'] unless record_contact['updated_at'].nil?
            contact.emails << Core::Email.new(emailable: contact, email: record_contact['secondary_email'].nil? ? 'Not Specified' : record_contact['secondary_email'] , email_type: 'Secondary')
            contact.phones << Core::Phone.new(phoneable: contact, phone: record_contact['home_phone'].nil? ? 'Not Specified' : record_contact['home_phone'] , phone_type: 'Home')
            contact.set_default_picture
          end

          contact.email = record_contact['primary_email']
          contact.phone = record_contact['office_phone']

          record_contact['primary_skype_id'].nil? ? contact.skype = 'Not Specified' : contact.skype = record_contact['primary_skype_id']
          contact.save

          if !lead.assigned_contacts.include? contact
            lead.assigned_contacts << contact
          end
          puts 'Saved Contact'
        end

        lead.save
        puts 'Saved Lead'
        puts '####################################'
        # end
      end
    end
  end
end
