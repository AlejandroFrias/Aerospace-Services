# Each meal uniquely belongs to one menu. A meal itself is simply the name of the meal.
# 
# == Schema Information
#
# Table name: meals
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class Meal < ActiveRecord::Base
	belongs_to :menu
end
