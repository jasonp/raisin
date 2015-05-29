include ActionView::Helpers::SanitizeHelper
include ActionView::Helpers::TextHelper
module ApplicationHelper

  
  # action is used to determine the type of notification email sent. Valid options:
  # [ "new_todo_assigned", "todo_completed", "comment_added_to_item" ]
  
  def check_for_and_issue_notifications_for(object, users, action)

    # set string & create notification object
    # also, look up existing notifications since I'm doing the logic anyway
    if object.instance_of? List
      notification_string = "There is a new comment on the list: #{object.title}"
      existing_notifications = Notification.where(list_id: object.id)
    elsif object.instance_of? Item
      notification_string = "There is an update on the to-do list item: #{object.title}"
      existing_notifications = Notification.where(item_id: object.id)
    elsif object.instance_of? Project
      notification_string = "There is a new comment on the project: #{object.title}"
      existing_notifications = Notification.where(project_id: object.id)
    elsif object.instance_of? Conversation
      notification_string = "There is a new conversation: #{object.title}"
      existing_notifications = [] # an explicit list
    elsif object.instance_of? Comment
      if object.item
        notification_string = "There is a new comment on the to-do: #{object.item.title}"
        # no existing notifications, because item comment notifications are sent to
        # an explicit list
        existing_notifications = []
      elsif object.list
        notification_string = "There is a new comment on the to-do list: #{object.list.title}"
        existing_notifications = Notification.where(list_id: object.list.id)
      elsif object.conversation
        notification_string = "There is a new comment on the conversation: #{object.conversation.title}"
        existing_notifications = [] # Again, an explicit list
      end
    end
  
    # Look up explicitly passed array of ***** user IDs ******
     
    users_to_notify = []
    users.each do |user|
      users_to_notify << User.find(user)
    end
    
    # add_specifically_flagged_users_to_recipients_array(existing_notifications)
    
    muted_users = []
    existing_notifications.each do |en|
      users_to_notify << en.user
      muted_users << en.user if en.mute == "yes" # track who's muted the thread
    end
    logger.info("------>> MUTED USERS")
    logger.info(muted_users)
    
    # final_notifications_array = []
    final_notifications_array = add_or_remove_users_from_recipients_based_on_preferences(muted_users, users_to_notify)
    
    # create the notifications
    new_notifications = []
    final_notifications_array.each do |user|
      notification = create_notification_object_with_optional_string(object, notification_string, user)
      new_notifications << notification
    end  
    
    # send notifications as prescribed
    send_proper_mailer_based_on_notification(action, new_notifications, object)

    return true

  end # method
  
  
  def send_proper_mailer_based_on_notification(action, new_notifications, object)
    new_notifications.each do |nn|
      if nn.email_status == "send"
      
        if action == "new_todo_assigned"  
          assigning_user = User.find(object.created_by)
          if NotificationMailer.new_todo_assigned_to_user(object, object.user, assigning_user).deliver_later
            nn.email_status = "sent"
          end
        elsif action == "todo_completed"
          assigning_user = User.find(object.created_by)
          completing_user = User.find(object.completed_by)
          if NotificationMailer.assigned_user_completed_todo(object, completing_user, assigning_user).deliver_later
            nn.email_status = "sent"
          end
        elsif action == "conversation_started"
          if NotificationMailer.new_conversation_started(object, nn.user).deliver_later
            nn.email_status = "sent"
          end
        elsif action == "comment_added_to_item"
          item = object.item
          commenting_user = object.user
          notified_user = nn.user
          if NotificationMailer.new_comment_added_to_item(object, item, notified_user, commenting_user).deliver_later
            nn.email_status = "sent"
          end
        elsif action == "comment_added_to_conversation"
          conversation = object.conversation
          commenting_user = object.user
          notified_user = nn.user
          preview = strip_tags(object.content)
          #preview = sanitize object.content, tags: %w(strong em a)
					sub_line = truncate(preview, length: 45)
          if NotificationMailer.new_comment_added_to_conversation(object, conversation, notified_user, commenting_user, sub_line).deliver_later
            nn.email_status = "sent"
          end
        end
      
      end # status send      
    end # nn loop
  end
  
  
  def add_or_remove_users_from_recipients_based_on_preferences(muted_users, users_to_notify)
    
    unique_muted_users = muted_users.uniq
    unique_users_to_notify = users_to_notify.uniq

    unique_users_to_notify.delete_if { |u| unique_muted_users.include?(u) }
    
    return unique_users_to_notify
    
  end
  
  def create_notification_object_with_optional_string(object, string, user)
    
    # set the notification email_status based on user pref [ "immediate", "off", "digest" ]
     if user.email_preference == "immediate"
       email_status = "send"
       logger.info ("Set to Send")
     elsif user.email_preference == "digest"
       email_status = "queued"
     else # off
       email_status = "sent"
       logger.info("Email Status set to OFF")
     end    
    
    # set the right notification type
    if object.instance_of? List
      list_id = object.id 
    elsif object.instance_of? Item
      item_id = object.id 
      created_by = object.created_by
      logger.info("========== created by ===========")
      logger.info(created_by)
      logger.info(object.completed_by)
      # catch notifcations for self-completed to-dos 
      if created_by == object.completed_by
        email_status = "sent"
      end
    elsif object.instance_of? Project
      project_id = object.id
    elsif object.instance_of? Conversation
      conversation_id = object.id
      created_by = object.user.id
    elsif object.instance_of? Comment
      if object.item
        item_id = object.item.id
      elsif object.conversation
        conversation_id = object.conversation.id
      end
      created_by = object.user.id
    end
    
    # file_id = object.id if object.instance_of? File
    # conversation_id = object.id if object.instance_of Conversation   
  
    
    
    notification_string = string || "Notification: Something has been updated."
    
    notification = Notification.new(user_id: user.id, creator_id: created_by, notification: notification_string, email_status: email_status, status: "new", item_id: item_id, list_id: list_id, project_id: project_id, file_id: nil, conversation_id: conversation_id) 
    notification.save
    
    return notification
  end  
  
  def return_default_users_to_notify(item)
    # the user that made the to-do
    default_users_to_notify = []
    default_users_to_notify << User.find_by_id(item.created_by)
    
    # the user that it's assigned to (if exists)
    default_users_to_notify << item.user
    
    # anyone who has already commented
    item.comments.each do |c|
      default_users_to_notify << c.user
    end
    
    # remove anyone who's muted
    muted_this_item = []
    Notification.where(item_id: item.id).each do |n|
      muted_this_item << n.user if n.mute
    end
    
    unique_default_users_to_notify = default_users_to_notify.uniq
    
    unique_default_users_to_notify.delete_if { |u| muted_this_item.include?(u) }
    return unique_default_users_to_notify
    
  end
  
  
  def count_notifiable_users(notifiable_users)
    count = 0
    notifiable_users.each do |u|
      count = count + 1 unless u == current_user
    end
    return count
  end
  
  
end
