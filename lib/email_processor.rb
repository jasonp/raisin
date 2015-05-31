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
      array = id_string.split("-")
      
      # do some "introspection"
      if array.include?("item")
        # it's a reply to a to-do action: assigned, or completed
        # use the flep to uniquely ID the item across instances, and prevent guessed comment postings
        # item = Item.find_by_id(array[1])
        item = Item.where(id: array[1], flep: array[3]).first
      end
      
      if array.include?("conversation")
        # same routine as above
        conversation = Conversation.where(id: array[1], flep: array[3]).first
      end
      
      if item
        
        paragraph_body = @email.body.gsub(/(?<!^)\n\n(?!$)/,'<br /><br />')
      
        if comment = Comment.create!(content: paragraph_body, user_id: author.id, item_id: item.id)
        
          existing_notifications = Notification.where(item_id: item.id)
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
    
      end  #item
      
      if conversation
        
        paragraph_body = @email.body.gsub(/(?<!^)\n\n(?!$)/,'<br /><br />')
      
        if comment = Comment.create!(content: paragraph_body, user_id: author.id, conversation_id: conversation.id)
        
          existing_notifications = Notification.where(conversation_id: conversation.id)
          user_ids = []
        
          existing_notifications.each do |en|
            if en.user != author
              user_ids << en.user.id unless en.mute
            end
          end
       
          if conversation.user.id != author.id
            user_ids << conversation.user.id 
          end
          check_for_and_issue_notifications_for(comment, user_ids, "comment_added_to_conversation")
        end        
        
      end # conversation
    end #author
    
  end
  
  
end