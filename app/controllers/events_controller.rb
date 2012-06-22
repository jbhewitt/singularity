class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @entrants = Entrant.where(:event_id => @event.id, :response => TRUE)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end


def print_all_badges
  @event = Event.find(params[:id])

  @entrants = Entrant.where(:event_id => @event.id, :response => TRUE)

  respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
  end

  @entrants = Entrant.where(:event_id => @event.id, :response => TRUE)

  @entrants.each do |entrant| 
    entrant.delay.create_badge
    #entrant.create_badge
  end
end
  
  def rsvpimport
    @event = Event.find(params[:id])
        
    #@event.delay.meetup_rsvp_import
    @event.meetup_rsvp_import

    respond_to do |format|
      format.html
      format.html # rsvpimport.html.erb
    end
  end
end
