# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :text
#  removable   :string
#  description :text
#  account_id  :integer
#  status      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Project < ActiveRecord::Base
  
  # Projects / Users
  has_many :members
  has_many :users, through: :members
  has_many :lists, dependent: :destroy
  has_many :comments
  has_many :notifications
  has_many :conversations
  
  belongs_to :account
  
  validates :title, presence: true
end
