require 'net/http'

# poi lists of buildings (index) and info on individual buildings (show)
class BuildingController < ApplicationController
  # Permits params latitude, longitude, range, tags.
  # Finds all buildings within the bounding box that have any of the given tags.
  # Defaults are accepted. Check Building.find_near_me
  def index
    @buildings = Building.find_near_me(search_params)
  end

  # Displays all available building info for a specific building.
  # All buildings have tags, a name, and a description to be shown.
  # Class Schedules, Menus and Music Play-lists are displayed for buildings
  # tagged as 'classes', 'dininghall' and 'music' reflectively
  def show
    attrs = "name, description, code, id"
    @building = Building.where(id: params[:id]).select(attrs).first

    t = Time.parse(params[:time]) rescue Time.now
    s = URI.escape(t.to_s)

    if @building.tags.include?(Tag.find_by_name("classes"))

      xml_raw = Net::HTTP.get(URI.parse("#{@EDO_URL}building/?time=#{s}&building=#{@building.code}"))
      xml_doc = Nokogiri::XML(xml_raw)
      edo_xml = xml_doc.xpath('//array/*')

      # If there were no classes found at that time
      if edo_xml.first.element_children.none?
        edo_xml = ""
      else
        edo_xml = edo_xml.to_xml
      end
    elsif @building.tags.include?(Tag.find_by_name("dininghall"))

      xml_raw = Net::HTTP.get(URI.parse("#{@EDO_URL}dininghall/?time=#{s}&code=#{@building.code}"))
      xml_doc = Nokogiri::XML(xml_raw)
      edo_xml = xml_doc.xpath('//array/*')

      # If there were no menus found at that time
      if edo_xml.first.element_children.none?
        edo_xml = ""
      else
        edo_xml = edo_xml.to_xml
      end
    elsif @building.tags.include?(Tag.find_by_name("music"))
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

  private
    # White list permitted parameters
    def search_params
      params.permit(:latitude, :longitude, :range, :tags)
    end
end
