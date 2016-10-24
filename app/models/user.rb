class User < ApplicationRecord
	has_many :secrets
	has_many :likes, dependent: :destroy
	has_many :secrets_liked, through: :likes, source: :secret
	has_secure_password
	email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
    validates :email, :presence => true, :format => { :with => email_regex }, :uniqueness => { :case_sensitive => false }
    validates :name, presence: true
    validates_presence_of :password, on: :create
	validates_confirmation_of :password, :allow_blank => true
end
