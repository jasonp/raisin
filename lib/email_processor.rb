class EmailProcessor
  include ActionView::Helpers::ApplicationHelper
  
  def initialize(email)
    @email = email
  end

  def process
    # all of your application-specific code here - creating models,
    # processing reports, etc

    # Here's an example of model creation
    #user = User.find_by_email(@email.from[:email])
    #user.posts.create!(
    #  subject: @email.subject,
    #  body: @email.body
    #)
    
    author = User.find_by_email(@email.from[:email])
    
    if author
      id_string = @email.to.first[:token]
      string = id_string.split("-")
      
      # do some "introspection"
      if string.include?("comment")
        # it's a comment reply, item & comment ID supplied
        item = Item.find_by_id(string[1])
      else
        # only two options right now: it's a reply to a to-do action: assigned, or completed
        item = Item.find_by_id(string[1])
      end
      if item.id
        item_id = item.id
      end  
      
      if comment = Comment.create!(content: @email.body, user_id: author.id, item_id: item_id)
        
        existing_notifications = Notification.where(item_id: item_id)
        user_ids = []
        
        existing_notifications.each do |en|
          if en.user != author
            user_ids << en.user.id unless en.mute
          end
        end
        
        if item.user.id != author.id
          user_ids << item.user.id 
        end
        check_for_and_issue_notifications_for(comment, user_ids, "comment_added_to_item")
      end
    end
    
  end
  
  
end