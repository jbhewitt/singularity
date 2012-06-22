namespace :meetup do
  desc "TODO"

  task :profile_import => :environment  do
    puts '-= importing all user profiles! =-'
    RMeetup::Client.api_key = Settings.meetup_api
    RMeetup::Client.api_key = 'b2c5048751f552f793b20352b261743'

    
    results = RMeetup::Client.fetch(:members,{:group_urlname => 'LanSmash' })
    #results.pry
    results.each do |result|
 #     result.pry
      member = result.member
      person = Person.find_or_create_by_meetup_id(member['member_id'])
      person.name = member['name']
      person.city = member['city']
      person.meetup_url = member['link']
      person.remote_avatar_url = member['photo_url']

#      gamername = member['answers'][1]
#      if gamername == false
#        person.gamername = gamername
#      end
      person.save

      puts "imported #{person.name}"
    end
  end
  task :rsvp_import => :environment do |t, args|
    args.with_defaults(:event_id => "28049331")       
    event = Event.find_by_meetup_id(args.event_id)
    #event.pry

    puts "importing rsvps for #{event.name}!"
       ##<RMeetup::Type::Rsvp:0x007fe98a0d09a0 @rsvp={"zip"=>"meetup3", "lon"=>"153.02000427246094", "photo_url"=>"", "link"=>"http://www.meetup.com/members/48721402", "state"=>"", "answers"=>["Yes", "Waistless"], "guests"=>"0", "event_id"=>28049331, "member_id"=>48721402, "city"=>"Brisbane", "country"=>"au", "response"=>"yes", "coord"=>"-27.459999084472656", "id"=>"48721402", "updated"=>"Tue May 22 10:43:43 EDT 2012", "created"=>"Tue May 22 10:43:43 EDT 2012", "name"=>"Waistless", "comment"=>""}>
    RMeetup::Client.api_key = Settings.meetup_api
    results = RMeetup::Client.fetch(:rsvps,{:event_id => event.meetup_id })
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

      puts "importing #{person.name}"

      #entrant
      entrant = Entrant.find_or_create_by_event_id_and_person_id(event.id,person.id)
      if rsvp['response'].upcase == "YES" 
        entrant.response = 1
      else 
        entrant.response = 0
      end
      entrant.name = "#{person.gamername} | #{person.name} | #{event.meetup_id}"
      entrant.save
    end
  end

  task :gen_tokens => :environment do |t, args|
    args.with_defaults(:amount => 10)       

    for i in 0..args.amount  
      token = Token.new
      while token.id.nil?
        new_token_name = SecureRandom.hex(2).upcase
        #new_token_name = '6A1F'
        already_exists = Token.find_by_name(new_token_name)
        #already_exists.pry
        if already_exists.nil? 
            token.name = new_token_name
          token.save
          puts "token #{i} - #{token.name}"
        else        
                puts 'collision detected!'
        end
      end
    end
  end

  task :print_tokens => :environment do |t, args|
    args.with_defaults(:amount => 10)  
    
    CSV.open('tokens.csv', 'wb') do |csv|
      tokens = Token.where(:printed => nil)
      for i in 1..args.amount  
        token = tokens[i]
        token.print
        csv << ["#{token.name}"]
      end
    end
  end

end
