class UsersController < ApplicationController
  
  def show
    @user = User.find_by_id(params[:id])
    @account = Account.find_by_id(session["preferred_account_id"]) if session["preferred_account_id"]
    
    # Let's set the variables to allow task viewing
    @date_options = ["Everything", "This week", "Today", "Tomorrow", "Overdue", "In the future"]
    @items = Item.where(user_id: @user.id, status: "active").order(:list_id)
    
    if params[:date_range]
      if params[:date_range] == "Today"
        @items = Item.where(user_id: @user.id, status: "active", due: Time.now.utc.midnight..(Time.now.utc.midnight + 1.day - 1.minute) ).order(:list_id)
      elsif params[:date_range] == "Overdue"
        @items = Item.where(user_id: @user.id, status: "active", due: (Time.now.utc.midnight - 1.month )..(Time.now.utc.midnight - 1.minute) ).order(:list_id)
      elsif params[:date_range] == "Tomorrow"
        @items = Item.where(user_id: @user.id, status: "active", due: Time.now.utc.midnight.tomorrow).order(:list_id)   
      elsif params[:date_range] == "This week"
        @items = Item.where(user_id: @user.id, status: "active", due: (Time.now.utc.midnight.beginning_of_week(:sunday))..(Time.now.utc.midnight.end_of_week(:sunday)) ).order(:list_id)   
      elsif params[:date_range] == "In the future"
        @items = Item.where(user_id: @user.id, status: "active", due: (Time.now.utc.midnight.tomorrow)..(Time.now.utc.midnight + 1.month) ).order(:list_id)                  
      elsif params[:date_range] == "Everything"
        @items = Item.where(user_id: @user.id, status: "active").order(:list_id)    
      end           
    end
    
    respond_to do |format|
      format.html { render 'show' }
      format.js { render 'show' }
    end
    
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
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :photo, :email_preference)
    end
  
end
