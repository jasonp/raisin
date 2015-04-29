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
  end
  
  def show
    @list = List.find[params[:id]]
  end

  def destroy
  end
  
  private
  
    def list_params
      params.require(:list).permit(:title, :status)
    end
    
end
