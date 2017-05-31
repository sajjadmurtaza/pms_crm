module ApplicationHelper
  def is_event?(note)
    note.note_type.name == "event"
  end

  def current_user
    @current_user ||= Directory::User.find(session[:user_id]) if session[:user_id]
  end
end
