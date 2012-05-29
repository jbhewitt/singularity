class EntrantsController < ApplicationController
  # GET /entrants
  # GET /entrants.json
  def index
    if params[:query_event]
      @query_event = params[:query_event]
    end

    if params[:query].present?
      #params[:query].pry
      @entrants = Entrant.search("#{params[:query_event]} AND #{params[:query]}*", load: true, analyze_wildcard: true, auto_generate_phrase_queries: true)
      
      if @entrants.total == 1
        @entrant = @entrants.results[0]
        render :action => "show"
        return
        #@entrant.pry  
      end
    else
      @entrants = Entrant.all
    end

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

 def print_badge
    @entrant = Entrant.find(params[:id])

    #@entrant.delay.print_badge
    @entrant.print_badge

    respond_to do |format|
      format.html # show.html.erb
    end
  end

 
end
