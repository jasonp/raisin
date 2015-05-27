include ApplicationHelper
class CommentsController < ApplicationController
 
  def create
    @new_comment = Comment.new(comment_params)
    
    if @new_comment.item
      @project = @new_comment.item.list.project
      @li = @new_comment.item
      @default_notify_users = return_default_users_to_notify(@li)
      @comment = @li.comments.build
    elsif @new_comment.conversation
      @conversation = @new_comment.conversation
      @project = @conversation.project
      @default_notify_users = []
      @comment = @conversation.comments.build
    end
    
    @notifiable_users = @project.users 
    @notifiable_users_count = count_notifiable_users(@notifiable_users)
    
    respond_to do |format|
      if @new_comment.save
        
        # issue notifications as needed
        if params[:notifiable_users]
          # one more layer
          if params[:comment][:item_id]
            check_for_and_issue_notifications_for(@new_comment, params[:notifiable_users], "comment_added_to_item")
          elsif params[:comment][:conversation_id]
            check_for_and_issue_notifications_for(@new_comment, params[:notifiable_users], "comment_added_to_conversation") 
          end  
        end
        
        format.js
      end
    end
  end

  def new
  end

  def update
    @comment = Comment.find(params[:id])
    
    if @comment.item
      @project = @comment.item.list.project
      @li = @comment.item
      @default_notify_users = return_default_users_to_notify(@li)      
    elsif @comment.conversation
      @conversation = @comment.conversation
      @project = @conversation.project
      @default_notify_users = []
    end

    @notifiable_users = @project.users 
    @notifiable_users_count = count_notifiable_users(@notifiable_users)

    respond_to do |format|
      if @comment.update(comment_params)
        format.js
      end
    end  
    
  end
  
  def edit
    @comment = Comment.find(params[:id])
    
    if @comment.item
      @project = @comment.item.list.project
      @li = @comment.item
      @default_notify_users = return_default_users_to_notify(@li)
    elsif @comment.conversation
      @conversation = @comment.conversation
      @project = @conversation.project
      @default_notify_users = []
    end
    
    @notifiable_users = @project.users 
    @notifiable_users_count = count_notifiable_users(@notifiable_users)
    
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
