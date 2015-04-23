class ProjectsController < ApplicationController
  # we get to use current_user without checking because we require log-in in this controller
  before_filter :authenticate_user!
  
  
  def index
  end

  def new
    @account = Account.find_by_id(params[:account_id])
    @project = @account.projects.build
  end
  
  def show
    @project = Project.find_by_id(params[:id])
    @account = Account.find_by_id(params[:account_id])
  end

  def create
    
    @account = Account.find_by_id(params[:account_id])
    @project = @account.projects.create(project_params)
    
    # now we need to associate the user that created it
    @new_member = Member.add_user_to_project(current_user, @project)
    @new_member.save!
    
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
        format.html { redirect_to account_project_path(@account, @project), notice: 'Project updated!' }
      else
        format.html { render action: "edit" }
      end
    end
    
  end
  
  private

    def project_params
      params.require(:project).permit(:title, :description, :members_attributes => [:id, :email, :name, :user_id])
    end
  
  
end
