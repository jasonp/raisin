class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :check_for_selected_account
  
  def new
  end

  def create
    
    token = params[:stripe_card_token]
    email = current_user.email
    account = Account.find(session["preferred_account_id"])

    if account.active_until > Time.now.utc
      begin
        # Create a Customer
        customer = Stripe::Customer.create(
          :source => token,
          :email => email
        )
      rescue Stripe::CardError => e
        @stripe_error = e.message
        # The card has been declined
      end
    else
      begin
        # Create a Customer
        customer = Stripe::Customer.create(
          :source => token,
          :plan => "basic",
          :email => email
        )
      rescue Stripe::CardError => e
        @stripe_error = e.message
        # The card has been declined
      end
    end  
    

    respond_to do |format|
      if @stripe_error
        format.html { 
          flash.now[:warning] = @stripe_error.to_s
          render 'new'
        }
      else
        account = Account.find_by_id(session["preferred_account_id"])
        account.stripe_customer_id = customer.id
        if account.save
          format.html { redirect_to root_path, notice: "Subscribed!" }
        end  
      end
    end
  end
  
  private


  
end
