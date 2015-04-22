class UsersController < ApplicationController
  
  def show
    @user = User.find_by_id(params[:id])
  end
  
  def edit
    @user = User.find_by_id(params[:id])
  end
  
  def update
    @user = User.find_by_id(params[:id])
    
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Great success! New information saved.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :photo)
    end
  
end
