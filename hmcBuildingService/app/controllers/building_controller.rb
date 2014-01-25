require 'net/http'

class BuildingController < ApplicationController
  def index

    @buildings = Building.find_near_me(params[:latitude]  || 0,
                                       params[:longitude] || 0, 
                                       params[:range] || 200)

    buildings_with_classes = "SHAN, LAC, PA, ON, GA, BK, KE, JA, SP"
    dining_halls = "HOCH"

    @tags = []
    @buildings.each do |b|
      t = "building"
      if !buildings_with_classes[b.code].blank?
        t += ", classes"
      end
      if !dining_halls[b.code].blank?
        t += ", dininghall"
      end
      if !b.name["Dorm"].blank?
        t += ", dorm"
      end

      @tags += [t]
    end
  end

  def show
    attrs = "name, description, code"
    @building = Building.where(id: params[:id]).select(attrs).first

    t = Time.parse(params[:time]) rescue Time.now
    s = URI.escape(t.to_s)

    buildings_with_classes = "SHAN, LAC, PA, ON, GA, BK, KE, JA, SP"
    dining_halls = "HOCH"
    plays_music = "WEST"

    has_class_rooms = !@CLASS_ROOMS[@building.code].blank?
    has_dining_halls = !@DINING_HALLS[@building.code].blank?
    has_music = !@MUSIC[@building.code].blank?

    # If the building has classes, use EDO script to grab schedules
    if has_class_rooms

      xml_raw = Net::HTTP.get(URI.parse("#{@EDO_URL}building/?time=#{s}&building=#{@building.code}"))
      xml_doc = Nokogiri::XML(xml_raw)
      edo_xml = xml_doc.xpath('//array/*')

      # If there were no classes found at that time
      if edo_xml.first.element_children.none?
        edo_xml = ""
      else
        edo_xml = edo_xml.to_xml
      end
    # If the building is the HOCH (or any dining hall) use edo script for getting menus
    elsif has_dining_halls

      xml_raw = Net::HTTP.get(URI.parse("#{@EDO_URL}dininghall/?time=#{s}&code=#{@building.code}"))
      xml_doc = Nokogiri::XML(xml_raw)
      edo_xml = xml_doc.xpath('//array/*')

      # If there were no menus found at that time
      if edo_xml.first.element_children.none?
        edo_xml = ""
      else
        edo_xml = edo_xml.to_xml
      end
    elsif has_music
      xml_raw = Net::HTTP.get(URI.parse("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=rj&api_key=51433a913f106680dbed95c47033fe87"))
      xml_doc = Nokogiri::XML(xml_raw)
      recenttracks = xml_doc.xpath('//recenttracks')
      
      # If there were no recent tracks found
      if recenttracks.first.element_children.none?
        edo_xml = ""
      else
        edo_xml = recenttracks.first.to_xml
      end
    else
      edo_xml = ""
    end

    
    @EDO_xml = edo_xml.html_safe
      
  end
end
