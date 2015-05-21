class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_for_selected_account
  
  def new
  end
  
  def edit

    
    
  end
  
  def update
    account = Account.find(session["preferred_account_id"])
    cu = Stripe::Customer.retrieve(account.stripe_customer_id)
    action = ""
    
    
    if params[:commit] = "Cancel Subscription"
      # cu.subscriptions.retrieve("sub_6GLoJrs3Q0nkDo").delete
      action = "canceled"
    else
      cu.source = params[:stripe_card_token]
      cu.save
      action = "updated"
    end  
    
    respond_to do |format|
      if action == "updated"
        format.html { 
          flash[:notice] = "Payment information updated, thank you!"
          redirect_to root_path
          }
      else
        format.html { 
          flash[:notice] = "Sorry to see you go -- subscription canceled!"
          redirect_to root_path
          }
      end    
    end
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

  def check_for_selected_account
    if !session["preferred_account_id"]
      redirect_to accounts_path
    end
  end

  
end
