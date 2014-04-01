# == Purpose
#
# Used to keep track of connections between tags and notes. This allows 
# uniqueness of tags and quick searching. This is the best way to do a 
# many-to-many relation.
#
# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  note_id    :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :note
end
