class Token < ActiveRecord::Base
  attr_accessible :name, :used

  def check_if_used
    self.pry
    #flash[:error] = 'SORRY ALREADY USED!'
    if self.used = false
      return false
    else
      return true
    end
    #
  end
end
