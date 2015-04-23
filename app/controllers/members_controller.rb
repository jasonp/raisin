class MembersController < ApplicationController
  before_filter :authenticate_user!


  def new
    # if it's a new family member
    if params[:type] == "family"
      @page_title = "- Add a new Family Member"
      @account = Account.find_by_id(params[:account_id])
      @member = @account.members.build
    # if it's a new project member  
    elsif params[:type] == "project"
      @page_title = "- Invite collaborators"
    end

    if @member.nil?
      redirect_to root_path
    end
    
  end

  def create
  end

end
