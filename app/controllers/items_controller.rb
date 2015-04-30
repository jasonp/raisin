include ItemsHelper
include ProjectsHelper
class ItemsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @list = List.find(params[:list_id])
    @project = @list.project
    
    @assignees = return_potential_users_to_assign(@project)
    
    @item = @list.items.build
  end

  def create
    @list = List.find(params[:list_id])
    @project = @list.project
    @assignees = return_potential_users_to_assign(@project)
    
    @li = @list.items.create(item_params)
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @list = List.find(params[:list_id])
    @project = @list.project
    @assignees = return_potential_users_to_assign(@project)
    
    @li = Item.find(params[:id])
    
    if params[:item] == "checked"
      @li.status = "checked"
      @li.save
    else
      @li.update(item_params)
    end
    
    # Set the list to completed if this is the last to-do
    active_todo_count = Item.where(list_id: @list.id, status: "active").count
    if active_todo_count < 1
      @list.status = "completed"
      @list.save
    end
    
    respond_to do |format|
      if @li.status == "checked"
        format.js {render 'checked'}
      else
        format.js {render 'update'}
      end
          
    end
  end

  def edit
  end
  
  def show
    @item = Item.find(params[:id])
  end

  def destroy
  end
  
  def cancel
    @project = Project.find(params[:project_id])
    @list = List.find(params[:list_id])
    
    respond_to do |format|
      format.js
    end
  end  
  
  private
  
    def item_params
      params.require(:item).permit(:title, :status, :due, :user_id, :created_by, :completed_by)
    end
  
end
