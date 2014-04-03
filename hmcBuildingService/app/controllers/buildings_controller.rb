require 'net/http'
# Controller for Building Point of Interest (POI) Service.
# 
# Requires username/password (afrias/Aerospace13!) basic HTTP authentication 
# when editing, creating, or destroying buildings.
# 
# === Provided Services
# * POI list generation 
# => GET http://134.173.43.28:3000/buildings 
# => search params = tags, latitude, longitude, range
# * building information: description, menu, class schedule, music play list
# => GET http://134.173.43.28:3000/buildings/[:id] 
# => params = time
# * Create new building POI with given params
# => POST http://134.173.43.28:3000/buildings
# => required params = name, description, latitude, longitude
# => optional params = tags, code, altitude
# * Edit a building POI
# => PATCH/PUT http://134.173.43.28:3000/buildings/[:id]
# => params = name, description, latitude, longitude, tags, code, altitude
# * Delete a building POI
# => DESTROY http://134.173.43.28:3000/buildings/[:id]
# 
# === TODO: Future Work
# * Once conditionals are used in the EDO script, we can clean "show" code to just call the EDO service for external info.
# * Use altitude
# * Use update_frequency (maybe make it an actual attribute so buildings can have different frequencies)
class BuildingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_building, only: [:update, :destroy]
  http_basic_authenticate_with name: "afrias", password: "Aerospace13!", except: [:index, :show] 
  
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

  # A POST request to the create_url given in the POI List attempts to create a new building.
  # If the required attributes are not specified or the creation fails for any other 
  # reason, an error message is returned. If a new building is successfully created, a
  # success message is returned.
  # 
  # === Required Attributes (Passed by Parameters)
  # 
  # * +name+ - the full name of the building (used for display of POI)
  # * +description+ - every building has a small, sometime historical, snippet of info
  # * +latitude+ - the latitude of it's POI location (in degrees)
  # * +longitude+ - the longitude of it's POI location (in degrees)
  # 
  # === Optional Attributes
  # 
  # * +tags+ - every building is tagged "building" plus any extras specified in a comma separated list
  # * +code+ - a all caps building code (e.g. SHAN) that defaults to NONE.
  # * +altitude+ - defaults to 0
  def create
    if p = create_params
      if building = Building.create(p)
        # Finds a tag and adds it the new building, or if he tag is a new one, creates that tag first
        building.tags.concat(Tag.create_with(name: "building").find_or_create_by(name: "building"))
        
        # If there are extra tags to add, find/create them and add them
        if !params.permit(:tags)[:tags].blank?
          tags = params.permit(:tags)[:tags].split(", ")
          for t in tags
            building.tags.concat(Tag.create_with(name: t).find_or_create_by(name: t))
          end
        end

        @notice = "Created the new building."
        render :file => "#{Rails.root}/public/success", :layout => false
      else
        @notice = "Create failed."
        render :file => "#{Rails.root}/public/error", :layout => false
      end
    else
      @notice = "Invalid variables. Requires lat, long, name, description. Permits code, altitude, tags as well."
      render :file => "#{Rails.root}/public/error", :layout => false
    end
  end


  # A PATCH or PUT request to the given URL (in udpate_url attribute of POI), will 
  # attempt to modify the specified building and give a success or error response if it
  # works.
  # 
  # === Modifiable Attributes (Passed by Parameters)
  # 
  # * +name+ - the full name of the building (used for display of POI)
  # * +description+ - every building has a small, sometime historical, snippet of info
  # * +code+ - a all caps building code (e.g. SHAN)
  # * +latitude+ - the latitude of it's POI location (in degrees)
  # * +longitude+ - the longitude of it's POI location (in degrees)
  # * +altitude+ - the altitude of the POI in degrees
  # * +tags+ - a comma separated list of description tags, will replace all tags (other than "building" tag)
  # 
  def update
    if @building.update(update_params)
      if t = params.permit(:tags)[:tags]
        tag_names = t.split(", ")
        tags = [Tag.create_with(name: "building").find_or_create_by(name: "building")]
        for n in tag_names
          tags += [Tag.create_with(name: n).find_or_create_by(name: n)]
        end
        @building.tags = tags
      end
      @notice = "Updated successfully."
      render :file => "#{Rails.root}/public/success", :layout => false
    else
      @notice = "Update failed."
      render :file => "#{Rails.root}/public/error", :layout => false
    end
  end

  # A DELETE request sent to the same URL (update_url) will attempt to destroy the 
  # building. Responds with a success or error message if it works or not. In this
  # case the only way for it not to work is if the authentication fails, in which
  # case no message is returned.
  def destroy
    @building.destroy
    @notice = "Successfully destroyed."
    render :file => "#{Rails.root}/public/success", :layout => false
  end

  private
    # White list permitted search parameters
    def search_params
      params.permit(:latitude, :longitude, :range, :tags)
    end

    # White list permitted create parameters
    # returns false if one of the required params is not found
    def create_params
      p = params.permit(:latitude, :longitude, :altitude, :name, :code, :description)
      if p[:latitude].nil? or p[:longitude].nil? or p[:name].nil? or p[:description].nil?
        return false        
      else
        return p
      end
    end

    # White list permitted update parameters
    def update_params
      p = params.permit(:latitude, :longitude, :altitude, :name, :code, :description)
    end

    # find the building for editing and destroying
    def set_building
      @building = Building.where(id: params[:id]).first
    end
end
