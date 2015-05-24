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

require 'test_helper'

class ListTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
