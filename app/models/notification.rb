class Notification < ActiveRecord::Base
  
  belongs_to :user
  
  belongs_to :item
  belongs_to :list
  
  # belongs_to :conversation
  # belongs_to :file
end
