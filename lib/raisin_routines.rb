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
  
  def self.send_daily_todo_summary_email
    # This will be an expensive, long-running background process :)
    users = User.all
    users.each do |user|
      Time.zone = user.time_zone
      # Let's send email only between 5 & 8am, locally
      if Time.zone.now.hour > 21 && Time.zone.now.hour < 23
        date = Time.zone.now.to_date
        items = Item.where(user_id: user.id, due: date).order(:list_id)
        if items.count > 0
          item_ids = []
          items.each do |i|
            item_ids << i.id
          end  
          
          date_string = date.to_formatted_s(:long)
          NotificationMailer.todos_due_today(item_ids, user, date_string).deliver_later
        end  
      end # btwn 5-8am        
    end # users.all do 
    
  end
  
end   