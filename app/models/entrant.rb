class Entrant < ActiveRecord::Base

  belongs_to :person
  belongs_to :event

  attr_accessible :event_id, :name, :person_id , :response
end
