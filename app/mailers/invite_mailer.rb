class InviteMailer < ApplicationMailer
  default from: 'dispatch@raisinhq.com'
  
  def invite_to_account(member, account, inviter)
    @name = member.name
    @from_name = inviter.name
    @url = new_user_registration_url(email: member.email, name: member.name)
    
    to_email_with_name = %("#{@name}" <#{member.email}>)
    from_email_with_name = %("#{@from_name} (Raisin)" <dispatch@raisinhq.com>)
    subject_line = %(Join the #{account.name} family on Raisin)
    

    mail(to: to_email_with_name, from: from_email_with_name, subject: subject_line)
  end
  
  def invite_to_project(member, project, inviter, message)
    @name = member.name
    @from_name = inviter.name
    @url = new_user_registration_url(email: member.email, name: member.name)
    @title = project.title
    @message = message
    
    to_email_with_name = %("#{@name}" <#{member.email}>)
    from_email_with_name = %("#{@from_name} (Raisin)" <dispatch@raisinhq.com>)
    subject_line = %(Join the #{@title} project on Raisin)
    
    mail(to: to_email_with_name, from: from_email_with_name, subject: subject_line)
  end  
  
  def existing_project_invite(member, project, current_user)
    @name = member.name
    @from_name = inviter.name
    @url = new_user_registration_url(email: member.email, name: member.name)
    @title = project.title
    @message = message
    
    to_email_with_name = %("#{@name}" <#{member.email}>)
    from_email_with_name = %("#{@from_name} (Raisin)" <dispatch@raisinhq.com>)
    subject_line = %(Join the #{@title} project on Raisin)
    
    mail(to: to_email_with_name, from: from_email_with_name, subject: subject_line)
    
  end
  
  def existing_account_invite(member, account, current_user)
    @name = member.name
    @from_name = inviter.name
    @url = accounts_url
    
    to_email_with_name = %("#{@name}" <#{member.email}>)
    from_email_with_name = %("#{@from_name} (Raisin)" <dispatch@raisinhq.com>)
    subject_line = %(Join the #{account.name} family on Raisin)
    

    mail(to: to_email_with_name, from: from_email_with_name, subject: subject_line)
  end

end
