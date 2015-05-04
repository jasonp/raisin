# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  title      :text
#  list_id    :integer
#  user_id    :integer
#  due        :datetime
#  status     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Item < ActiveRecord::Base

  belongs_to :list
  belongs_to :user
  
  has_many :notifications
  
  validates :title, presence: true

end
