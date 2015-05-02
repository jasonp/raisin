class NotificationMailer < ApplicationMailer
  default from: 'dispatch@raisinhq.com'
  
  def new_todo_assigned_to_user(todo, assigned_user, assigning_user)
    @todo = todo
    @to_user_name = assigned_user.name
    @from_user_name = assigning_user.name
    
    
    @url_to_item = account_project_list_item_url(todo.list.project.account, todo.list.project, todo.list, todo)
    
    to_email_with_name = %("#{@to_user_name}" <#{assigned_user.email}>)
    from_email_with_name = %("#{@from_user_name} (Raisin)" <dispatch@raisinhq.com>)
    subject_line = %(#{@from_user_name} has assigned you a to-do on Raisin)
    reply_to_email = %("Raisin" <item-#{todo.id}@raisinhq.com>)
    

    mail(to: to_email_with_name, 
        from: from_email_with_name, 
        reply_to: reply_to_email,
        subject: subject_line)
  end
  
  def new_comment_added_to_object(comment, object, notified_user, commenting_user)
  end
  
  def assigned_user_completed_todo(todo, completing_user, assigning_user)
    @todo = todo
    @to_user_name = assigning_user.name
    @from_user_name = completing_user.name
    
    
    @url_to_item = account_project_list_item_url(todo.list.project.account, todo.list.project, todo.list, todo)
    
    to_email_with_name = %("#{@to_user_name}" <#{assigning_user.email}>)
    from_email_with_name = %("#{@from_user_name} (Raisin)" <dispatch@raisinhq.com>)
    subject_line = %(#{@from_user_name} completed a to-do you assigned them on Raisin)
    reply_to_email = %("Raisin" <item-#{todo.id}@raisinhq.com>)
    

    mail(to: to_email_with_name, 
        from: from_email_with_name, 
        reply_to: reply_to_email,
        subject: subject_line)
  end
  
  def todo_due_tomorrow(todo, assigned_user)
  end
  
 
end