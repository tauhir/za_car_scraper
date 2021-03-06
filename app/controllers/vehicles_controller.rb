class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.all.page params[:page]
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully created.' }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully updated.' }
        format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to vehicles_url, notice: 'Vehicle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scrape_filters
    url = 'https://www.cars.co.za/searchVehicle.php?'
    response = VehiclesSpiderFilter.process(url)
    if response[:status] == :completed && response[:error].nil?
      flash.now[:notice] = "Successfully scraped url"
    else
      flash.now[:alert] = response[:error]
    end
    rescue StandardError => e
      flash.now[:alert] = "Error: #{e}"
  end

  def scrape
    Maker.all.each do |make|
      response = VehiclesSpider.process(make)
      if response[:status] == :completed && response[:error].nil?
        flash.now[:notice] = "Successfully scraped url"
      else
        flash.now[:alert] = response[:error]
      end
      rescue StandardError => e
        flash.now[:alert] = "Error: #{e}"
    end
    BodyType.all.each do |body|
      
      response = VehiclesSpider.process(body)
      if response[:status] == :completed && response[:error].nil?
        flash.now[:notice] = "Successfully scraped url"
      else
        flash.now[:alert] = response[:error]
      end
      rescue StandardError => e
        flash.now[:alert] = "Error: #{e}"
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_params
      params.require(:vehicle).permit(:title, :color, :transmission, :fuel_type, :make, :model, :url, :year, :price, :miles)
    end
end
