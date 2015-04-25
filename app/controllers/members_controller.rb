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
      # Which means we're really just adding a "member" and inviting them to become a user.
      # When they sign up, we'll need to update their member record with a user_id.  
      
    else
      # We're adding a family member to an account
      @account = Account.find_by_id(params[:account_id])
      @member = @account.members.create(member_params)
      
      # That means we need to create a permanent project for them
      #
      @proj = Project.new(title: @member.name, removable: "no", account_id: @account.id)
      @proj.save!      
      
      @member.project_id = @proj.id
      
      # Time to check and see if they're supposed to get an invite as well
      # but we'll send it after the save, so we have to flag it as an account invite
      if params[:participant] == "participant"       
        @account_invite = true
      end
      
    end
    
     respond_to do |format|
        if @member.save
          
          # let's then add the current_user as a member to the new project
          # actually we should add all account members
          @account.users.each do |u|
            @proj.members.create(project_id: @proj.id, user_id: u.id)
          end
          
          # Let's deliver email, if needed
          InviteMailer.invite_to_account(@member, @account, current_user).deliver_later if @account_invite
            
          
          
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
