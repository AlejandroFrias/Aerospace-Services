require 'net/http'

class BuildingController < ApplicationController
  def index

    @buildings = Building.find_near_me(params[:latitude]  || 0,
                                       params[:longitude] || 0, 
                                       params[:range] || 1)

  end

  def show
    attrs = "description, code"
    @building = Building.where(id: params[:id]).select(attrs).first

    t = Time.parse(params[:time]) rescue Time.now
    s = URI.escape(t.to_s)

    buildings_with_classes = "SHAN, LAC, PA, ON, GA, BK, KE, JA, SP"

    
    # If the building has classes, use EDO script to grab schedules
    if buildings_with_classes[@building.code].blank?
      edo_xml = ""
    else 
      xml_raw = Net::HTTP.get(URI.parse("http://localhost:8080/edoWeb/services/invoke/building/?time=#{s}&building=#{@building.code}"))
      xml_doc = Nokogiri::XML(xml_raw)
      edo_xml = xml_doc.xpath('//array/schedule')

      # If there were no classes found at that time
      if edo_xml.first.element_children.none?
        edo_xml = ""
      else
        edo_xml = edo_xml.to_xml
      end
    end
    
    
      @EDO_xml = edo_xml.html_safe
      
  end
end
