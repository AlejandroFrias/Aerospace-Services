# Connects tags to buildings, allowing for a many-to-many relation
#
# == Schema Information
#
# Table name: taggings
#
#  id          :integer          not null, primary key
#  building_id :integer
#  tag_id      :integer
#  created_at  :datetime
#  updated_at  :datetime
#
class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :building
end
