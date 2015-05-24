# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  creator_id      :integer
#  notification    :text
#  email_status    :string
#  status          :string
#  item_id         :integer
#  list_id         :integer
#  project_id      :integer
#  conversation_id :integer
#  file_id         :integer
#  mute            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
