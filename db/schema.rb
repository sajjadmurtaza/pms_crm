# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150217094342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: true do |t|
    t.string  "name"
    t.integer "fileable_id"
    t.string  "fileable_type"
  end

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "core_addresses", force: true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "address_type"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.string   "country"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_comments", ["commentable_id"], name: "index_core_comments_on_commentable_id", using: :btree
  add_index "core_comments", ["commentable_type"], name: "index_core_comments_on_commentable_type", using: :btree
  add_index "core_comments", ["user_id"], name: "index_core_comments_on_user_id", using: :btree

  create_table "core_custom_fields", force: true do |t|
    t.string   "type",            limit: 30, default: "",    null: false
    t.string   "field_format",    limit: 30, default: "",    null: false
    t.string   "regexp",                     default: ""
    t.integer  "min_length",                 default: 0,     null: false
    t.integer  "max_length",                 default: 0,     null: false
    t.boolean  "required",                   default: false
    t.boolean  "editable",                   default: true
    t.boolean  "searchable",                 default: false
    t.boolean  "scheduleable",               default: false
    t.string   "name",                                       null: false
    t.text     "default_value"
    t.text     "possible_values"
    t.integer  "position",                   default: 0
    t.text     "meta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_custom_fields", ["type"], name: "index_core_custom_fields_on_type", using: :btree

  create_table "core_custom_values", force: true do |t|
    t.integer  "customized_id"
    t.string   "customized_type"
    t.integer  "custom_field_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_emails", force: true do |t|
    t.string   "email"
    t.string   "email_type"
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_enumerations", force: true do |t|
    t.string   "name",       null: false
    t.string   "value"
    t.string   "type"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_invoices", force: true do |t|
    t.date     "due_date"
    t.integer  "organization_unit_id"
    t.text     "invoice_project"
    t.text     "invoice_task"
    t.float    "cost"
    t.integer  "split_type_id"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.integer  "project_id"
    t.integer  "lead_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.integer  "user_id"
    t.integer  "task_list_id"
  end

  create_table "core_note_types", force: true do |t|
    t.string   "name"
    t.boolean  "default",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_note_types_associations", force: true do |t|
    t.integer  "note_type_id"
    t.integer  "association_id"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_notes", force: true do |t|
    t.integer  "user_id"
    t.integer  "notable_id"
    t.string   "notable_type"
    t.text     "content"
    t.text     "note_fields"
    t.string   "note_attachment"
    t.integer  "note_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_organization_units", force: true do |t|
    t.string   "title"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "core_organization_units", ["ancestry"], name: "index_core_organization_units_on_ancestry", using: :btree

  create_table "core_permissions", force: true do |t|
    t.string   "permission_action"
    t.string   "permission_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_phones", force: true do |t|
    t.string   "phone"
    t.string   "phone_type"
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_portfolio_items", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "responsibilities"
    t.string   "url"
    t.string   "tools_and_tech"
    t.integer  "portfolioable_id"
    t.string   "portfolioable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_quotes", force: true do |t|
    t.float    "amount"
    t.text     "description"
    t.integer  "invoice_split_id"
    t.date     "quote_date"
    t.integer  "project_id"
    t.integer  "lead_id"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
  end

  add_index "core_quotes", ["reference_id", "reference_type"], name: "index_core_quotes_on_reference_id_and_reference_type", using: :btree

  create_table "core_ratings", force: true do |t|
    t.float    "value"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_roles", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_roles_permissions", force: true do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.boolean  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_settings", force: true do |t|
    t.string   "name",       default: "", null: false
    t.text     "value"
    t.datetime "updated_on"
  end

  add_index "core_settings", ["name"], name: "index_core_settings_on_name", using: :btree

  create_table "core_skills", force: true do |t|
    t.string   "name"
    t.integer  "skill_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_skypes", force: true do |t|
    t.string   "name"
    t.string   "skype_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_system_users", force: true do |t|
    t.string   "first_name",                   null: false
    t.string   "last_name",                    null: false
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "auth_mode"
    t.string   "time_zone"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_login_at"
    t.string   "phone"
    t.string   "theme"
  end

  add_index "core_system_users", ["email"], name: "index_core_system_users_on_email", using: :btree
  add_index "core_system_users", ["remember_me_token"], name: "index_core_system_users_on_remember_me_token", using: :btree
  add_index "core_system_users", ["type"], name: "index_core_system_users_on_type", using: :btree

  create_table "crm_leads", force: true do |t|
    t.string   "email"
    t.string   "skype"
    t.string   "technology"
    t.integer  "source_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "user_id"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "organization_unit_id"
  end

  add_index "crm_leads", ["state"], name: "index_crm_leads_on_state", using: :btree
  add_index "crm_leads", ["user_id"], name: "index_crm_leads_on_user_id", using: :btree

  create_table "crm_leads_contacts", force: true do |t|
    t.integer  "contact_id"
    t.integer  "lead_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directory_accounts", force: true do |t|
    t.string   "account_number"
    t.string   "title"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directory_contact_details", force: true do |t|
    t.string   "nick_name"
    t.string   "company_title"
    t.string   "company_email"
    t.string   "company_phone"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "skype"
  end

  create_table "directory_user_details", force: true do |t|
    t.string   "emp_id"
    t.string   "education"
    t.string   "experience"
    t.string   "summery"
    t.string   "the_most_amazing"
    t.string   "perfered_development_environment"
    t.string   "organization_unit_id"
    t.string   "calling_name"
    t.date     "appointment_date"
    t.integer  "job_title_id"
    t.integer  "location_id"
    t.integer  "primary_role_id"
    t.string   "secondary_roles"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pms_projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.integer  "manager_id"
    t.date     "planned_end_date"
    t.float    "cost"
    t.integer  "status_id"
    t.integer  "percentage_done"
    t.integer  "lead_id"
  end

  create_table "pms_projects_contacts", force: true do |t|
    t.integer  "contact_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pms_projects_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pms_task_lists", force: true do |t|
    t.string   "title"
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "billable",      default: false
  end

  create_table "pms_tasks", force: true do |t|
    t.text     "description"
    t.integer  "task_list_id"
    t.integer  "user_id"
    t.date     "due_date"
    t.boolean  "completed",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pms_tasks_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills_users", force: true do |t|
    t.string   "rating"
    t.integer  "experience"
    t.integer  "show_on_profile"
    t.integer  "user_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "workspace_calendar_entries", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "calendar_id"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workspace_calendar_entries", ["reference_id"], name: "index_workspace_calendar_entries_on_reference_id", using: :btree
  add_index "workspace_calendar_entries", ["reference_type"], name: "index_workspace_calendar_entries_on_reference_type", using: :btree

  create_table "workspace_calendars", force: true do |t|
    t.integer  "system_user_id"
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reference_id"
    t.string   "reference_type"
  end

  add_index "workspace_calendars", ["reference_id", "reference_type"], name: "index_workspace_calendars_on_reference_id_and_reference_type", using: :btree

  create_table "workspace_calendars_users", force: true do |t|
    t.integer  "system_user_id"
    t.integer  "calendar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workspace_events", force: true do |t|
    t.string   "title"
    t.integer  "calendar_id"
    t.date     "start"
    t.date     "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
