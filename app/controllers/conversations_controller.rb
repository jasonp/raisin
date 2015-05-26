class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @account = Account.find(params[:account_id])
    @project = Project.find_by_id(params[:project_id])
    
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.new(conversation_params)
    @account = Account.find(params[:account_id])
    @project = Project.find(params[:project_id])
    
    respond_to do |format|
      if @conversation.save
        format.html { redirect_to account_project_conversation_path(@account, @project, @conversation) }
      else
        format.html { 
          @preserved_comment = conversation_params["content"]
          flash.now[:warning] = "We couldn't save your conversation!"
          render 'new'
          }
      end
    end
  end

  def edit
  end

  def update
  end

  def show
    @conversation = Conversation.find(params[:id])
  end

  def destroy
  end
  
  private
  
    def conversation_params
      params.require(:conversation).permit(:title, :content, :user_id, :member_id, :project_id, :status)
    end
end
