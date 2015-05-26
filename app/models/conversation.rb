class Conversation < ActiveRecord::Base
  
  belongs_to :project
  belongs_to :user
  belongs_to :member
  
  has_many :comments
  has_many :notifications
  
  validates :title, presence: true
end
