class NotesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_note, only: [:edit, :update, :destroy]
  before_action :authenticate

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.find_near_me(search_params)
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    attrs = "title, body, latitude, longitude, altitude, privacy_on, updated_at, user_id, id"
    puts "WHY Is ID #{params[:id]}?!?!?!!?"
    @note = Note.where(id: params[:id]).select(attrs).first
  end

  # POST /notes
  # POST /notes.json
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_note_params
      params.permit(:title, :body, :privacy_on, :latitude, :longitude, :altitude)
    end

    def create_note_params
      p = params.permit(:title, :body, :privacy_on, :latitude, :longitude, :altitude)
      if p[:title].nil? or p[:body].nil? or p[:latitude].nil? or p[:longitude].nil?
        return false
      else
        return p
      end
    end

    def search_params
      p = params.permit(:latitude, :longitude, :range, :users, :tags)

      p[:latitude] =  0 unless p[:latitude]
      p[:longitude] = 0 unless p[:longitude]
      p[:range] = 200 unless p[:range]
      p[:users] = "" unless p[:users]
      p[:tags] = "" unless p[:tags]
      p[:user] = @user

      p
    end

    def authenticate
      if user = authenticate_with_http_basic { |u, p| User.authenticate(u, p) }
        @user = user
      else
        request_http_basic_authentication
      end
    end
end
