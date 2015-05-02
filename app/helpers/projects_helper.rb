module ProjectsHelper

  def return_potential_users_to_assign(project)
    #[{"id"=>1, "name"=>"Jason Preston"}]
    if project.removable == "no"
      members = Member.where.not(user_id: nil).where(account_id: project.account.id)
    else  
      members = Member.where.not(user_id: nil).where(project_id: project.id)
    end  
    user_names_and_ids_hash = Hash.new
    user_names_and_ids_hash["Assign it"] = 0
    members.each do |member|
      name = member.user.name 
      id = member.user.id
      user_names_and_ids_hash[name] = id
    end

    return user_names_and_ids_hash
  end
  
  
  def check_for_and_issue_assigned_todo_notifications(item)
    if item.user
      logger.info("Email notification logic")
      assigning_user = User.find(item.created_by)
      # If there's a user it's assigned to someone, and they should get a notification
      # IF the user has enabled notifications. [ "immediate", "off", "digest" ]
      # Also we should only do immediate e-mails for new to-dos with due dates
      if item.user.email_preference == "immediate"
        if item.due
          # send notification
          NotificationMailer.new_todo_assigned_to_user(item, item.user, assigning_user).deliver_later
        end  
      elsif item.user.email_preference == "digest"
        # queue notification
        # notification_string: "This user has assigned you a to-do"
        # Notification.new(user_id: item.user.id, creator_id: item.created_by, notification: notification_string, email_status: "queued", status: "new")
      else # "off"
        # no email notification -- tell the Notification object it's already sent
        # notification_string: "This user has assigned you a to-do"
        # Notification.new(user_id: item.user.id, creator_id: item.created_by, notification: notification_string, email_status: "sent", status: "new")        
      end  
      
    end
  end
  
  def check_for_and_issue_completed_todo_notifications(item)
    if item.user
      logger.info("Todo completed notification logic")
      assigning_user = User.find(item.created_by)
      completing_user = User.find(item.completed_by)
      # If someone completes a to-do, the assigning user should be notified
      # IF the user has enabled notifications. [ "immediate", "off", "digest" ]
      # AND IF the completing user is not the assigning user
      if assigning_user.email_preference == "immediate"
        if assigning_user != completing_user
          # send notification
          NotificationMailer.assigned_user_completed_todo(item, completing_user, assigning_user).deliver_later
        end
      elsif item.user.email_preference == "digest"
        # queue notification
        # notification_string: "This user has assigned you a to-do"
        # Notification.new(user_id: item.user.id, creator_id: item.created_by, notification: notification_string, email_status: "queued", status: "new")
      else # "off"
        # no email notification -- tell the Notification object it's already sent
        # notification_string: "This user has assigned you a to-do"
        # Notification.new(user_id: item.user.id, creator_id: item.created_by, notification: notification_string, email_status: "sent", status: "new")        
      end  
      
    end
  end

end
