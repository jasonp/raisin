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
      expire = unpaid_account.active_until.to_date
      now = Time.now.utc.to_date
      
      valid_until = (expire - now).to_i.to_s + " days left"
    end
    
    return valid_until
  end
  
  def self.updates_class(current_user)
    return "new_update_flag" if current_user.has_not_seen_the_latest_update(Update.last)
  end
  
  def self.send_daily_todo_summary_email
    # This will be an expensive, long-running background process :)
    
#   user = User.find(1)
#   item_ids = ["74"]
#   date_string = Time.zone.now.to_date.to_formatted_s(:long)
#   NotificationMailer.todos_due_today(item_ids, user, date_string).deliver_later
    
    users = User.all
    users.each do |user|
     Time.zone = user.time_zone
     # Let's send email only 7am, locally
     if Time.zone.now.hour > 6 && Time.zone.now.hour < 8
       date = Time.zone.now.to_date
       proto_items = Item.where(user_id: user.id, due: date).order(:list_id)
       
       # check to see if the account is active
       items = []
       proto_items.each do |pi|
         # is the account active?
         if pi.list.project.account.active_until > Time.now.utc
           # is the item checked off?
           if pi.status == "active"    
             items << pi
           end  
         end
       end
       
       # if we have items to send
       if items.count > 0
         item_ids = []
         items.each do |i|
           item_ids << i.id
         end  
     
         date_string = date.to_formatted_s(:long)
         if user.email_preference != "off"
           NotificationMailer.todos_due_today(item_ids, user, date_string).deliver_later
         end
       end #items count  
       
     end # btwn 7am        
    end # users.all do 
    
  end
  
  def self.subscribe_accounts_at_end_of_trail
    accounts = Account.where(active_until: (Time.now.tomorrow.midnight)..(Time.now.tomorrow.midnight + 1.day), plan: "trial")
    accounts.each do |a|
      cu = Stripe::Customer.retrieve(a.stripe_customer_id)
      cu.plan = "basic"
      cu.save
    end
    
  end
  
end   