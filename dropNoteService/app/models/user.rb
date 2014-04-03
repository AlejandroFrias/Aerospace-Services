# == Purpose
#
# A system of users has been created to limit the view of notes to just your 
# own and other if needed other people's notes as desired. Without this there 
# would be too many notes to be practical.
#
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :friendships
  has_many :friends, :class_name => "User", :through => :friendships
  has_many :notes, dependent: :destroy

  # === Description
  # 
  # Authenticates a given username/password combo. If it is a new username a new user 
  # is created.
  # Returns the user if authentication passes, otherwise returns false.
  # 
  # === Parameters:
  # +username+ - the name of the user (string)
  # +password+ - the given password (string)
  # 
  def self.authenticate(username, password)
    if username.blank?
      return false
    end

    user = User.create_with(password: password).find_or_create_by(name: username)
    if user.password == password
      return user
    else
      return false
    end
  end
end
