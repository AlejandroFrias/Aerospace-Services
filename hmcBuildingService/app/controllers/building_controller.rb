require 'net/http'

class BuildingController < ApplicationController
  def index

    @buildings = Building.find_near_me(params[:latitude]  || 0,
                                       params[:longitude] || 0, 
                                       params[:range] || 1)

  end

  def show
    attrs = "description"
    @building = Building.where(params[:id]).select(attrs).first

    t = Time.parse(params[:time]) rescue Time.now
    s = URI.escape(t.to_s)

    xml = Net::HTTP.get(URI.parse("http://localhost:3001/?time=#{s}"))

    @EDO_xml = xml.html_safe
  end
end
