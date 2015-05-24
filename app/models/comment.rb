# == Schema Information
#
# Table name: comments
#
#  id              :integer          not null, primary key
#  content         :text
#  user_id         :integer
#  item_id         :integer
#  list_id         :integer
#  file_id         :integer
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Comment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :item
  belongs_to :list
  
  # belongs_to :file
  # belongs_to :conversation
  
  validates :content, presence: true
  
end
