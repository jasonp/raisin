class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
 
  has_and_belongs_to_many :accounts
  
  accepts_nested_attributes_for :accounts
 
 def self.from_omniauth(auth)
   u = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
     user.email = auth.info.email
     user.password = Devise.friendly_token[0,20]
     user.name = auth.info.name   # the user model has a name
     user.photo = auth.info.image # the user model has an image
   end
  
 end  
        
end
