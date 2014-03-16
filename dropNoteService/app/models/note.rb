class Note < ActiveRecord::Base
  def self.find_near_me(latitude, longitude, range, user)
    lat_upr_bound = latitude.to_f + range.to_f
    long_upr_bound = longitude.to_f + range.to_f
    lat_lwr_bound = latitude.to_f - range.to_f
    long_lwr_bound = longitude.to_f - range.to_f

    attrs = "title, tags, user, latitude, longitude, altitude, id"
    users = user.split(", ")
    n = Note.where(latitude: lat_lwr_bound...lat_upr_bound,
                   longitude: long_lwr_bound...long_upr_bound,
                   user: users.pop).select(attrs)
    for u in users
      n += Note.where(latitude: lat_lwr_bound...lat_upr_bound,
               longitude: long_lwr_bound...long_upr_bound,
               user: u).select(attrs)
    end
    n
  end

  def self.valid_user_password(user, password)
    n = Note.where(user: user)
    result = true
    if !n.empty?
      result = (n.first.password == password)
    end
    result
  end
end
