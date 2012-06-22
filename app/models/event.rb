class Event < ActiveRecord::Base
  attr_accessible :meetup_id, :name

  has_many :entrants
  has_many :people, :through => :entrants

  def tournament_find
    Challonge::API.username = Settings.challonge_username
    Challonge::API.key = Settings.challonge_password
    test = Challonge::Tournament.find(:all, :params => {:state => 'in_progress'})
    test.pry
  end

  def meetup_rsvp_import
    ##<RMeetup::Type::Rsvp:0x007fe98a0d09a0 @rsvp={"zip"=>"meetup3", "lon"=>"153.02000427246094", "photo_url"=>"", "link"=>"http://www.meetup.com/members/48721402", "state"=>"", "answers"=>["Yes", "Waistless"], "guests"=>"0", "event_id"=>28049331, "member_id"=>48721402, "city"=>"Brisbane", "country"=>"au", "response"=>"yes", "coord"=>"-27.459999084472656", "id"=>"48721402", "updated"=>"Tue May 22 10:43:43 EDT 2012", "created"=>"Tue May 22 10:43:43 EDT 2012", "name"=>"Waistless", "comment"=>""}>
    RMeetup::Client.api_key = Settings.meetup_api
    #Settings.meetup_api.pry
    results = RMeetup::Client.fetch(:rsvps,{:event_id => self.meetup_id })
    results.each do |result|
      rsvp = result.rsvp
      #rsvp.pry
      person = Person.find_or_create_by_meetup_id(rsvp['member_id'])
      person.name = rsvp['name']
      person.city = rsvp['city']
      person.state = rsvp['state']
      person.meetup_url = rsvp['link']
      person.remote_avatar_url = rsvp['photo_url']

      gamername = rsvp['answers'][1]
      if gamername == false
        person.gamername = gamername
      end
      
      person.save

      #entrant
      entrant = Entrant.find_or_create_by_event_id_and_person_id(self.id,person.id)
      if rsvp['response'].upcase == "YES" 
        entrant.response = 1
      else 
        entrant.response = 0
      end
      entrant.name = "#{person.gamername} | #{person.name} | #{self.meetup_id}"
      entrant.save
    end


  end
end
