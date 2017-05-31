module Directory::UsersHelper

  def primary_role_name(role)
    @role = Core::Role.find_by_id(role)
    if @role != nil
      return @role.name
    else
      return
    end
  end

end
