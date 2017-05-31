# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Seeding contacts

#Creating Email Types
['Primary', 'Secondary'].each_with_index do |email_type, index|
  Core::Enumeration.create(name: email_type, value: index, type: 'Core::EmailType')
end

#Creating Phone Types
['Mobile', 'Office', 'Home'].each_with_index do |phone_type, index|
  Core::Enumeration.create(name: phone_type, value: index, type: 'Core::PhoneType')
end

#Creating Skill Types
['Languages', 'Frameworks', 'Tools'].each_with_index do |skill_type, index|
  Core::Enumeration.create(name: skill_type, value: index, type: 'Core::SkillType')
end

#Creating job titles
['Developer', 'Graphic Designer', 'Business Analyst', 'UI Engineer'].each_with_index do |job_title, index|
  Core::Enumeration.create(name: job_title, value: index, type: 'Core::JobTitle')
end

#Creating Location
Core::Enumeration.create(name: 'Lahore Center D2', value: 1, type: 'Core::Location')

#Creating job titles
['Adwords', 'Call', 'Email', 'Website'].each_with_index do |source, index|
  Core::Enumeration.create(name: source, value: index, type: 'Core::Source')
end

Directory::Contact.destroy_all
10.times do
  contact = Directory::Contact.new
  contact.build_contact_detail
  contact.first_name = Faker::Name.first_name
  contact.last_name = Faker::Name.last_name
  contact.contact_detail.nick_name = contact.first_name
  contact.contact_detail.company_title = Faker::Company.name
  contact.contact_detail.company_email = Faker::Internet.email
  contact.contact_detail.company_phone = Faker::PhoneNumber.cell_phone
  contact.contact_detail.skype = 'random.skype'
  contact.email = Faker::Internet.email(contact.first_name)

  contact.emails.build(email: Faker::Internet.email(contact.first_name), email_type: Core::EmailType.first.name)
  contact.phones.build(phone: Faker::PhoneNumber.cell_phone, phone_type: Core::PhoneType.first.name)

  contact.addresses.build(
      address1: Faker::Address.street_address,
      address2: Faker::Address.secondary_address,
      country: Faker::Address.country,
      state: Faker::Address.state,
      zip: Faker::Address.zip,
      city: Faker::Address.city
  )
  contact.save
  contact.set_default_picture
end

Directory::User.destroy_all
10.times do
  user = Directory::User.new
  user.build_user_detail
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.email = Faker::Internet.email
  user.phone = Faker::PhoneNumber.cell_phone
  user.username= Faker::Internet.user_name
  user.password='password'
  user.user_detail.emp_id = user.first_name + user.last_name
  user.user_detail.education = 'BS(CS)'
  user.user_detail.experience = '3 Years'

  user.emails.build(email: Faker::Internet.email(user.first_name), email_type: Core::EmailType.first.name)
  user.phones.build(phone: Faker::PhoneNumber.cell_phone, phone_type: Core::PhoneType.first.name)

  user.addresses.build(
      address1: Faker::Address.street_address,
      address2: Faker::Address.secondary_address,
      country: Faker::Address.country,
      state: Faker::Address.state,
      zip: Faker::Address.zip,
      city: Faker::Address.city
  )
  user.save
  user.set_default_picture
end

Directory::Account.destroy_all
10.times do
  account = Directory::Account.new
  account.account_number = Faker::Business.credit_card_number
  account.title = Faker::Name.title
  account.email = Faker::Internet.email(account.title)
  account.save
end

Crm::Lead.destroy_all
10.times do
  lead = Crm::Lead.new
  lead.first_name = Faker::Name.first_name
  lead.last_name = Faker::Name.last_name
  lead.email = Faker::Internet.email
  lead.phone = Faker::PhoneNumber.cell_phone
  lead.description= Faker::Lorem.sentence
  lead.skype = 'random.skype'
  lead.user = Directory::User.first
  lead.assigned_contacts << Directory::Contact.first
  lead.save
end

Core::Role.destroy_all
['Employee', 'Development Manager', 'Project Manager', 'Team Lead', 'Developer'].each do |role|
  Core::Role.create(name: role)
end

Core::NoteType.destroy_all
Core::NoteType.create(name: 'Update', default: true)
['simple', 'awesome', 'diary'].each do |note|
  Core::NoteType.create(name: note)
end

Core::OrganizationUnit.destroy_all
Core::OrganizationUnit.create(title:'Verticals', role: 'Sample/Role')

Pms::Project.destroy_all
5.times do
  project = Pms::Project.new
  project.title = "#{Faker::Name.title} Project"
  project.description = Faker::Lorem.sentence

  project.user = Directory::User.find( rand(Directory::User.first.id..Directory::User.last.id))
  project.manager = Directory::User.find( rand(Directory::User.first.id..Directory::User.last.id))
  project.account = Directory::Account.find( rand(Directory::Account.first.id..Directory::Account.last.id))
  2.times do
    project.assigned_users << Directory::User.find(rand(Directory::User.first.id..Directory::User.last.id))
    project.assigned_contacts << Directory::Contact.find(rand(Directory::Contact.first.id..Directory::Contact.last.id))
  end

end
