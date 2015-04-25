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
  
end