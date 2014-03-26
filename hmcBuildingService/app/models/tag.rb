# Simply a tag for buildings for searching and filtering by.
#
# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :buildings, :through => :taggings
end
