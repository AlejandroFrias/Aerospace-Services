# == Purpose
#
# Notes belong to a single user and can have many tags. A note is simply a name and text. 
# 
# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name      :string(255)      not null
#  body       :text             not null
#  privacy_on :boolean          default(FALSE)
#  latitude   :decimal(12, 8)   not null
#  longitude  :decimal(12, 8)   not null
#  altitude   :decimal(12, 8)   default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

class Note < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :tags, :through => :taggings

  # Returns all the public notes based on given parameters and all of the current user's notes.
  # Search by bounding box (lat, long, range), tags, and users is available.
  # === Parameters
  #
  # * +user+ - the requesting user.
  # * +params+ - a hash that permits a bounding box (lat, long, range), tags, and users.
  # * +latitude+ - the latitude in degrees. Defaults to 0
  # * +longitude+ - the longitude in degrees. Defaults to 0
  # * +range+ - the range in degrees. Defaults to 200
  # * +tags+ - a comma separated list of tags. Defaults to all possible tags.
  # * +users+ - a comma separated list of users. Defaults to all possible users.
  # 
  def self.find_near_me(params, user)
    lat = params[:latitude] || 0
    long = params[:longitude] || 0
    range = params[:range] || 200
    us = params[:users] || ""
    ts = params[:tags] || ""

    lat_upr_bound = lat.to_f + range.to_f
    long_upr_bound = long.to_f + range.to_f
    lat_lwr_bound = lat.to_f - range.to_f
    long_lwr_bound = long.to_f - range.to_f

    attrs = "name, latitude, longitude, altitude, id"
    
    user_names = us.split(", ")
    tag_names = ts.split(", ")

    if user_names.blank?
      users = User.where.not(id: user.id)
    else
      users = User.where(name: user_names)
    end

    if tag_names.blank?
      tags = Tag.all
    else
      tags = Tag.where(name: tag_names)
    end

    # get all your notes in range
    notes = Note.where(latitude: lat_lwr_bound...lat_upr_bound,
                       longitude: long_lwr_bound...long_upr_bound,
                       user_id: user).select(attrs).select do |n|
      (n.tags & tags).any?
    end

    # get other people's non-private notes in range
    notes += Note.where(latitude: lat_lwr_bound...lat_upr_bound,
                        longitude: long_lwr_bound...long_upr_bound,
                        privacy_on: false, 
                        user_id: users).select(attrs).select do |n|
      (n.tags & tags).any?
    end
    
    # TODO add support for friends
    notes
  end

end
