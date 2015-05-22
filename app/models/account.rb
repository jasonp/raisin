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

class Account < ActiveRecord::Base
  include Stripe::Callbacks
  
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users
  
  has_many :projects
  has_many :members
  
  validates :name, presence: true
  validates :active_until, presence: true
  
  after_customer_subscription_deleted do |subscription, event|
    account = Account.where(stripe_customer_id: subscription.customer)
    account.plan = "canceled"
    account.save
  end
  
end
