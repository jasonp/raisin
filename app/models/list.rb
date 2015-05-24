# == Schema Information
#
# Table name: lists
#
#  id          :integer          not null, primary key
#  title       :text
#  status      :text
#  project_id  :integer
#  position    :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class List < ActiveRecord::Base
  
  belongs_to :project
  has_many :items, dependent: :destroy
  
  has_many :notifications
  has_many :comments
  
  validates :title, presence: true
  
end
