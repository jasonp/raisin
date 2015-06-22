# == Schema Information
#
# Table name: updates
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  user_id    :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
