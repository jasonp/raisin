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
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
 
  # Accounts / Users
  has_and_belongs_to_many :accounts
  accepts_nested_attributes_for :accounts
  
  # Projects / Users
  has_many :members
  has_many :projects, through: :members
  
  validates :name, presence: true
  validates :email, presence: true
  
 
 def self.from_omniauth(auth)
   u = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
     user.email = auth.info.email
     user.password = Devise.friendly_token[0,20]
     user.name = auth.info.name   # the user model has a name
     user.photo = auth.info.image # the user model has an image
   end
  
 end 
 
 # This is an existing user so let's not overwrite everything
 def self.link_from_omniauth(auth, user)
     user.photo = auth.info.image # the user model has an image
     user.provider = auth.provider
     user.uid = auth.uid
     return user
 end 
 
 
        
end
