include ApplicationHelper
class CommentsController < ApplicationController
 
  def create
    @comment = Comment.new(comment_params)
    @project = @comment.item.list.project
    @li = @comment.item.list
    
    respond_to do |format|
      if @comment.save
        format.js
      end
    end
  end

  def new
  end

  def update
    @comment = Comment.find(params[:id])
    @project = @comment.item.list.project
    @li = @comment.item.list

    respond_to do |format|
      if @comment.update(comment_params)
        format.js
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
