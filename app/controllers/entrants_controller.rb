class EntrantsController < ApplicationController
  # GET /entrants
  # GET /entrants.json
  def index
    @entrants = Entrant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entrants }
    end
  end

  # GET /entrants/1
  # GET /entrants/1.json
  def show
    @entrant = Entrant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entrant }
    end
  end

  # GET /entrants/new
  # GET /entrants/new.json
  def new
    @entrant = Entrant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entrant }
    end
  end

  # GET /entrants/1/edit
  def edit
    @entrant = Entrant.find(params[:id])
  end

  # POST /entrants
  # POST /entrants.json
  def create
    @entrant = Entrant.new(params[:entrant])

    respond_to do |format|
      if @entrant.save
        format.html { redirect_to @entrant, notice: 'Entrant was successfully created.' }
        format.json { render json: @entrant, status: :created, location: @entrant }
      else
        format.html { render action: "new" }
        format.json { render json: @entrant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entrants/1
  # PUT /entrants/1.json
  def update
    @entrant = Entrant.find(params[:id])

    respond_to do |format|
      if @entrant.update_attributes(params[:entrant])
        format.html { redirect_to @entrant, notice: 'Entrant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entrant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entrants/1
  # DELETE /entrants/1.json
  def destroy
    @entrant = Entrant.find(params[:id])
    @entrant.destroy

    respond_to do |format|
      format.html { redirect_to entrants_url }
      format.json { head :no_content }
    end
  end
end
