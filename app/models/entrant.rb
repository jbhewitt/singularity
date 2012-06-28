class Entrant < ActiveRecord::Base

  belongs_to :person
  belongs_to :event

  validates_uniqueness_of :person_id, :scope => [:event_id]

  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :event_id, :name, :person_id , :response

  def print_badge
    if self.badge.nil? 
      self.create_badge
    end
    system ( "lp -d Brother_QL_570 -o media=62mm #{self.badge}" )
    self.printcount ||= 0
    self.printcount += 1     
    self.save
    #reset session
  end

 def create_badge
  require 'barby/barcode/code_128' 
  require 'barby/outputter/png_outputter'
  require 'rqrcode_png'

  badge_id = "#{self.person.meetup_id}"
  badge_eventname = self.event.name
  badge_fullname = self.person.name
  badge_gamername = self.person.gamername  
  if badge_gamername.nil?
    badge_gamername = badge_fullname
  end
  badge_url = self.person.meetup_url

  badge_pdf_filename ="#{Rails.root}/public/badges/#{self.person.meetup_id}-#{badge_id}.pdf"
  badge_qrcode_png = "#{Rails.root}/public/badges/qrcode_#{self.person.meetup_id}.png"
  badge_barcode_png = "#{Rails.root}/public/badges/code128b_#{self.person.meetup_id}.png"
  badge_avatar = "#{Rails.root}/public/badges/avatar_#{self.person.meetup_id}.png"

   badge_avatar = self.person.avatar.current_path
    if badge_avatar.nil?
      badge_avatar = "#{Rails.root}/vendor/badge/fuuuu.png"
    end
=begin
  if !FileTest.exist?(badge_avatar)
    require 'digest/md5'
    require 'open-uri'
    vanillicon =  "http://www.vanillicon.com/#{Digest::MD5.hexdigest(badge_fullname)}.png"
    open(badge_avatar, 'wb') do |file|
      file << open(vanillicon).read
    end
  end
=end  
  # barcode
  if !FileTest.exist?(badge_barcode_png)
    barcode = Barby::Code128B.new(self.person.meetup_id) 
    File.open(badge_barcode_png, 'w'){|f| 
      f.write barcode.to_png(:height => 20, :margin => 5) 
    } 
  end

  if !FileTest.exist?(badge_qrcode_png)
    kaywa_qrcode = "http://qrcode.kaywa.com/img.php?d=#{badge_url}&s=6"
    #qr = RQRCode::QRCode.new( badge_url, :size => 9, :level => :h )
    #png = qr.to_img  
    File.open(badge_qrcode_png, 'wb'){|f| 
      f << open(kaywa_qrcode).read
    } 
  end

  Prawn::Document.generate(badge_pdf_filename,
                            :margin => 10,
                           :page_size   => [62*(72 / 25.4),100*(72 / 25.4)]
  ) do
      font "#{Rails.root}/vendor/badge/hancpllp.ttf"
      text badge_eventname, :align => :center,  :size => 16
      
      image "#{Rails.root}/vendor/badge/ls-logo.png", :height => 40, :position=> :center
      
      font "#{Rails.root}/vendor/badge/FUTURAMC.TTF"
    
      #8 = 50
      #10 = 35
      #13 = 30
      #16 = 24
      #20 = 20

      if badge_gamername.length < 8
        gamername_textsize = 45
      elsif badge_gamername.length < 15
        gamername_textsize = 30
      else
        gamername_textsize = 20
      end


      text badge_gamername.upcase, :align => :center, :size => gamername_textsize
      text badge_fullname.upcase, :align => :center, :size => 20
      
      #image badge_avatar, :height => 65, :position=> :center
      image badge_qrcode_png, :height => 70, :position=> :center
      image badge_barcode_png, :position=> :center
      text badge_id, :align => :center, :size => 8

      #font "#{Rails.root}/vendor/badge/hancpllp.ttf"
            #text "-= SATURDAY =-", :align => :center, :size => 18
    end
    self.badge = badge_pdf_filename
    self.save  
  end



end
