# A building Point of Interest (POI). Every building has a name and description. 
# Certain buildings have other services available, like menus of dining halls.
# 
# == Schema Information
#
# Table name: buildings
#
#  id          :integer          not null, primary key
#  latitude    :decimal(12, 8)   not null
#  longitude   :decimal(12, 8)   not null
#  altitude    :decimal(12, 8)   default(0.0)
#  name        :string(255)      not null
#  description :text             not null
#  code        :string(255)      default("NONE")
#  created_at  :datetime
#  updated_at  :datetime
#
class Building < ActiveRecord::Base
  has_many :taggings
  has_many :tags, :through => :taggings

  # Finds all the buildings within a desired bounding box and that contain at 
  # least one of the given tags.
  #
  # === Parameters
  #
  # * +params+ - a hash that permits a bounding box (lat, long, range) and tags.
  # * +params\[:latitude\]+ - the latitude in degrees. Defaults to 0
  # * +params\[:longitude\]+ - the longitude in degrees. Defaults to 0
  # * +params\[:range\]+ - the range in degrees. Defaults to 200
  # * +params\[:tags\]+ - a comma separated list of tags. Defaults to all possible tags.
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
