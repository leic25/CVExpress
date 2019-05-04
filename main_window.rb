#!/usr/bin/env ruby
require 'fox16'
include Fox
require File.dirname(__FILE__) +'/cv1'
require File.dirname(__FILE__) +'/cv2'
require File.dirname(__FILE__) +'/cv3'
require File.dirname(__FILE__) +'/cv4'
require File.dirname(__FILE__) +'/cv5'
require File.dirname(__FILE__) +'/cv6'
require File.dirname(__FILE__) +'/cv7'
require File.dirname(__FILE__) + '/photo'
require File.dirname(__FILE__) + '/photo_view'
require File.dirname(__FILE__) + '/album'
require File.dirname(__FILE__) + '/album_view'


class MainWindow < FXMainWindow

  CVlist = {
      "CV1" => "cv1",
      "CV2" => "cv2",
      "CV3" => "cv3",
      "CV4" => "cv4",
      "CV5" => "cv5",
      "CV6" => "cv6",
      "CV7" => "cv7"
  }
  $mainFrame, @cVframe, @frame = nil



  def initialize()
    super($app, "CV Express", :opts => DECOR_ALL, :width => 570, :height => 600)
    $app.backColor = Fox.FXRGB(255, 255, 255)
    # Plava
    #$app.baseColor = Fox.FXRGB(176, 196, 225)
    # Lavanda
    $app.baseColor = Fox.FXRGB(238, 224, 229)

    $mainFrame = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
    @frame = FXVerticalFrame.new($mainFrame, :opts => LAYOUT_FILL)
    #celokupni okvir
    titleFrame = FXHorizontalFrame.new(@frame, LAYOUT_FILL_X)
    #okvir za "cv templates"
    title = FXLabel.new(titleFrame,"CV templates", :opts => LAYOUT_FILL_X)
    #cv templates labela, ubacena u titleFrame
    #album = FXLabel.new(@frame,"", :opts=>LAYOUT_FILL_Y)
    #postavljena labela kao "placeholder" koja ce kasnije postati album, sa slikama cv template-a
    image_frame = FXHorizontalFrame.new(@frame, LAYOUT_FILL_X|LAYOUT_FILL_Y)
    @album = Album.new("CV Templates")
    @album.add_photo(Photo.new("./slike/cv1.jpg"))
    @album.add_photo(Photo.new("./slike/cv2.jpg"))
    @album.add_photo(Photo.new("./slike/cv3.jpg"))
    @album.add_photo(Photo.new("./slike/cv4.jpg"))
    @album.add_photo(Photo.new("./slike/cv5.jpg"))
    @album.add_photo(Photo.new("./slike/cv6.jpg"))
    @album.add_photo(Photo.new("./slike/cv7.jpg"))
    @album_view = AlbumView.new(image_frame, @album)

    choseFrame = FXHorizontalFrame.new(@frame)
    #horizontalni frame za "chose template" labelu
    controls = FXHorizontalFrame.new(@frame, :opts => LAYOUT_FILL_X)
    #horizontalni frame za "next" button i odabir template-a
    exitFrame = FXHorizontalFrame.new(@frame, :opts => LAYOUT_FILL_X)
    #horizontalni frame za "exit" button

    FXLabel.new(choseFrame, "Chose template:")
    #labela "Chose template" ubacena u choseFrame
    @cvlist = FXComboBox.new(controls, 7,
                            :opts => COMBOBOX_STATIC|FRAME_SUNKEN|FRAME_THICK)
    #pravimo padajuci meni za listu cv template-a i ubacujemo ga u controls frame

    dekoracija = loadIcon("prvi.png")
    nextButton = FXButton.new(controls, "",
                              dekoracija,
                              :opts => BUTTON_NORMAL|LAYOUT_RIGHT,
                              :width => 55, :height => 55)
    #postavljamo nextButton i ubacujemo ga u controlFrame, smestamo ga krajnje desno

    nextButton.connect(SEL_COMMAND, method(:onClick))

    @cvlist.numVisible = 7
    CVlist.keys.each do |key|
      @cvlist.appendItem(key, CVlist[key])
    end
  end

  def onClick(sender, sel, ptr)
    if(@cvlist.to_s == 'CV1')
      CV1.new().create
      self.destroy()
    elsif (@cvlist.to_s == 'CV2')
      CV2.new().create
      self.destroy()
    elsif (@cvlist.to_s == 'CV3')
      CV3.new().create
      self.destroy
    elsif (@cvlist.to_s == 'CV4')
      CV4.new().create
      self.destroy()
    elsif (@cvlist.to_s == 'CV5')
      CV5.new().create
      self.destroy()
    elsif (@cvlist.to_s == 'CV6')
      CV6.new().create
      self.destroy
    elsif (@cvlist.to_s == 'CV7')
      CV7.new().create
      self.destroy
    end
  end

  # Ucitava sliku iz fajla
  def loadIcon(filename)
    filename = File.expand_path("../slike/#{filename}", __FILE__)
    File.open(filename, "rb") do |f|
      FXPNGIcon.new(getApp(), f.read)
    end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end
