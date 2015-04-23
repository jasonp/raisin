class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    # We need to implement the actual callback stuff in the model
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?

      # if it's a new user, make an account
      if @user.accounts.count < 1
        m = @user.name.split(" ")
        @user.accounts.create(name: m.last, active_until: Time.now.utc + 2.months)
      end

      sign_in(@user) 
      
      redirect_to root_path
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
   protected
  
   # The path used when omniauth fails
   def after_omniauth_failure_path_for(scope)
     super(scope)
   end
   
   def account_params
     params.require(:account).permit(:name, :active_until)
   end
  
end