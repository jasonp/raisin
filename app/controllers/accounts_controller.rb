include AccountsHelper
class AccountsController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :show, :edit, :update, :archive]
  before_filter :authenticate_account, only: [:show, :edit, :update]
  
  # before_filter :verify_active, only: [:show, :edit, :update]
  
  def index
    #if admin, 
      # show all accounts
    # else
    
    @accounts = current_user.accounts
      
  end
  
  def new
    
    @account = Account.new
    if !current_user
      1.times { @account.users.build }
    end
    
    respond_to do |format|

      format.html { 'new' }
   
    end  
    
  end
  
  def recently
    @account = Account.find(params[:account_id])
    @projs = Project.where(account_id: @account.id, removable: nil).order(:updated_at)
    
    # Same process... what do they have permission to see?
    @projects = []
    @inactive_count = 0
    @projs.each do |p|
      if p.status == "active"
        if p.users.include?(current_user)
          @projects << p 
        end  
      else
        @inactive_count = @inactive_count + 1 if p.status == "garage"
      end  
    end
    
    
    respond_to do |format|
      format.js
    end
  end
  
  def createdorder
    @account = Account.find(params[:account_id])
    @projs = Project.where(account_id: @account.id, removable: nil).order(:created_at)
    
    # Same process... what do they have permission to see?
    @projects = []
    @inactive_count = 0
    @projs.each do |p|
      if p.status == "active"
        if p.users.include?(current_user)
          @projects << p 
        end  
      else
        @inactive_count = @inactive_count + 1 if p.status == "garage"
      end  
    end
    
    
    respond_to do |format|
      format.js { render 'recently' }
    end
  end
  
  def alphabetical
    @account = Account.find(params[:account_id])
    @projs = Project.where(account_id: @account.id, removable: nil).order(:title)
    
    # Same process... what do they have permission to see?
    @projects = []
    @inactive_count = 0
    @projs.each do |p|
      if p.status == "active"
        if p.users.include?(current_user)
          @projects << p 
        end  
      else
        @inactive_count = @inactive_count + 1 if p.status == "garage"
      end  
    end
    
    
    respond_to do |format|
      format.js { render 'recently' }
    end
  end
  
  def create

    @account = Account.new(account_params)
    @account.active_until = Time.now.utc + 2.months
    
    if current_user
      @account.users << current_user
    end
    
    
    respond_to do |format|
      if @account.save
        if !current_user
          sign_in @account.users.last
        end
        
        current_user.time_zone = "Pacific Time (US & Canada)"
        current_user.save 
        
        check_for_and_associate_members_and_accounts(current_user)

        NotificationMailer.new_account_created(@account).deliver_later
        
        #@proj = @account.projects.create(title: current_user.name, removable: "no")
        #@proj.members.create(user_id: current_user.id, account_id: @account.id)
        Member.create(user_id: current_user.id, account_id: @account.id, name: current_user.name)
        
        #create_sample_todo_list_on_permanent_project(@proj)
        create_sample_project_for_new_account(@account)        
        
        format.html { redirect_to root_path, notice: 'All set! Welcome to Raisin.' }
        format.json { render json: root_path, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @account = Account.find_by_id(params[:id])
    @page_title = " - " + @account.name
    
    # Only display family members to other family members
    @fam_member = Member.where(account_id: @account.id, user_id: current_user.id)
    if @fam_member.count > 0
      @family_members = Member.where(account_id: @account.id).order(:created_at)
      #@family_members = Project.where(account_id: @account.id, removable: "no")
    end  
    
    @projs = Project.where(account_id: @account.id, removable: nil)
    
    # Same process... what do they have permission to see?
    @projects = []
    @inactive_count = 0
    @projs.each do |p|
      if p.status == "active"
        if p.users.include?(current_user)
          @projects << p 
        end  
      else
        @inactive_count = @inactive_count + 1 if p.status == "garage"
      end  
    end
    
    
    session["preferred_account_id"] = @account.id
    
  end

  def edit
    # "Account settings"
  end

  def update
  end
  
  def archive
    # "Project in the garage"
    
    @account = Account.find(params[:account_id])
    @projects = Project.where(account_id: @account.id, removable: nil, status: "garage")
  end
  
  private

    def account_params
      params.require(:account).permit(:name, :plan, :active_until, :users_attributes => [:id, :email, :name, :email_preference, :password, :password_confirmation])
    end
    
    def check_for_and_associate_members_and_accounts(resource)
     # Find all the memberships that we need to associate, and associate them
     members = Member.where(email: resource.email)
     members.each do |m|
       # add the user to any accounts
       a = m.project.account
       if a
         a.users << resource if !a.users.include?(resource)
         a.save!
       end

       # and of course add the user_id to the membership record
       m.user_id = resource.id
       m.save!
     end
    end
    
    def authenticate_account
      account = Account.find(params[:id])
      if !account.users.include?(current_user)
        redirect_to root_path
      end
    end
    
    # Since nobody is paying for Raisin, and the payment API broke for some unknown reason
    # Let's just unhook the payment stuff, which lets me go to free Heroku
    def verify_active
      account = Account.find(params[:id])
      if account.active_until < Time.now.utc
        if account.stripe_customer_id
          flash[:subscription_expired] = "Your subscription has expired! Don't worry, your data is perfectly fine, but you'll need to update your payment information -- it looks like there was a problem charging your card on file."
          session["preferred_account_id"] = account.id
          redirect_to edit_subscription_path
        else
          flash[:subscription_expired] = "Your subscription has expired! Don't worry, your data is perfectly fine, but you'll need to enter your payment information and become a paying subscriber."
          session["preferred_account_id"] = account.id
          redirect_to new_subscription_path
        end
      end
    end
    
end
