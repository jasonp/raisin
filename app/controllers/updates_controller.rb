class UpdatesController < ApplicationController
  def index
    @updates = Update.all
  end

  def new
    @update = Update.new
  end

  def create
    @update = Update.new(update_params)
    respond_to do |format|
      if @update.save
        format.html { redirect_to update_path(@update) }
      else
        format.html { render 'new' }
      end
    end
  end

  def show
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
end
