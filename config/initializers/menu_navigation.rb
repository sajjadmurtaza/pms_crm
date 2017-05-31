require 'heyday/menu_manager'

Heyday::MenuManager.map :main_nav do |menu|
  menu.push :workspace, '/calendars', icon: 'calendar'
  menu.push :calendars, '/calendars', icon: 'calendar', parent: :workspace
  menu.push :activity_logs, '/project_logs', icon: 'file outline', parent: :workspace, caption: 'Activity Log'
  menu.push :user_assignments, '/user_assignments', icon: 'tasks', parent: :workspace, caption: 'Ball in Court'

  menu.push :directory, '/contacts', icon: 'book'
  menu.push :contacts, '/contacts', icon: 'users', parent: :directory
  menu.push :users, '/users', icon: 'users', parent: :directory, caption: 'Employees'
  menu.push :accounts, '/accounts', icon: 'open folder', parent: :directory

  menu.push :crm , '/leads', icon: 'users', caption: 'Leads'
  menu.push :leads, '/leads', icon: 'users', parent: :crm

  menu.push :pms , '/projects', icon: 'browser', caption: 'Projects'
  menu.push :projects, '/projects', icon: 'browser', parent: :pms

  menu.push :invoice , '/invoices', icon: 'bar chart', caption: 'Invoices'
  menu.push :invoices, '/invoices', icon: 'bar chart', parent: :invoice

  menu.push :settings, '/admin/settings', icon: 'setting'
  menu.push :configurations, '/admin/settings', icon: 'table', parent: :settings
  menu.push :enumerations, '/enumerations', icon: 'table', parent: :settings
  menu.push :organization_units, '/admin/organization_units', icon: 'suitcase', parent: :settings
  menu.push :note_types, '/admin/note_types', icon: 'flag', parent: :settings
  menu.push :skills, '/skills', icon: 'filter', parent: :settings
  menu.push :roles, '/roles', icon: 'shield', parent: :settings
end

Heyday::MenuManager.map :side_menu do |menu|
end