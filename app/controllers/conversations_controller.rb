include ApplicationHelper
class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @conversation = Conversation.new
    
    @account = Account.find(params[:account_id])
    @project = Project.find_by_id(params[:project_id])
    
    # Notification things
    @notifiable_users = @project.users 
    @notifiable_users_count = count_notifiable_users(@notifiable_users)
    @default_notify_users = [] # there are no default notifiables for new conversations
    

  end
  
  def index
    @project = Project.find(params[:project_id])
    @account = Account.find(params[:account_id])
    
    @conversations = @project.conversations.order('created_at DESC')
  end

  def create
    @conversation = Conversation.new(conversation_params)
    @account = Account.find(params[:account_id])
    @project = Project.find(params[:project_id])
    
    respond_to do |format|
      if @conversation.save
        # issue notifications as needed
        if params[:notifiable_users]
          check_for_and_issue_notifications_for(@conversation, params[:notifiable_users], "conversation_started")
        end
        
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
    @conversation = Conversation.find(params[:id])
    @account = Account.find(params[:account_id])
    @project = Project.find(params[:project_id])
  end

  def update
    @conversation = Conversation.find(params[:id])
    @account = Account.find(params[:account_id])
    @project = Project.find(params[:project_id])
    
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to account_project_conversation_path(@account, @project, @conversation) }
      else
        flash.now[:warning] = "Uh oh, your changes couldn't be saved"
        render 'edit'
      end
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
    @project = @conversation.project
    
    # build for comment notification & display
    @notifiable_users = @project.users 
    @notifiable_users_count = count_notifiable_users(@notifiable_users)
    @default_notify_users = []
    
    @comments = @conversation.comments.order(:id)
    @comment = @conversation.comments.build
  end

  def destroy
    @conversation = Conversation.find(params[:id])
    @project = @conversation.project
    
    respond_to do |format|
      if @conversation.destroy
        format.html { 
          flash[:notice] = "Conversation deleted."
          redirect_to account_project_path(@project.account, @project)
          }
      end
    end
  end
  
  private
  
    def conversation_params
      params.require(:conversation).permit(:title, :content, :user_id, :member_id, :project_id, :status, :flep)
    end
end
