class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    # We need to implement the actual callback stuff in the model
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in(@user) 
      redirect_to new_account_path
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
end