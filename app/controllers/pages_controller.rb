class PagesController < ApplicationController
  
  def home
    @page_title = "- Project Management for Families"
    
    @redirect_route = ""
    if current_user
      if current_user.accounts.count < 1
        @redirect_route = "create"
      elsif current_user.accounts.count == 1
        @redirect_route = "dashboard"
      else
        if session["preferred_account_id"] != nil
          @redirect_route = "session"
        else
          @redirect_route = "pick"  
        end  
      end # accounts count > or < 1
        
    end # current user check
    
    
      if @redirect_route == "dashboard"
        redirect_to account_path(current_user.accounts.first) 
      elsif @redirect_route == "create"
        redirect_to new_account_path 
      elsif @redirect_route == "pick"
        redirect_to accounts_path 
      elsif @redirect_route == "session"
        redirect_to account_path(session["preferred_account_id"])        
      else
        
      end
    
    
  end
  
end
