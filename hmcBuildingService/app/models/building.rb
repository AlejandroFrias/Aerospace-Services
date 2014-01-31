class Building < ActiveRecord::Base
  def self.find_near_me(latitude, longitude, range)
    lat_upr_bound = latitude.to_f + range.to_f
    long_upr_bound = longitude.to_f + range.to_f
    lat_lwr_bound = latitude.to_f - range.to_f
    long_lwr_bound = longitude.to_f - range.to_f

    attrs = "name, latitude, longitude, altitude, id, code"
    Building.where(latitude: lat_lwr_bound...lat_upr_bound,
                   longitude: long_lwr_bound...long_upr_bound).select(attrs)
  end

  def has_class_rooms ()
    class_rooms = "SHAN, LAC, PA, ON, GA, BK, KE, JA, SP"
    
    !class_rooms[self.code].blank?
  end

  def has_dining_halls ()
    dining_halls = "HOCH"

    !dining_halls[self.code].blank?
  end
  
  def has_music ()
    music = "WEST"

    !music[self.code].blank?
  end

end
