class TokensController < ApplicationController
  def index
    if params[:token_login] 
      if @token = Token.find_by_name(params[:token_login])
        
        if @token.used
          flash[:notice] = 'ERROR ALREADY USED THIS ONE!?'
        else
          @token.used = true
          @token.save
          session['active_yeaaa'] = true
          #redirect_to @token
          redirect_to :controller=>'events', :action => 'show', :id => Settings.active_event

          return
        end
      end      
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @token = Token.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

end
