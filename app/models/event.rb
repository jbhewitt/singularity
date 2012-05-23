class Event < ActiveRecord::Base
  attr_accessible :meetup_id, :name

  has_many :entrants
  has_many :people, :through => :entrants
end
