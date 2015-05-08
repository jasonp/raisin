class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    # We need to implement the actual callback stuff in the model
    # so we have a couple methods for that. Let's see which one we need. 
    
    @user_check = User.find_by_email(request.env["omniauth.auth"].info.email) || current_user
    if @user_check
      @user = User.link_from_omniauth(request.env["omniauth.auth"], @user_check)
      if @user.save
        sign_in(@user)
        redirect_to root_path, notice: "Facebook successfully linked"
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
      
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])
      
      if @user.persisted?

        sign_in(@user)

        # if it's a new user, make an account & a member 
        if @user.accounts.count < 1
          m = @user.name.split(" ")
          @account = @user.accounts.create(name: m.last, active_until: Time.now.utc + 2.months)

          # create a permanent project (a family member)
          @proj = @account.projects.create(title: current_user.name, removable: "no")
          # add the new user as a family member
          @proj.members.create(user_id: current_user.id, account_id: @account.id)

        end

        sign_in(@user) 
        @user.remember_me!  


        redirect_to root_path
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end # if user persisted
    end # if new user / old user
  end # def facebook
  
   protected
  
   # The path used when omniauth fails
   def after_omniauth_failure_path_for(scope)
     super(scope)
   end
   
   def account_params
     params.require(:account).permit(:name, :active_until)
   end
  
end