class BuildingController < ApplicationController
  def index

    @buildings = Building.find_near_me(params[:longitude], params[:latitude], 3)

  end
  private

end
