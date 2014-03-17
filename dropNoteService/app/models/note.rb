class Note < ActiveRecord::Base
  belongs_to :user
  has_many :taggings
  has_many :tags, :through => :taggings

  def self.find_near_me(params)
    lat = params[:latitude]
    long = params[:longitude]
    range = params[:range]
    user = params[:user]
    us = params[:users]
    ts = params[:tags]

    lat_upr_bound = lat.to_f + range.to_f
    long_upr_bound = long.to_f + range.to_f
    lat_lwr_bound = lat.to_f - range.to_f
    long_lwr_bound = long.to_f - range.to_f

    attrs = "title, latitude, longitude, altitude, id"
    
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
