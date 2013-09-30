class BuildingController < ApplicationController
  def index

    @buildings = Building.find_near_me(params[:latitude]  || 0,
                                       params[:longitude] || 0, 
                                       params[:range] || 1)

  end
  private

end
