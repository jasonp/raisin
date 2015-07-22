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
#  position     :integer
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
