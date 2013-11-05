class Menu < ActiveRecord::Base
	has_many :meals, dependent: :destroy
end
