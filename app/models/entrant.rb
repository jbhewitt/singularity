class Entrant < ActiveRecord::Base

  belongs_to :person
  belongs_to :event

  validates_uniqueness_of :person_id, :scope => [:event_id]


  attr_accessible :event_id, :name, :person_id , :response

  def print_badge
   # if self.badge.empty? 
      self.create_badge
   # end
    system ( "lp -d Brother_QL_570 -o media=62mm #{self.badge}" )
  end

 def create_badge
  require 'barby/barcode/code_128' 
  require 'barby/outputter/png_outputter'
  require 'rqrcode_png'
  badge_id = self.person.meetup_id

  badge_eventname = self.event.name
  badge_fullname = self.person.name
  badge_gamername = self.person.gamername  
  if badge_gamername.nil?
    badge_gamername = ' '
  end
  badge_url = self.person.meetup_url

  badge_pdf_filename ="#{Rails.root}/public/badges/#{badge_id}.pdf"
  badge_qrcode_png = "#{Rails.root}/public/badges/qrcode_#{badge_id}.png"
  badge_barcode_png = "#{Rails.root}/public/badges/code128b_#{badge_id}.png"
  badge_avatar = "#{Rails.root}/public/badges/avatar_#{badge_id}.png"

  

#    badge_photo = entrant.person.avatar.thumb.current_path
#    if badge_photo.nil?
#      badge_photo = "#{Rails.root}/vendor/badge/fuuuu.png"
#    end
  
  if !FileTest.exist?(badge_avatar)
    require 'digest/md5'
    require 'open-uri'
    vanillicon =  "http://www.vanillicon.com/#{Digest::MD5.hexdigest(badge_fullname)}.png"
    open(badge_avatar, 'wb') do |file|
      file << open(vanillicon).read
    end
  end
  
  # barcode
  if !FileTest.exist?(badge_barcode_png)
    barcode = Barby::Code128B.new(badge_id) 
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
      define_grid(:columns => 3, :rows => 4)

      grid([0,0], [0,2]).bounding_box do
        font "#{Rails.root}/vendor/badge/hancpllp.ttf"
        text badge_eventname, :align => :center,  :size => 16
        image "#{Rails.root}/vendor/badge/ls-logo.png", :height => 40, :position=> :center
        #move_down 10
      end


      grid([1,0], [1,2]).bounding_box do
        font "#{Rails.root}/vendor/badge/Roboto-Bold.ttf"
        text badge_gamername.upcase, :align => :center, :size => 20
        text badge_fullname.upcase, :align => :center, :size => 16
        #move_down 10
      end

       grid([2,0], [2,0]).bounding_box do
        image badge_avatar, :height => 58, :position=> :center
       end
     
      grid([2,1], [2,1]).bounding_box do
        image "#{Rails.root}/vendor/badge/test.png", :height => 58, :position=> :center
      end
            
       grid([2,2], [2,2]).bounding_box do
        font "#{Rails.root}/vendor/badge/Roboto-Bold.ttf"
        image badge_qrcode_png, :height => 58, :position=> :center
      #  text 'human', :align => :center
       end

       grid([3,0], [3,2]).bounding_box do
            image badge_barcode_png, :position=> :center
            text badge_id.to_s, :align => :center, :size => 8

            font "#{Rails.root}/vendor/badge/hancpllp.ttf"
            text "-= SATURDAY =-", :align => :center, :size => 18
       end
         grid([4,0], [4,2]).bounding_box do
       end
      end

  self.badge = badge_pdf_filename
  self.save
  
  end

end
