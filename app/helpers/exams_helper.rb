module ExamsHelper
  def get_groups
    current_user.school.groups.find_all_by_status('Active')
  end
end
