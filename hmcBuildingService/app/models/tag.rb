class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :buildings, :through => :taggings
end
