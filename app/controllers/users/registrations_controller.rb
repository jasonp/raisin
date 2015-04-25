class Users::RegistrationsController < Devise::RegistrationsController
 before_filter :configure_sign_up_params, only: [:create]
 before_filter :configure_account_update_params, only: [:update]

   #GET /resource/sign_up
   #def new
  #   super
  #
  #   
  # end
  
    # POST /resource
    def create
     super do |resource|
       @account_ids = []
       @projects = []
       
       # Find all the memberships that we need to associate, and associate them
       members = Member.where(email: resource.email)
       members.each do |m|
         @account_ids << m.account_id
         m.user_id = resource.id
         m.save!
       end
       
       # Find all the accounts we neeed to associate, and associate them
       @accs = @account_ids.uniq
       @accs.each do |a|
         account = Account.find_by_id(a)
         account.users << resource
         account.projects.each do |p|
           @projects << p
         end
       end
       
       # Lastly, find all the family member projects in all the accounts, and create 
       # memberships where they don't yet exist
       @projects.each do |pr|
         if pr.removable == "no"
           pr.members.create(user_id: resource.id) unless pr.users.include?(resource)
         end
       end
       
     end
     
     
    end
  
   # GET /resource/edit
   #def edit
   #  super
   #end
  
   # PUT /resource
   #def update
   # super
   #end
  
   # DELETE /resource
   #def destroy
   #  super
   #end
  
   # GET /resource/cancel
   #Forces the session data which is usually expired after sign
   #in to be expired now. This is useful if the user wants to
   #cancel oauth signing in/up in the middle of the process,
   #removing all OAuth session data.
   #def cancel
   #  super
   #end
  
   protected

     # You can put the params you want to permit in the empty array.
     def configure_sign_up_params
       devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ accounts_attributes: [:name, :id] }, :email, :name, :password, :password_confirmation) }
     end
  
     # You can put the params you want to permit in the empty array.
     def configure_account_update_params
       devise_parameter_sanitizer.for(:account_update) << :name
     end
  
     # The path used after sign up.
     def after_sign_up_path_for(resource)
       root_path
       #super(resource)
     end
  
     # The path used after sign up for inactive accounts.
     def after_inactive_sign_up_path_for(resource)
       root_path
       #super(resource)
     end
end
