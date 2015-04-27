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
      # ultimately I want to add a key/check on this to make sure people can't add themselves
      # to random projects & accts by guessing emails.
     #super do |resource|
       @account_ids = []
       @projects = []
       parameters = params
       
       resource = User.new(user_params)
       respond_to do |format| 
         if resource.save     
           sign_in(resource)                      
           
           check_for_and_associate_members_and_accounts(resource)
           
           format.html {redirect_to root_path, notice: "Invitation accepted!"}
         else
           format.html {redirect_to new_user_registration_path(email: params[:user][:email], name: params[:user][:name]), flash: { warning: "Oops, it looks like your password is invalid -- you need 8 characters, minimum."} }
         end # if/save
       end   # format
       
       
     #end # super do
     
     
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
     
     def user_params
       params.require(:user).permit(:name, :email, :password, :password_confirmation)
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
     
     def check_for_and_associate_members_and_accounts(resource)
       # Find all the memberships that we need to associate, and associate them
       members = Member.where(email: resource.email)
       members.each do |m|
         # add the user to any accounts
         a = m.project.account
         if a
           a.users << resource if !a.users.include?(resource)
           a.save!
         end
     
         # and of course add the user_id to the membership record
         m.user_id = resource.id
         m.save!
      end
    end
    
end
