class Token < ActiveRecord::Base
  attr_accessible :name, :used

  def check_if_used
#    self.pry
    #flash[:error] = 'SORRY ALREADY USED!'
    if self.used = false
      return false
    else
      return true
    end
    #
  end

  def print
    puts "PRINTING TOKEN #{self.name}"
    if self.pdf.nil?
      self.create_print
    end
    #system ( "lp -d Brother_QL_570 -o media=62mm #{self.pdf}" )
    self.printed = true
    self.save
    # return self
  end

  def create_print
    require 'barby/barcode/code_128' 
    require 'barby/outputter/png_outputter'
    require 'rqrcode_png'

    badge_id = self.name

    pdf_filename ="#{Rails.root}/public/tokens/#{badge_id}.pdf"
    badge_barcode_png = "#{Rails.root}/public/badges/code128b_#{badge_id}.png"

    # barcode
    if !FileTest.exist?(badge_barcode_png)
      barcode = Barby::Code128B.new(badge_id) 
      File.open(badge_barcode_png, 'w'){|f| 
        f.write barcode.to_png(:height => 20, :margin => 5) 
      } 
    end

    Prawn::Document.generate(pdf_filename,
                            :margin => 10,
                            :page_size   => [62*(72 / 25.4),20*(72 / 25.4)]
    ) do
        font "#{Rails.root}/vendor/badge/BEBAS.TTF"
#        text badge_id.to_s, :align => :left,  :size => 20
        #image badge_barcode_png, :position=> :right       
        
        table [ ["#{badge_id.to_s}", {:image => badge_barcode_png}] ] 
      end
      self.pdf = pdf_filename
      self.save  
  end



end
