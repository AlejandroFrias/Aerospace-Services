# Notes can be viewed in list format, individually. They can be created, modified and destroyed.
# Basic HTTP Username/Password authentication is required for all requests, even GET.
class NotesController < ApplicationController
  # Since this a session independent API, we ignore checking for authenticity_tokens 
  # that shoul prevent CSRF attacks. We authenticate with user/password instead.
  skip_before_action :verify_authenticity_token
  before_action :set_note, only: [:update, :destroy]
  before_action :authenticate, except: :index #temporary fix to not require authentication on POI generation

  # GET /notes
  # GET /notes.json
  # Notes can be searched for by a combination of users and tags as well as a 
  # bounding box. The current user, based on the basic HTTP authentication, is
  # also used as a search parameter to find all of your own notes too.
  # This response gives a list of POI's of all the notes found.
  def index
    # @notes = Note.find_near_me(search_params, @user)
    @notes = Note.find_near_me(search_params, User.first)
  end

  # GET /notes/1
  # GET /notes/1.json
  # Gets all the info on the desired note (by id). The URL is given in the list of POI's.
  def show
    attrs = "title, body, latitude, longitude, altitude, privacy_on, updated_at, user_id, id"
    @note = Note.where(id: params[:id]).select(attrs).first
  end

  # POST /notes
  # POST /notes.json
  # A POST request to the create_url given in the POI List attempts to create a new note.
  # If the required attributes are not specified or the creation fails for any other 
  # reason, an error message is returned. If a new note is successfully created, a
  # success message is returned.
  # 
  # === Required Attributes (Passed by Parameters)
  # 
  # * title
  # * body
  # * latitude
  # * longitude
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

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  # A PATCH or PUT request to the given URL (in udpate_url attribute of POI), will 
  # attempt to modify the specified note and give a success or error response if it
  # works.
  # 
  # === Modifiable Attributes (Passed by Parameters)
  # 
  # * title
  # * body
  # * privacy_on
  # * latitude
  # * longitude
  # * altitude
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

  # DELETE /notes/1
  # DELETE /notes/1.json
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
