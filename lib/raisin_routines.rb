class RaisinRoutines

# a few general purpose helpers for views, etc. Keeping the code clean if possible :)

  def self.show_payment_link_if_needed(session_account, current_user)
    unpaid_account = nil
    if session_account != nil
      account = Account.find(session_account)    
      if account.stripe_customer_id == nil
        if current_user == account.users.first
          unpaid_account = account
        end
      end
    end
    
    return unpaid_account
  end
  
  def self.time_until_account_expiration(unpaid_account)
    valid_until = "Expired!"
    if unpaid_account.active_until > Time.now.utc
      valid_until = "Soon!"
    end
    
    return valid_until
  end
  
end   