# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  user_id    :integer
#  project_id :integer
#  status     :string
#  flep       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Conversation < ActiveRecord::Base
  
  belongs_to :project
  belongs_to :user
  belongs_to :member
  
  has_many :comments
  has_many :notifications
  
  validates :title, presence: true
end
