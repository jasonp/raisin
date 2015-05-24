# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :text
#  removable   :string
#  description :text
#  account_id  :integer
#  status      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
