# == Schema Information
#
# Table name: updates
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  user_id    :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Update < ActiveRecord::Base
  
  belongs_to :user
end
