module ItemsHelper
  
  def return_potential_users_to_assign(project)
    #[{"id"=>1, "name"=>"Jason Preston"}]
    members = Member.where.not(user_id: nil).where(project_id: project.id)
    user_names_and_ids_hash = Hash.new
    user_names_and_ids_hash["Assign the to-do"] = nil
    members.each do |member|
      name = member.user.name 
      id = member.user.id
      user_names_and_ids_hash[name] = id
    end

    return user_names_and_ids_hash
  end
  
end
