class BathroomsController < ApplicationController
  before_action :set_bathroom, only: [:show, :edit, :update, :destroy]

  # GET /bathrooms
  # GET /bathrooms.json
  def index
    @bathrooms = Bathroom.find_near_me(params[:latitude]  || 0,
                                       params[:longitude] || 0, 
                                       params[:range] || 200)
  end

  # GET /bathrooms/1
  # GET /bathrooms/1.json
  def show
  end

  # GET /bathrooms/new
  def new
    @bathroom = Bathroom.new
  end

  # GET /bathrooms/1/edit
  def edit
  end

  # POST /bathrooms
  # POST /bathrooms.json
  def create
    @bathroom = Bathroom.new(bathroom_params)

    respond_to do |format|
      if @bathroom.save
        format.html { redirect_to @bathroom, notice: 'Bathroom was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bathroom }
      else
        format.html { render action: 'new' }
        format.json { render json: @bathroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bathrooms/1
  # PATCH/PUT /bathrooms/1.json
  def update
    respond_to do |format|
      if @bathroom.update(bathroom_params)
        format.html { redirect_to @bathroom, notice: 'Bathroom was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bathroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bathrooms/1
  # DELETE /bathrooms/1.json
  def destroy
    @bathroom.destroy
    respond_to do |format|
      format.html { redirect_to bathrooms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bathroom
      @bathroom = Bathroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bathroom_params
      params.require(:bathroom).permit(:latitude, :longitude, :altitude, :floor, :type, :building)
    end
end
