class Bathroom < ActiveRecord::Base
  def self.find_near_me(latitude, longitude, range)
    lat_upr_bound = latitude.to_f + range.to_f
    long_upr_bound = longitude.to_f + range.to_f
    lat_lwr_bound = latitude.to_f - range.to_f
    long_lwr_bound = longitude.to_f - range.to_f

    attrs = "sex, latitude, longitude, altitude, id, building, floor"
    Bathroom.where(latitude: lat_lwr_bound...lat_upr_bound,
                   longitude: long_lwr_bound...long_upr_bound).select(attrs)
  end
end
