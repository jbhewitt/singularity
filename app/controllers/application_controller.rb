class ApplicationController < ActionController::Base

  protect_from_forgery

  def redirect_with_delay(url, delay = 0)
    @redirect_url, @redirect_delay = url, delay
    render
  end

end
