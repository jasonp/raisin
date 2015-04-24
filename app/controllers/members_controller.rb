class MembersController < ApplicationController
  before_filter :authenticate_user!


  def new
    # if it's a new family member
    if params[:type] == "family"
      @page_title = "- Add a new Family Member"
      @account = Account.find_by_id(params[:account_id])
      @member = @account.members.build
      @headline = "Add a new family member to #{@account.name}"
    # if it's a new project member  
    elsif params[:type] == "project"
      @page_title = "- Invite collaborators"
      @headline = "Invite someone to collaborate on "
    end

    if @member.nil?
      redirect_to root_path
    end
    
  end

  def create
    # what kind of member are we creating
    if params[:project_id]
      # Then we're adding a project collaborator
    else
      # We're adding a family member to an account
      @account = Account.find_by_id(params[:account_id])
      @member = @account.members.create(member_params)
      
      # That means we need to create a permanent project for them
      # then add the current_user as a member to it
      @proj = Project.new(title: @member.name, removable: "no", account_id: @account.id)
      @proj.save!
      @proj.members.create(project_id: @proj.id, user_id: current_user.id)
    end
    
     respond_to do |format|
        if @member.save
          format.html { redirect_to root_path, notice: 'Hooray! We added a new family member.' }
        else
          format.html { render action: "edit" }
        end
      end
  end
  
  private
  
    def member_params
      params.require(:member).permit(:name, :birthday, :gender, :email, :project_id, :user_id, :account_id)
    end

end
