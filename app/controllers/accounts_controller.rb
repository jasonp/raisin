class AccountsController < ApplicationController
  before_filter :authenticate_user!, only: [:index]
  
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
  end
  
  def create

    if !current_user
      @account = Account.new(account_params)
    else
      @account = current_user.accounts.create(account_params)
    end
    
    @account.active_until = Time.now.utc + 2.months
    
    respond_to do |format|
      if @account.save
        if !current_user
          sign_in @account.users.last
        end
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
    
    session["preferred_account_id"] = @account.id
    
  end

  def edit
  end

  def update
  end
  
  private

    def account_params
      params.require(:account).permit(:name, :active_until, :users_attributes => [:id, :email, :name, :password, :password_confirmation])
    end
    
    
end
