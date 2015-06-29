class UpdatesController < ApplicationController
  before_filter :reject_unless_admin, only: [:new, :update, :create]
  
  def index
    if current_user
      if current_user.role == "admin"
        @updates = Update.all
      end  
    else
      @updates = Update.where(status: "live")
    end

    if current_user
      if current_user.has_not_seen_the_latest_update(Update.last)
        SeenUpdate.create!(post_id: Update.last.id, user_id: current_user.id)
      end
    end  
  end

  def new
    @update = Update.new
    @possible_statuses = ["Draft", "Live"]
  end

  def create
    @update = Update.new(update_params)
    respond_to do |format|
      if @update.save
        format.html { 
          flash[:success] = "Awesome update."
          redirect_to update_path(@update) }
      else
        format.html { 
          flash[:warning] = "Nope"
          render 'new'  }
      end
    end
  end

  def show
    @update = Update.find(params[:id])
  end
  
  def edit
    @update = Update.find(params[:id])
  end
  

  def update
    @update = Update.find(params[:id])
    respond_to do |format|
      if @update.update(update_params)
        format.html { redirect_to update_path(@update) }
      else
        format.html { render 'new' }
      end
    end
  end
  
  private
  
    def update_params
      params.require(:update).permit(:title, :content, :user_id, :status)
    end
    
    def reject_unless_admin
      redirect_to root_path if current_user.role != "admin"
    end
end
