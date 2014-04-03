# == Purpose
#
# Essentially a descriptive tag for search purposes.
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
  has_many :tags, :through => :taggings
end
