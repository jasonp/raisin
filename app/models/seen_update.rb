# == Schema Information
#
# Table name: seen_updates
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  post_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SeenUpdate < ActiveRecord::Base
  
  belongs_to :user

end
