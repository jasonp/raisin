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
    elsif params[:project]
      @account = Account.find_by_id(params[:account_id])
      @page_title = "- Invite collaborators"
      @project = Project.find(params[:project])
      @headline = "Invite someone to collaborate on #{@project.title}"
      @member = @project.members.build
      @default_message = "Hey, I'm using Raisin to keep track of personal and family projects. I'd love your help."
      
      # prevent non owners from inviting new members
      if @project.users.first != current_user
        redirect_to account_project_path(@account, @project)
      end
    end

    if @member.nil?
      redirect_to root_path
    end
    
  end

  def create
    # what kind of member are we creating
    if params[:member][:project_id]
      # Then we're adding a project collaborator
      # Which means we're really just adding a "member" and inviting them to become a user.
      # When they sign up, we'll need to update their member record with a user_id.  
      # All we need to do to ensure they don't get extra privelages is to NOT ASSOCIATE AN 
      # ACCOUNT to the membership, ONLY a project_id
      @test_for_existing_user = User.find_by_email(params[:member][:email])
      @project = Project.find(params[:member][:project_id])
      @member = @project.members.create(member_params_only_project)
      
      # store the welcome message
      @welcome_message = params[:message]
      
      logger.info(@test_for_existing_user)
      if !@test_for_existing_user
        # by default, this is a participating member, so:
        @project_invite = true
      else
        @existing_user_invite = true
        @member.user_id = @test_for_existing_user.id
        @member.save
        account = @project.account
        account.users << @test_for_existing_user if !account.users.include?(@test_for_existing_user)
      end    

    else
      # We're adding a family member to an account
      # let's only do this if it's not a dupe email
      @test_for_existing_user = User.find_by_email(params[:member][:email])

      @account = Account.find_by_id(params[:account_id])

      # ONLY FAMILY MEMBERS get a member-based association to an account
      @member = @account.members.create(member_params)
    
      # We need to create a permanent project for them
      # 
      #@proj = Project.new(title: @member.name, removable: "no", account_id: @account.id)
      #@proj.save!      
    
      #@member.project_id = @proj.id


    
      # Time to check and see if they're supposed to get an invite as well
      # but we'll send it after the save, so we have to flag it as an account invite
      if params[:participant] == "participant"    
        if @test_for_existing_user   
          @existing_account_invite = true
          @member.user_id = @test_for_existing_user.id
          @member.save
          @account.users << @test_for_existing_user if !@account.users.include?(@test_for_existing_user)
        else
          @account_invite = true
        end
      end
       
      
    end
    
     respond_to do |format|
        if @member.save
          # if we have a new project
          # let's then add the current_user as a member to the new project
          # actually we should add all family account members
          #if @proj
          #  Member.where(account_id: @account.id, status: "family").each do |m|
          #    u = m.user
          #    if u
          #      @proj.members.create()
          #    end
          #  #  @proj.members.create(project_id: @proj.id, user_id: u.id)
          #  end
          #end  
          
          # Let's deliver email, if needed
          InviteMailer.invite_to_account(@member, @account, current_user).deliver_later if @account_invite
          InviteMailer.invite_to_project(@member, @project, current_user, @welcome_message).deliver_later if @project_invite  
          InviteMailer.existing_project_invite(@member, @project, current_user, @welcome_message).deliver_later if @existing_user_invite
          InviteMailer.existing_account_invite(@member, @account, current_user).deliver_later if @existing_account_invite
          
          format.html { redirect_to root_path, notice: 'Hooray! We added a new member.' }
        else
          format.html { render action: "edit" }
        end
      end
  end
  
  def show
    @account = Account.find(params[:account_id])
    @member = Member.find(params[:id])
    
    name = @member.name.split(" ")[0]
    @items = get_filtered_current_account_items(@account, name)
    
    #
    #wildcard_search = "%#{name}%"

    #@items = Item.where("title ILIKE :search", search: wildcard_search).order(:list_id)
  end
  
  def destroy
    @member = Member.find(params[:id])

    
    respond_to do |format|
      if @member.delete
        format.js
        format.html { redirect_to root_path }
      end
    end
  end
  
  private
  
    def member_params
      params.require(:member).permit(:name, :birthday, :gender, :email, :project_id, :user_id, :account_id, :status)
    end
    
    def member_params_only_project
      params.require(:member).permit(:name, :birthday, :gender, :email, :project_id, :user_id, :status)
    end
    
    def get_filtered_current_account_items(account, name)
      items_to_return = []
      projects = account.projects
      projects.each do |p|
        lists = p.lists
        lists.each do |l|
          l.items.each do |item|
            if item.title =~ /(\s|^)#{name}(\s|$)/i
              items_to_return << item
            end
          end #items
        end #lists
      end #project loop
      
      return items_to_return
    end
    

end
