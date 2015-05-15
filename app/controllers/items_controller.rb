include ItemsHelper
include ProjectsHelper
include ApplicationHelper
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
    @list.status = "active"
    @list.save
    
    if @li.due
      if @li.user
        notify_users = []
        notify_users << @li.user unless @li.user == current_user
        check_for_and_issue_notifications_for(@li, notify_users, "new_todo_assigned")
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @list = List.find(params[:list_id])
    @project = @list.project
    @assignees = return_potential_users_to_assign(@project)
    
    @li = Item.find(params[:id])
    @li.update(item_params)
    
    if params[:action_to_take] == "update"
      @action = "updated"
    elsif params[:action_to_take] == "individual_update_info"
      @action = "updated_individually"
    elsif params[:action_to_take] == "individual_update"
      @action = "individual_update"  
    elsif params[:action_to_take] == "check_and_move"
      @action = "checked"
    elsif params[:action_to_take] == "uncheck_and_move"
      @action = "unchecked"
    end
    
    # If the to-do has been checked, issue notification
    if @li.status == "checked"
       notify_users = []
       creating_user = User.find(@li.created_by)
       notify_users << creating_user unless creating_user == current_user
       check_for_and_issue_notifications_for(@li, notify_users, "todo_completed")
     end
    
    # Set the list to completed if this is the last to-do
    # or re-activate it if needed
    active_todo_count = Item.where(list_id: @list.id, status: "active").count
    if active_todo_count < 1
      @list.status = "completed"
      @list.save
    elsif active_todo_count > 0
      @list.status = "active"
      @list.save
    end
    
    respond_to do |format|
      if @action == "checked"
        format.js {render 'checked'}
      elsif @action == "unchecked"
        format.js {render 'unchecked' }  
      elsif @action == "individual_update"
        format.js {render 'nada' }  
      elsif @action == "updated_individually"
        format.js {render 'individual' }  
      else
        format.js {render 'update'}
      end
          
    end
  end

  def edit
  end
  
  def show
    @item = Item.find(params[:id])
    @list = @item.list
    @project = @list.project
    @li = @item
    @assignees = return_potential_users_to_assign(@project)   
    
    @page_title = "- #{@item.title}"
    
    # build for comment notification & display
    @notifiable_users = @project.users 
    @notifiable_users_count = count_notifiable_users(@notifiable_users)
    @default_notify_users = return_default_users_to_notify(@item)
    @comment = @item.comments.build
    @existing_comments = @item.comments.order(:id)
    
  end

  def destroy
    @li = Item.find(params[:id])
    
    respond_to do |format|
      if @li.destroy
        format.js
      end
    end
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
      params.require(:item).permit(:title, :status, :due, :user_id, :created_by, :completed_by, :flep)
    end
  
end
