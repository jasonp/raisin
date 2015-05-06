class EmailProcessor
  
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
    
    #author = User.where( email: @email.from ).first
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
      
      comment = Comment.create!(content: @email.body, user_id: author.id, item_id: item_id)
    end
    
  end
  
  
end