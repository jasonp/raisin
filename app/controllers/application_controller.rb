class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  helper_method :return_custom_potential_users_to_assign

  def return_custom_potential_users_to_assign(project)
    #[{"id"=>1, "name"=>"Jason Preston"}]
    members = Member.where.not(user_id: nil).where(project_id: project.id)
    user_names_and_ids_hash = Hash.new
    user_names_and_ids_hash["Assign it"] = 0
    members.each do |member|
      name = member.user.name 
      id = member.user.id
      user_names_and_ids_hash[name] = id
    end

    return user_names_and_ids_hash
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
  
end
