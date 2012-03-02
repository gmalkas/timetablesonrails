class User < ActiveRecord::Base
  attr_accessible :username, :name, :email, :session_token
  has_secure_password
end
