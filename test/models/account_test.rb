# == Schema Information
#
# Table name: accounts
#
#  id                 :integer          not null, primary key
#  name               :text
#  stripe_customer_id :text
#  active_until       :datetime
#  plan               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
