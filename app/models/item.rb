# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  title        :text
#  list_id      :integer
#  user_id      :integer
#  due          :datetime
#  status       :text
#  created_by   :integer
#  completed_by :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  flep         :string
#

class Item < ActiveRecord::Base

  belongs_to :list
  belongs_to :user
  
  has_many :notifications
  has_many :comments
  
  validates :title, presence: true

end
