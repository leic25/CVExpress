#!/usr/bin/env ruby
# GUI za treci CV
require 'fox16'
require 'tempfile'
require 'thread'
include Fox

class CV3 < FXMainWindow

  def initialize()
    super($app, "CV express", :opts => DECOR_ALL, :width => 570, :height => 600)
    self.connect(SEL_CLOSE, method(:onClose))

    @scroll = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )

    # Osnovni frame, u kome se sadrze svi drugi, roditeljski
    frame = FXVerticalFrame.new(@scroll, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)

    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    infoLabel = FXLabel.new(infoFrame, "Personal Info:", :opts => LAYOUT_FILL_X | LAYOUT_CENTER_X)
    infoLabel.textColor = Fox.FXRGB(41, 150, 23)
    infoLabel.font = FXFont.new(app, "Geneva", 12)
    infoMatrix = FXMatrix.new(infoFrame, 2, :opts=>MATRIX_BY_COLUMNS | LAYOUT_FILL)

    @picPath = ""

    FXLabel.new(infoMatrix, "First and Last name: ")
    @tfName = FXTextField.new(infoMatrix, 35)

    FXLabel.new(infoMatrix, "Address: ")
    @tfAdress = FXTextField.new(infoMatrix, 35)

    FXLabel.new(infoMatrix, "Country: ")
    @tfCountry = FXTextField.new(infoMatrix, 35)

    FXLabel.new(infoMatrix, "Phone: ")
    @tfPhone = FXTextField.new(infoMatrix, 35)

    FXLabel.new(infoMatrix, "Mail: ")
    @tfMail = FXTextField.new(infoMatrix, 35)

    @checkSite = FXCheckButton.new(infoMatrix, "Have a site?")
    FXLabel.new(infoMatrix, "")

    FXLabel.new(infoMatrix, "Site: ")
    @tfSite = FXTextField.new(infoMatrix, 35)

    @checkQuote = FXCheckButton.new(infoMatrix, "Have a quote?")
    FXLabel.new(infoMatrix, "")

    FXLabel.new(infoMatrix, "Quote: ")
    @tfQuote = FXTextField.new(infoMatrix, 35)


    FXHorizontalSeparator.new(infoFrame)


    eduFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    eduLabel = FXLabel.new(eduFrame, "Education: ", :opts => LAYOUT_FILL_X | LAYOUT_CENTER_X)
    eduLabel.textColor = Fox.FXRGB(41, 150, 23)
    eduLabel.font = FXFont.new(app, "Geneva", 12)
    @eduButton = FXButton.new(eduFrame, "Add fields", :opts=>LAYOUT_CENTER_X | BUTTON_NORMAL)
    @eduMatrix = FXMatrix.new(eduFrame, 2, :opts => MATRIX_BY_COLUMNS)
    @eduPeriod = []
    @eduDegree = []
    @eduSchool = []
    @eduCity = []
    @eduGrade = []
    @eduDesc = []

    FXHorizontalSeparator.new(eduFrame)

    @edu = false

    @eduButton.connect(SEL_COMMAND) do
      @edu = true
      makeLayoutEdu()
      @eduMatrix.create
      @eduMatrix.recalc
    end



    masterFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    masterLabel = FXLabel.new(masterFrame, "Master thesis: ", :opts => LAYOUT_FILL_X | LAYOUT_CENTER_X)
    masterLabel.textColor = Fox.FXRGB(41, 150, 23)
    masterLabel.font = FXFont.new(app, "Geneva", 12)
    @masterButton = FXButton.new(masterFrame, "Add master thesis", :opts=>LAYOUT_CENTER_X | BUTTON_NORMAL)
    @masterMatrix = FXMatrix.new(masterFrame, 2, :opts=>MATRIX_BY_COLUMNS | LAYOUT_FILL_Y)

    FXHorizontalSeparator.new(masterFrame)
    @masterThesis = false

    @masterButton.connect(SEL_COMMAND) do
      @masterThesis = true
      FXLabel.new(@masterMatrix,"Title")
      @masterTitle = FXTextField.new(@masterMatrix, 35)
      FXLabel.new(@masterMatrix,"Supervisors")
      @masterSuperVisor = FXTextField.new(@masterMatrix, 35)
      FXLabel.new(@masterMatrix,"Description")
      @masterDesc = FXText.new(FXHorizontalFrame.new(@masterMatrix, :opts =>LAYOUT_FILL | FRAME_THICK), :opts => LAYOUT_FILL)

      @masterMatrix.create
      @masterMatrix.recalc

      @masterButton.destroy
    end

    expFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    expLabel = FXLabel.new(expFrame, "Experience: ", :opts => LAYOUT_FILL_X | LAYOUT_CENTER_X)
    expLabel.textColor = Fox.FXRGB(41, 150, 23)
    expLabel.font = FXFont.new(app, "Geneva", 12)
    @expButton = FXButton.new(expFrame, "Add fields", :opts=>LAYOUT_CENTER_X | BUTTON_NORMAL)
    @expMatrix = FXMatrix.new(expFrame, 2, :opts => MATRIX_BY_COLUMNS)
    @expPeriod = []
    @expJobTitle = []
    @expEmpl = []
    @expCity = []
    @expDesc = []

    @exp = false

    @expButton.connect(SEL_COMMAND) do
      @exp = true
      makeLayoutExp()
      @expMatrix.create
      @expMatrix.recalc
    end

    langFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    langLabel = FXLabel.new(langFrame, "Languages: ", :opts => LAYOUT_FILL_X | LAYOUT_CENTER_X)
    langLabel.textColor = Fox.FXRGB(41, 150, 23)
    langLabel.font = FXFont.new(app, "Geneva", 12)
    @langButton = FXButton.new(langFrame, "Add language", :opts => LAYOUT_CENTER_X | BUTTON_NORMAL)
    @langMatrix = FXMatrix.new(langFrame, 2, :opts => MATRIX_BY_COLUMNS)
    FXHorizontalSeparator.new(langFrame)

    @langName = []
    @langSkill = []
    @langComment = []

    @langs = false

    @langButton.connect(SEL_COMMAND) do
      @langs = true
      makeLayoutLang()
      @langMatrix.create
      @langMatrix.recalc
    end

    hobbyFrame = FXVerticalFrame.new(frame, :opts=>LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    hobbyLabel = FXLabel.new(hobbyFrame, "Interests: ", :opts=> LAYOUT_FILL | LAYOUT_CENTER_X)
    hobbyLabel.textColor = Fox.FXRGB(41, 150, 23)
    hobbyLabel.font = FXFont.new(app, "Geneva", 12)
    @hobbyButton = FXButton.new(hobbyFrame, "Add interest", :opts=>LAYOUT_CENTER_X|BUTTON_NORMAL)
    @hobbyMatrix = FXMatrix.new(hobbyFrame, 2, :opts => MATRIX_BY_COLUMNS)

    @hobbyName = []
    @hobbyDesc = []

    @hobby = false

    @hobbyButton.connect(SEL_COMMAND) do
      @hobby = true
      FXLabel.new(@hobbyMatrix, "Name: ")
      FXLabel.new(@hobbyMatrix, "Description: ")
      @hobbyName.insert(-1, FXTextField.new(@hobbyMatrix, 20))
      @hobbyDesc.insert(-1, FXTextField.new(@hobbyMatrix, 30))

      FXHorizontalSeparator.new(@hobbyMatrix)
      FXHorizontalSeparator.new(@hobbyMatrix)

      @hobbyMatrix.create
      @hobbyMatrix.recalc
    end

    @choice = FXDataTarget.new(0)
    @radio = []
    groupbox = FXGroupBox.new(frame, "Color:", :opts => GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    @radio.insert(-1, FXRadioButton.new(groupbox, "blue",
                               :target => @choice, :selector => FXDataTarget::ID_OPTION))
    @radio.insert(-1, FXRadioButton.new(groupbox, "orange",
                               :target => @choice, :selector => FXDataTarget::ID_OPTION+1))
    @radio.insert(-1, FXRadioButton.new(groupbox, "green",
                               :target => @choice, :selector => FXDataTarget::ID_OPTION+2))
    @radio.insert(-1, FXRadioButton.new(groupbox, "red",
                                       :target => @choice, :selector => FXDataTarget::ID_OPTION+3))
    @radio.insert(-1, FXRadioButton.new(groupbox, "purple",
                                       :target => @choice, :selector => FXDataTarget::ID_OPTION+4))
    @radio.insert(-1, FXRadioButton.new(groupbox, "grey",
                                       :target => @choice, :selector => FXDataTarget::ID_OPTION+5))
    @radio.insert(-1, FXRadioButton.new(groupbox, "black",
                                       :target => @choice, :selector => FXDataTarget::ID_OPTION+6))


    buttonFrame = FXHorizontalFrame.new(frame, :opts => LAYOUT_FILL)

    dekor = loadIcon("bez1.png")
    @btnSubmit = FXButton.new(buttonFrame,
                              "",
                              dekor,
                              :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
                              :width => 55, :height => 55)
    @btnSubmit.font = FXFont.new(app, "Geneva", 9)
    @btnSubmit.textColor = Fox.FXRGB(250, 250, 250)
    @btnSubmit.connect(SEL_COMMAND, method(:onSubmit))

    dekoracija  = loadIcon("drugi.png")
    @picButton = FXButton.new(buttonFrame, "",
                              dekoracija,
                              :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
                              :width => 55, :height => 55)
    @picButton.connect(SEL_COMMAND) do
      dialog = FXFileDialog.new(self, "Choose picture")
      dialog.patternList = [
          "JPEG Files (*.jpg, *.jpeg)"
      ]
      dialog.selectMode = SELECTFILE_EXISTING
      if dialog.execute != 0
        openJpgFile(dialog.filename)
      end
    end
  end

  def makeLayoutEdu()
    FXLabel.new(@eduMatrix, "Period")
    @eduPeriod.insert(-1, FXTextField.new(@eduMatrix, 10))
    FXLabel.new(@eduMatrix, "Degree")
    @eduDegree.insert(-1, FXTextField.new(@eduMatrix, 15))
    FXLabel.new(@eduMatrix, "School name")
    @eduSchool.insert(-1, FXTextField.new(@eduMatrix, 30))
    FXLabel.new(@eduMatrix, "City")
    @eduCity.insert(-1, FXTextField.new(@eduMatrix, 10))
    FXLabel.new(@eduMatrix, "Avg grade")
    @eduGrade.insert(-1, FXTextField.new(@eduMatrix, 10))
    FXLabel.new(@eduMatrix, "Description")
    descFrame = FXVerticalFrame.new(@eduMatrix, :opts => LAYOUT_FILL | FRAME_THICK)
    @eduDesc.insert(-1, FXText.new(descFrame, :opts=>LAYOUT_FILL))
    FXHorizontalSeparator.new(@eduMatrix)
    FXHorizontalSeparator.new(@eduMatrix)
  end

  def makeLayoutExp()
      FXLabel.new(@expMatrix, "Period")
      @expPeriod.insert(-1, FXTextField.new(@expMatrix, 10))
      FXLabel.new(@expMatrix, "Job title")
      @expJobTitle.insert(-1, FXTextField.new(@expMatrix, 20))
      FXLabel.new(@expMatrix, "Employer")
      @expEmpl.insert(-1, FXTextField.new(@expMatrix, 40))
      FXLabel.new(@expMatrix, "City")
      @expCity.insert(-1, FXTextField.new(@expMatrix, 20))
      FXLabel.new(@expMatrix, "Description")
      @expDesc.insert(-1, FXText.new(FXHorizontalFrame.new(@expMatrix, :opts =>LAYOUT_FILL | FRAME_THICK), :opts => LAYOUT_FILL))

      FXHorizontalFrame.new(@expMatrix)
      FXHorizontalFrame.new(@expMatrix)
  end


  def makeLayoutLang()
    FXLabel.new(@langMatrix, "Language")
    @langName.insert(-1, FXTextField.new(@langMatrix, 20))
    FXLabel.new(@langMatrix, "Skill level")
    @langSkill.insert(-1, FXTextField.new(@langMatrix, 20))
    FXLabel.new(@langMatrix, "Comment")
    @langComment.insert(-1,FXTextField.new(@langMatrix, 20))

    FXHorizontalSeparator.new(@langMatrix)
    FXHorizontalSeparator.new(@langMatrix)

    FXLabel.new(@langMatrix, "")
    FXLabel.new(@langMatrix, "")
  end

  def onSubmit(sender, sel, event)

    system("cp ./CV3/cv3.tex '#{@tfName}.tex'")

    file_edit("#{@tfName}.tex", 'ImePrezime', @tfName.text)
    file_edit("#{@tfName}.tex", 'adresa', @tfAdress.text)
    file_edit("#{@tfName}.tex", 'drzava', @tfCountry.text)
    file_edit("#{@tfName}.tex", 'mobBr', @tfPhone.text)
    file_edit("#{@tfName}.tex", 'mejl', @tfMail.text)

    @sajtString = ""
    @quoteString = ""

    if(@checkSite.checked?)
      @sajtString = "\\homepage{#{@tfSite.text}}"
    end

    if(@checkQuote.checked?)
      @quoteString = "\\quote{#{@tfQuote.text}}"
    end

    file_edit("#{@tfName}.tex", 'sajt', @sajtString)
    file_edit("#{@tfName}.tex", 'quote123', @quoteString)

    @masterNiska = ""

    if(@masterThesis)
      @masterNiska = "\\section{Master thesis}\n"
      @masterNiska <<="\\cvitem{title}{\\emph{#{@masterTitle.text}}}\n"
      @masterNiska <<="\\cvitem{supervisors}{#{@masterSuperVisor.text}}\n"
      @masterNiska <<="\\cvitem{description}{#{@masterDesc.text}}\n"
    end

    file_edit("#{@tfName}.tex", 'masterTeza', @masterNiska)

    @experienceString = ""
    @languagesString = ""
    @hobbyString = ""
    @eduString = ""

    catchExp
    catchEdu
    catchLangs
    catchInterests

    file_edit("#{@tfName}.tex", 'obrazovanje', @eduString)
    file_edit("#{@tfName}.tex", 'radnoIskustvo', @experienceString)
    file_edit("#{@tfName}.tex", 'jeziciLangs', @languagesString)
    file_edit("#{@tfName}.tex", 'licnaInteresovanja', @hobbyString)

    file_edit("#{@tfName}.tex", 'bojaCV', @radio[@choice.value].text)

    if(@picPath.length == 0)
      @picPath = "./images/picture"
    end

    @picPath = @picPath.gsub(/\.jpg|\.jpeg/, '')

    file_edit("#{@tfName}.tex", 'slikaProf', @picPath)

    system("mv '#{@tfName}.tex' CV3")

    system("pdflatex './CV3/#{@tfName}.tex'")
    system("pdflatex './CV3/#{@tfName}.tex'")

    system("mv '#{@tfName}.pdf' ~/Desktop")
    system("rm './CV3/#{@tfName}'.* ")
    system("rm '#{@tfName}'.* ")

    # Iskacuci prozorcic sa porukom
    @mess = FXMessageBox.information(self, MBOX_OK, "Done", "Your CV is ready!\nIt's waiting for you on Desktop")
  end

  def file_edit(filename, regexp, replacement)
    @mutex = Mutex.new
    @mutex.synchronize do
      Tempfile.open(".#{File.basename(filename)}", File.dirname(filename)) do |tempfile|
        File.open(filename).each do |line|
          tempfile.puts line.gsub(regexp, replacement)
        end
        tempfile.close
        FileUtils.mv tempfile.path, filename
      end
    end
  end

  def openJpgFile(filename)
    @picPath = "#{filename}"
  end

  def catchEdu()
    if(@edu)
      @eduString = "\\section{Education}\n"
    end
    i = 0

    while(i < @eduPeriod.length)
      @eduString << "\\cventry{#{@eduPeriod[i].text}}{#{@eduDegree[i].text}}{#{@eduSchool[i].text}}{#{@eduCity[i].text}}{\\textit{#{@eduGrade[i].text}}}{#{@eduDesc[i].text}}\n"
      i+=1
    end
  end

  def catchExp()
    if(@exp)
      @experienceString = "\\section{Experience}\n"
    end
    i = 0

    while(i < @expPeriod.length)
      @experienceString << "\\cventry{#{@expPeriod[i].text}}{#{@expJobTitle[i].text}}{#{@expEmpl[i].text}}{#{@expCity[i].text}}{}{#{@expDesc[i].text}}\n"
      i+=1
    end
  end

  def catchLangs()
    if(@langs)
      @languagesString = "\\section{Languages}\n"
    end
    i = 0

    while(i < @langSkill.length)
      @languagesString << "\\cvitemwithcomment{#{@langName[i].text}}{#{@langSkill[i].text}}{#{@langComment[i].text}}\n"
      i+=1
    end
  end

  def catchInterests()
    if(@hobby)
      @hobbyString = "\\section{Interests}\n"
    end
    i = 0

    while(i < @hobbyName.length)
      @hobbyString << "\\cvitem{#{@hobbyName[i].text}}{#{@hobbyDesc[i].text}}\n"
      i+=1
    end

  end

  # Metod za gasenje aplikacije pomocu iksica
  def onClose(sender, sel, event)
    $app.exit(0)
  end

  # Ucitava sliku iz fajla
  def loadIcon(filename)
    filename = File.expand_path("../images/#{filename}", __FILE__)
    File.open(filename, "rb") do |f|
      FXPNGIcon.new(getApp(), f.read)
    end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

