# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  account_id :integer
#  name       :text
#  email      :text
#  birthday   :datetime
#  gender     :text
#  photo      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :text
#

require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
