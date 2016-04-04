class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :saml_authenticatable,:rememberable, :trackable, :validatable

	def password_required?
		false
	end

	def self.load_saml_data attributes
		user = where(email: attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"]).first_or_create do |user|
		  user.email = attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"].to_s
		end
		user.save!
		user
	end
end
