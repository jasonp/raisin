# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  account_id :integer
#  name       :text
#  email      :text
#  birthday   :datetime
#  gender     :text
#  photo      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Member < ActiveRecord::Base

  belongs_to :user
  belongs_to :project
  

  def self.add_user_to_project(user, project)
    m = Member.create(:user_id => user.id, :project_id => project.id)
  end
  
end
