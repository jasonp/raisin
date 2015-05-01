include ProjectsHelper
class ListsController < ApplicationController
  before_filter :authenticate_user!

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
    
end
