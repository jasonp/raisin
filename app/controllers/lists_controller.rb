include ProjectsHelper
class ListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_list, only: [:show]
  # before_filter :verify_active

  def new
    @project = Project.find(params[:project_id])
    @list = @project.lists.build
    
    respond_to do |format|
       format.js
     end
  end
  
  def create
    @project = Project.find(params[:project_id])
    @list = @project.lists.create(list_params)
    
    respond_to do |format|
       format.js
     end
  end
  
  def cancel
    @project = Project.find(params[:project_id])
    @list = @project.lists.build
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @project = Project.find(params[:project_id])
    @list = List.find(params[:id])
    
    respond_to do |format|
      if @list.update(list_params)
        format.js
      end
    end
    
  end
  
  def show
    @list = List.find(params[:id])
    @project = @list.project
    @assignees = return_potential_users_to_assign(@project)
  end

  def completed

    @account = Account.find_by_id(params[:account_id])
    @project = Project.find_by_id(params[:project_id])
    
    @lists = List.where(project_id: @project.id).order(id: :desc)
    
  end


  def destroy
    @list = List.find(params[:id])
    
    respond_to do |format|
      if @list.destroy
        format.js
      end
    end
  end
  
  private
  
    def list_params
      params.require(:list).permit(:title, :status, :description)
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
    
    def authenticate_list
      list = List.find(params[:id])
      project = list.project
      
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
