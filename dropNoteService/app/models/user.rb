class User < ActiveRecord::Base
  has_many :friendships
  has_many :friends, :class_name => "User", :through => :friendships
  has_many :notes, dependent: :destroy

  def self.authenticate(user, password)
    if user.blank?
      return false
    end
    
    # Creates a new user if one did not already exist
    user = User.create_with(password: password).find_or_create_by(name: user)
    if user.password == password
      return user
    else
      return false
    end
  end
end
