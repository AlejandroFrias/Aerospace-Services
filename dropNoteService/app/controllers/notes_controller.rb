# Controller for Drop a Note Point of Interest (POI) Service
# 
# Basic HTTP Username/Password authentication is required for all 
# requests, even GET. New users welcome. Only you can modify/delete 
# your own notes and only you can view your private notes.
# 
# === Provided Services
# * Generate list of Note POI's
# => GET http://134.173.43.28:3003/notes
# => search params = tags, users, latitude, longitude, range
# * information of a particular note
# => GET GET http://134.173.43.28:3003/notes/[:id]
# * Create new Note with given params
# => POST http://134.173.43.28:3000/notes
# => required params = title, body, latitude, longitude
# => optional params = tags, privacy_on, altitude
# * Edit a Note
# => PATCH/PUT http://134.173.43.28:3000/buildings/[:id]
# => params = title, body, latitude, longitude, tags, privacy_on, altitude
# * Delete a Note
# => DESTROY http://134.173.43.28:3000/notes/[:id]
class NotesController < ApplicationController
  # Since this a session independent API, we ignore checking for authenticity_tokens 
  # that should prevent CSRF attacks. We authenticate with user/password instead.
  skip_before_action :verify_authenticity_token
  before_action :set_note, only: [:update, :destroy]
  before_action :authenticate
  
  # Returns a list of POI's of all the notes found matching the given parameters.
  # === Search Parameters
  # * +latitude+ - the latitude of the center point of the bounding box to search within
  # * +longitude+ - the longitude of the center point of the bounding box to search within
  # * +range+ - the radius of the bounding box to search within
  # * +users+ - the known users whose public notes you wish to see within the bounding box
  # * +tags+ - tags that you want the notes to have that you are searching for (only needs one matching tag to find)
  def index
    # @notes = Note.find_near_me(search_params, @user)
    @notes = Note.find_near_me(search_params, User.first) # temp fix
  end

  # GET all the info on the desired note (by id). The URL is given in the list of POI's.
  def show
    attrs = "title, body, latitude, longitude, altitude, privacy_on, updated_at, user_id, id"
    @note = Note.where(id: params[:id]).select(attrs).first
  end

  # A POST request to the create_url given in the POI List attempts to create a new note.
  # If the required attributes are not specified or the creation fails for any other 
  # reason, an error message is returned. If a new note is successfully created, a
  # success message is returned.
  # 
  # === Required Attributes for Creation (Passed by Parameters)
  # 
  # * +title+ - the title of the note
  # * +body+ - the text of the note
  # * +latitude+ - the latitude of the note's position
  # * +longitude+ - the longitude of the note's position
  # 
  # === Optional Attributes
  # 
  # * +tags+ - every note is tagged "note" plus any extras specified
  # * +privacy_on+ - a boolean for the privacy setting.
  # * +altitude+ - defaults to 0
  def create
    if p = create_note_params
      if note = Note.create(p)
        note.tags.concat(Tag.create_with(name: "note").find_or_create_by(name: "note"))
        if !params.permit(:tags)[:tags].blank?
          tags = params.permit(:tags)[:tags].split(", ")
          for t in tags
            note.tags.concat(Tag.create_with(name: t).find_or_create_by(name: t))
          end
        end
        @user.notes.concat(note)
        @notice = "Created the new note."
        render :file => "#{Rails.root}/public/success", :layout => false
      else
        @notice = "Create failed."
        render :file => "#{Rails.root}/public/error", :layout => false
      end
    else
      @notice = "Invalid variables. Requires title, body, latitude, longitude. Permits altitude, tags as well."
      render :file => "#{Rails.root}/public/error", :layout => false
    end
  end

  # A PATCH or PUT request to the given URL (in udpate_url attribute of POI), will 
  # attempt to modify the specified note and give a success or error response if it
  # works.
  # 
  # === Modifiable Attributes (Passed by Parameters)
  # 
  # * +title+ - the title of the note
  # * +body+ - the text of the note
  # * +privacy_on+ - a boolean for the privacy setting
  # * +latitude+ - the latitude of the note's position
  # * +longitude+ - the longitude of the note's position
  # * +altitude+ - the altitude of the note's position
  # * tags - a comma separated list of description tags, will replace all tags (other than "note" tag)
  def update
    if @user == @note.user
      if @note.update(update_note_params)
          if t = params.permit(:tags)[:tags]
            tag_names = t.split(", ")
            tags = [Tag.create_with(name: "note").find_or_create_by(name: "note")]
            for n in tag_names
              tags += [Tag.create_with(name: n).find_or_create_by(name: n)]
            end
            @note.tags = tags
          end
          @notice = "Updated successfully."
          render :file => "#{Rails.root}/public/success", :layout => false
      else
        @notice = "Denied access. Update failed."
        render :file => "#{Rails.root}/public/error", :layout => false
      end
    else
      @notice = "Denied access. Incorrect user and password."
      render :file => "#{Rails.root}/public/error", :layout => false
    end
  end

  # A DELETE request sent to the same URL (update_url) will attempt to destroy the 
  # note. Responds with a success or error message if it works or not.
  def destroy
    if @user == @note.user
      @note.destroy
      @notice = "Successfully destroyed."
      render :file => "#{Rails.root}/public/success", :layout => false
    else
      @notice = "Denied access. Incorrect user and password."
      render :file => "#{Rails.root}/public/error", :layout => false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # White list permitted parameters for updating a note with
    def update_note_params
      params.permit(:title, :body, :privacy_on, :latitude, :longitude, :altitude)
    end

    
    # White list permitted parameters for creating a note with
    # Returns false if required params are not present
    def create_note_params
      p = params.permit(:title, :body, :privacy_on, :latitude, :longitude, :altitude)
      if p[:title].nil? or p[:body].nil? or p[:latitude].nil? or p[:longitude].nil?
        return false
      else
        return p
      end
    end

    # White list permitted search parameters.
    def search_params
      params.permit(:latitude, :longitude, :range, :users, :tags)
    end

    # Authentication will create a new user if the user doesn't exist already
    def authenticate
      if user = authenticate_with_http_basic { |u, p| User.authenticate(u, p) }
        @user = user
      else
        request_http_basic_authentication
      end
    end
end
