class Project < ActiveRecord::Base
  
  # Projects / Users
  has_many :members
  has_many :users, through: :members
  
  belongs_to :account
end
