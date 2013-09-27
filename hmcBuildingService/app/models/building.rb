class Building < ActiveRecord::Base
  def self.find_near_me(latitude, longitude, range)
    buildings = Building.all;
    lat_upr_bound = latitude.to_f + range.to_f
    long_upr_bound = longitude.to_f + range.to_f
    lat_lwr_bound = latitude.to_f - range.to_f
    long_lwr_bound = longitude.to_f - range.to_f
    Building.where(latitude: lat_lwr_bound...lat_upr_bound, longitude: long_lwr_bound...long_upr_bound)
    #Building.where(latitude: (latitude - range)..(latitude + range), longitude: (longitude - range)..(longitude + range))
  end
end