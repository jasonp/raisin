class PaymentsMailer < ApplicationMailer
  include Stripe::Callbacks

  after_invoice_payment_succeeded! do |invoice, event|
    account = Account.find_by_stripe_customer_id(invoice.customer)
    user = account.users.first
    
    account.plan = "basic"
    
    # update the active_until 
    new_active_until = Time.now.utc + 1.month
    account.active_until = new_active_until + 7.days
    account.save
    
    new_invoice(user).deliver_later
  end
  
  after_invoice_payment_failed do |invoice, event|
    account = Account.find_by_stripe_customer_id(invoice.customer)
    user = account.users.first
    
    # send the user a notice to update their payment info
    payment_failed(user).deliver_later
    
  end
  
  def payment_failed(user)
    @user = user
    @to_user_name = @user.name.split(" ")[0]
    from_email_with_name = %("Raisin" <dispatch@raisinhq.com>)
    to_email_with_name = %("#{@to_user_name}" <#{user.email}>)
    
    mail to: to_email_with_name, 
         from: from_email_with_name,
         subject: '(Raisin) Payment problem'
  end

  def new_invoice(user)
    @user = user
    @to_user_name = @user.name.split(" ")[0]
    @active_until = Date.today + 1.month
    from_email_with_name = %("Raisin" <dispatch@raisinhq.com>)
    to_email_with_name = %("#{@to_user_name}" <#{user.email}>)
    
    mail  to: to_email_with_name,
          from: from_email_with_name,
          subject: '(Raisin) Subscription Receipt'
  end

end
