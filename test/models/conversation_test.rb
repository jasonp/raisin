# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  user_id    :integer
#  project_id :integer
#  status     :string
#  flep       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
