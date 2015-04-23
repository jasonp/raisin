class Member < ActiveRecord::Base

  belongs_to :user
  belongs_to :project


  def self.add_user_to_project(user, project)
    m = Member.create(:user_id => user.id, :project_id => project.id)
  end
  
end
