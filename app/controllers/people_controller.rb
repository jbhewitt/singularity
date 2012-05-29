class PeopleController < ApplicationController
  # GET /people
  # GET /people.json

  before_filter :set_start_time
  def set_start_time
    @start_time = Time.now.usec
  end
  def index

    if params[:query].present?
      @people = Person.search(params[:query], load: true)
    else
      @people = Person.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

 
  def print_badge
    @person = Person.find(params[:id])
    @person.create_badge

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

end
