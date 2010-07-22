module GroupsHelper

 def all_groups
    admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
     [['Select class', '']] + admin.groups.find(:all,:conditions =>['status = ?','Active']).map{|m|[m.name,m.id]} rescue ''
   end
end
