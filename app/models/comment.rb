class Comment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :item
  belongs_to :list
  
  # belongs_to :file
  # belongs_to :conversation
  
  validates :content, presence: true
  
end
