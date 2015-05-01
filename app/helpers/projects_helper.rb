module ProjectsHelper

  def return_potential_users_to_assign(project)
    #[{"id"=>1, "name"=>"Jason Preston"}]
    if project.removable == "no"
      members = Member.where.not(user_id: nil).where(account_id: project.account.id)
    else  
      members = Member.where.not(user_id: nil).where(project_id: project.id)
    end  
    user_names_and_ids_hash = Hash.new
    user_names_and_ids_hash["Assign it"] = 0
    members.each do |member|
      name = member.user.name 
      id = member.user.id
      user_names_and_ids_hash[name] = id
    end

    return user_names_and_ids_hash
  end

end
