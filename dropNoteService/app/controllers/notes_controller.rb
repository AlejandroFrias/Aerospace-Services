class NotesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.find_near_me(params[:latitude]  || 0,
                               params[:longitude] || 0, 
                               params[:range] || 200,
                               params[:user] || "public")
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    attrs = "title, tags, user, body"
    @note = Note.where(params[:id]).select(attrs).first
  end

  # POST /notes
  # POST /notes.json
  def create
    if check_for_user_password()
      if params[:title].nil? or params[:body].nil? or params[:latitude].nil? or params[:longitude].nil?
        @notice = "Invalid variables. Requires title, body, latitude, longitude. Permits user, password, altitude, tags as well."
        render :file => "#{Rails.root}/public/error", :layout => false
      else
        note = Note.new
        if note.update(create_note_params)
          @notice = "Created the new note."
          render :file => "#{Rails.root}/public/success", :layout => false
        else
          @notice = "Create failed."
          render :file => "#{Rails.root}/public/error", :layout => false
        end
      end
    else
      @notice = "Denied access. Incorrect user and password."
      render :file => "#{Rails.root}/public/error", :layout => false
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    if correct_user_and_password()
      if @note.update(update_note_params)
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
    if correct_user_and_password()
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
      params.permit(:tags, :title, :body, :latitude, :longitude, :altitude)
    end

    def create_note_params
      params.permit(:user, :password, :title, :body, :tags, :latitude, :longitude, :altitude)
    end

    def correct_user_and_password
      user = params.permit(:user)[:user] || "public"
      password = params.permit(:password)[:password] || "password"
      result = (user == @note.user && password == @note.password)
    end

    def check_for_user_password
      user = params.permit(:user)[:user] || "public"
      password = params.permit(:password)[:password] || "password"
      Note.valid_user_password(user, password)
    end
end
