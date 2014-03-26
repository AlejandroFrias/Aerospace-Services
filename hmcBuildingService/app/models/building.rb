# == Schema Information
#
# Table name: buildings
#
#  id          :integer          not null, primary key
#  latitude    :decimal(12, 8)   not null
#  longitude   :decimal(12, 8)   not null
#  altitude    :decimal(12, 8)   default(0.0)
#  name        :string(255)
#  code        :string(255)      default("NONE")
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Building < ActiveRecord::Base
  has_many :taggings
  has_many :tags, :through => :taggings

  # Finds all the buildings within a desired bounding box with desired tags.
  # The defaults when not given certain parameters are:
  #      latitude = 0
  #     longitude = 0
  #         range = 200
  #          tags = Tag.all
  #
  # === Attributes
  #
  # * +params+ - a hash that permits lat, long, range, and tags
  # 
  def self.find_near_me(params)
    lat = params[:latitude] || 0
    long = params[:longitude] || 0
    range = params[:range] || 200
    tag_names = params[:tags] || ""
    if tag_names.blank?
      tags = Tag.all
    else
      tags = Tag.where(name: tag_names.split(", "))
    end
    lat_upr_bound = lat.to_f + range.to_f
    long_upr_bound = long.to_f + range.to_f
    lat_lwr_bound = lat.to_f - range.to_f
    long_lwr_bound = long.to_f - range.to_f

    attrs = "name, latitude, longitude, altitude, id, code"
    Building.where(latitude: lat_lwr_bound...lat_upr_bound,
                   longitude: long_lwr_bound...long_upr_bound).select(attrs).select do |b|
      (b.tags & tags).any?
    end
  end

end
