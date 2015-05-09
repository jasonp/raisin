class UsersController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show
    @user = User.find_by_id(params[:id])
    @account = Account.find_by_id(session["preferred_account_id"]) if session["preferred_account_id"]
    
    # Let's set the variables to allow task viewing
    @date_options = ["Everything", "This week", "Today", "Tomorrow", "Overdue", "In the future"]
    @items = Item.where(user_id: @user.id, status: "active").order(:list_id)
    
    nowtime = get_nowtime
    logger.info("Showing what NOWTIME is ----------->")
    logger.info(nowtime)
    
    if params[:date_range]
      if params[:date_range] == "Today"
        @items = Item.where(user_id: @user.id, status: "active", due: nowtime.midnight ).order(:list_id)
      elsif params[:date_range] == "Overdue"
        @items = Item.where(user_id: @user.id, status: "active", due: (nowtime.midnight - 1.month )..(nowtime.midnight - 1.minute) ).order(:list_id)
      elsif params[:date_range] == "Tomorrow"
        @items = Item.where(user_id: @user.id, status: "active", due: nowtime.midnight.tomorrow).order(:list_id)   
      elsif params[:date_range] == "This week"
        @items = Item.where(user_id: @user.id, status: "active", due: (nowtime.beginning_of_week(:sunday))..(nowtime.midnight.end_of_week(:sunday)) ).order(:list_id)   
      elsif params[:date_range] == "In the future"
        @items = Item.where(user_id: @user.id, status: "active", due: (nowtime.midnight.tomorrow)..(nowtime.midnight + 1.month) ).order(:list_id)                  
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
      params.require(:user).permit(:name, :email, :photo, :email_preference, :time_zone)
    end
    
    def get_nowtime
      t = current_user.time_zone
      today = Time.now.in_time_zone(t).midnight
      logger.info("Showing what current_user.time_zone TODAY is ----------->")
      logger.info(today)
      utc_today = Date.today
      logger.info("Showing what UTC today is ----------->")
      logger.info(utc_today)
      if today.day == utc_today.day
        nowtime = Time.now.utc
      elsif today.day == utc_today.yesterday.day
        nowtime = Time.now.utc - 1.day
      else 
        nowtime = Time.now.utc + 1.day
      end
      
      return nowtime
    end
  
end
