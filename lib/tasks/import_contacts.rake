namespace :heyday do
  require 'csv'
  desc 'Import Contact Data From a CSV file into Database'
  task import_contacts: :environment do
    if ENV['CONTACT_FILE'].nil?
      puts "Please specify path argument like this 'rake heyday:import_contacts CONTACT_FILE=path_to_your_csv_file'."
    else
      file = File.read(ENV['CONTACT_FILE'])
      contacts = CSV.parse(file)
      contacts.shift
      contacts.each do |contact|
        if contact[1].present? and contact[2].present?
          directory_contact = Directory::Contact.find_or_initialize_by(first_name: contact[1], last_name: contact[2], email: contact[3] )
          if directory_contact.new_record?
            directory_contact.build_contact_detail
            directory_contact.company_title = contact[0]
            directory_contact.addresses.build(address1: contact[4], address2: contact[5], city: contact[6], state: contact[7], country: contact[8], zip: contact[9])
            directory_contact.company_phone = contact[10]
            directory_contact.phone = contact[11]
            directory_contact.phones.build(phone: contact[12], phone_type: 'Mobile')
            directory_contact.set_default_picture
            directory_contact.save
            puts '#####################################Contact Saved ########################################'
          end
        end
      end
    end
  end
end