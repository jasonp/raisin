# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :text
#  photo                  :text
#  phone                  :text
#  role                   :text
#  active_until           :datetime
#  stripe_customer_id     :text
#  provider               :text
#  uid                    :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  email_preference       :string
#  time_zone              :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
