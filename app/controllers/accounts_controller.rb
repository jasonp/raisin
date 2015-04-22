class AccountsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @account = Account.new
  end
  
  def create
    @user = current_user
    
    @account = @user.accounts.create(account_params)
    
    @account.active_until = Time.now.utc + 2.months
    
    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'All set! Welcome to Raisin.' }
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @account = Account.find_by_id(params[:id])
    @page_title = " - " + @account.name
    
  end

  def edit
  end

  def update
  end
  
  private

    def account_params
      params.require(:account).permit(:name, :active_until)
    end
end
