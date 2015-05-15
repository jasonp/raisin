include ApplicationHelper
class CommentsController < ApplicationController
 
  def create
    @new_comment = Comment.new(comment_params)
    @project = @new_comment.item.list.project
    @li = @new_comment.item
    @notifiable_users = @project.users 
    @default_notify_users = return_default_users_to_notify(@li)
    @comment = @li.comments.build
    
    respond_to do |format|
      if @new_comment.save
        
        # issue notifications as needed
        if params[:notifiable_users]
          check_for_and_issue_notifications_for(@new_comment, params[:notifiable_users], "comment_added_to_item")
        end
        
        format.js
      end
    end
  end

  def new
  end

  def update
    @comment = Comment.find(params[:id])
    @project = @comment.item.list.project
    @notifiable_users = @project.users 
    @li = @comment.item

    respond_to do |format|
      if @comment.update(comment_params)
        format.js
      end
    end  
    
  end
  
  def edit
    @comment = Comment.find(params[:id])
    @project = @comment.item.list.project
    @li = @comment.item
    @notifiable_users = @project.users 
    @default_notify_users = return_default_users_to_notify(@li)
    
    respond_to do |format|
      if params[:edit_mode] == "cancel"
        format.js { render 'cancel' }
      else
        format.js { render 'edit' }
      end
      
    end
  end

  def show
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    
    respond_to do |format|
      if @comment.delete
        format.js
      end
    end
    
  end
  
  
  private
  
    def comment_params
      params.require(:comment).permit(:content, :user_id, :item_id, :project_id, :conversation_id, :list_id)
    end
      
end
