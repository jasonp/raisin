include ProjectsHelper
class ProjectsController < ApplicationController
  # we get to use current_user without checking because we require log-in in this controller
  before_filter :authenticate_user!
  before_filter :check_editable, only: [:edit]
  before_filter :authenticate_project, only: [:show, :edit]
  before_filter :verify_active
  
  def index
  end

  def new
    @account = Account.find_by_id(params[:account_id])
    @project = @account.projects.build unless @account.nil?
    
    respond_to do |format|
      if @account.nil?
        format.html { redirect_to new_account_path }
      else
        format.html { render 'new' }
      end
    end
  end
  
  def show
    @project = Project.where(account: params[:account_id], id: params[:id])[0]
    @account = Account.find_by_id(params[:account_id])
    
    # For lists & items
    @list = @project.lists.new
    @lists = List.where(project_id: @project.id, status: "active").order(id: :desc)
    @assignees = return_potential_users_to_assign(@project)
    
    # for conversations
    @conversations = @project.conversations.limit(5)
    
    @page_title = "- #{@project.title}"
    
    if @project.status == "garage"
      @garage = true
    end
    
    respond_to do |format|
      if @project.nil?
        format.html { redirect_to root_path }
      else
        if @project_check == false
          format.html { redirect_to root_path }
        else
          format.html { render 'show' }
        end
      end
    end
  end



  def create
    
    @account = Account.find_by_id(params[:account_id])
    @project = @account.projects.create(project_params)
    
    # now we need to associate the user that created it
    @new_member = Member.add_user_to_project(current_user, @project)
    @new_member.save!
    
    # check to see if we're supposed to associate anyone else
    if params[:family_share]
      family_members = Member.where(account_id: @account.id)
      family_members.each do |fm|
        usr = fm.user
        if usr
          mem = Member.add_user_to_project(usr, @project) unless usr == current_user
          # send email
        elsif fm.email && fm.email != ""
          mem = Member.add_pending_user_to_project(fm.email, fm.name, @project)
          # send email
        end
        
      end
    end
    
    respond_to do |format|
      if @project.save
        format.html { redirect_to account_project_path(@account, @project) }
      else
        format.html { render action: "new" }
      end
    end
    
  end

  def edit
    @project = Project.find_by_id(params[:id])
    @account = Account.find_by_id(params[:account_id])
    
  end

  def update
    @project = Project.find(params[:id])
    @account = @project.account
    logger.info @project.title
    
    respond_to do |format|
      if @project.update(project_params)
        if @project.status == "garage"
          format.html { redirect_to root_path, notice: 'OK: We stashed that project in the garage.'}
        else
          format.html { redirect_to account_project_path(@account, @project), notice: 'Project updated!' }
          format.js { render 'update' }
        end  
      else
        format.html { render action: "edit" }
      end
    end
    
  end
  
  def destroy
    @project = Project.find(params[:id])
    
    if @project.removable == "no"
      @removable = "yes"
    end

    @members_to_delete = @project.members
    
      if @project.delete  
        
        @members_to_delete.each do |m|
          m.delete
        end
        
        if @removable == "yes"
          redirect_to root_path, flash: {warning: 'OK, family member removed.'}
        else
          redirect_to root_path, flash: {warning: 'OK, that project has gone the way of the dodo.'}
        end
      else
        redirect_to root_path, flash: {danger: 'Uh, oh, something went wrong.' }  
      end # project delete

    
  end
  
  private

    def project_params
      params.require(:project).permit(:title, :description, :status, :members_attributes => [:id, :email, :name, :user_id])
    end
  
    def check_editable
      project = Project.find_by_id(params[:id])
      if project.removable == "no"
        redirect_to root_path
      end
    end
    
    def check_for_project_membership(project, user)
      if project.removable == "no"
        # family project -- check to see if the user is a family member
        if Member.where(user_id: user.id, account_id: project.account.id).count > 0
          return true
        else
          return false
        end
      else
        # regular project, check for project membership
        if Member.where(user_id: user.id, project_id: project.id).count > 0
          return true
        else
          return false
        end
      end
    end
    
    def authenticate_project
      project = Project.find(params[:id])
      if !check_for_project_membership(project, current_user)
        redirect_to root_path
      end
    end
    
    def verify_active
      account = Account.find(params[:account_id])
      if account.active_until < Time.now.utc
        if account.stripe_customer_id
          flash[:subscription_expired] = "Your subscription has expired! Don't worry, your data is perfectly fine, but you'll need to update your payment information -- it looks like there was a problem charging your card on file."
          redirect_to edit_subscription_path
        else
          flash[:subscription_expired] = "Your subscription has expired! Don't worry, your data is perfectly fine, but you'll need to enter your payment information and become a paying subscriber."
          redirect_to new_subscription_path
        end            
      end
    end
    
  
end
