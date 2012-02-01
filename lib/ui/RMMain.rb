
class Wx::StaticText
  alias _old_initialize_ initialize
  def initialize(*args)
    _old_initialize_(*args)
    set_background_style BG_STYLE_CUSTOM
    set_font LANG[:NORMALFONT]
    evt_paint {|evt|paint{|dc|  dc.set_background(TRANSPARENT_BRUSH)
      dc.set_font(self.get_font()) 
      dc.draw_text(get_label(),0,0)
      }}
  end
end
class RMMain < Frame
  class NewProject < Dialog
    def initialize(parent)
      l=LANG[:NEWProject]
      super(parent,-1,:title=>l[:TITLE],:size=>[479,178],:style=>Wx::CAPTION|Wx::SYSTEM_MENU|Wx::CLOSE_BOX|TRANSPARENT_WINDOW)
      @fonamesl =StaticText.new(self,:label=>l[:FONAME],:pos=>Wx::Point.new(13,12),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      @fonames  = TextCtrl.new(self,:value=>ProjectManager.getProjectAutoNewName,:pos=>Wx::Point.new(13,28),:size=>Size.new(154,23))
      @titlesl  =StaticText.new(self,:label=>l[:TINAME],:pos=>Wx::Point.new(181,12),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      @titles   = TextCtrl.new(self,:value=>ProjectManager.getProjectAutoTitle,:pos=>Wx::Point.new(181,28),:size=>Size.new(280,23))
      @projurll =StaticText.new(self,:label=>l[:PROJURL],:pos=>Wx::Point.new(13,60),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      @projurl  = TextCtrl.new(self,:value=>ProjectManager.getProjectAutoURL,:pos=>Wx::Point.new(13,77),:size=>Size.new(417,23))
      @projurlb = Button.new(self,:label=>"...",:pos=>Wx::Point.new(434,77),:size=>Size.new(28,23))
      @yes = Button.new(self,:label=>l[:YES],:pos=>Wx::Point.new(280,117),:size=>Size.new(88,23));@yes.set_default()
      @no = Button.new(self,:label=>l[:NO],:pos=>Wx::Point.new(375,117),:size=>Size.new(88,23))
      evt_paint {|evt|paint{|dc|dc.gradient_fill_linear(get_client_rect(),Colour.new(228,240,252),Colour.new(196,208,220),Wx::SOUTH)}}
      @oldfod=ProjectManager.getProjectAutoNewName
      evt_button(@no.id){self.close}
      evt_button(@yes.id){ProjectManager.create(@fonames.get_value,@projurl.get_value,@titles.get_value) {|t,p| $mainWindow.onOpening(t,p)};self.close}
      evt_text(@fonames.id){|evt| 
        url=@fonames.get_value()
        url.gsub!(/\//){""};url.gsub!(/\\/){""};url.gsub!(/\./){""};url.gsub!(/\\/){""};url.gsub!(/:/){""};url.gsub!(/\*/){""};url.gsub!(/\?/){""};url.gsub!(/"/){""};url.gsub!(/''/){""}
        #puts url
        @fonames.change_value(url)
        @titles.set_value(url)
        url=@projurl.get_value().split(/\\/);

        oldfod="";index=0
        for i in 0...url.size
        
          j=url.size-i-1
          if url[j].to_s!=""
             oldfod=url[j];index=j
            break
          end
        end
        if oldfod==@oldfod
          url[index]=@fonames.get_value()
        else
          url[index+1]=@fonames.get_value()
        end
        @oldfod=@fonames.get_value()
        @projurl.set_value(pathary2path(url))
        }
    end
    def show_modal
      center(Wx::BOTH)
      super
    end
  end
  def reset(proj)
    set_title ProjectManager.title + " [#{proj}] - " + LANG[:TITLE]
  end
  def changeto
    #TODO :Change to project
  end
  def initialize(open="")
    super(nil,:title=>ProjectManager.title,:size=>[800,600])
    initializemenu
    #@textbox=CodeBlock.new(self)
    @mgr = AuiManager.new()
    @mgr.set_managed_window(self)
    client_size = get_client_size
    @ctrl = Wx::AuiNotebook.new( self, Wx::ID_ANY,
                                Wx::Point.new(client_size.x, client_size.y),
                                Wx::Size.new(500, 500),
                                Wx::AUI_NB_DEFAULT_STYLE|
      Wx::AUI_NB_TAB_EXTERNAL_MOVE|Wx::NO_BORDER)
    #pi = AuiPaneInfo.new  
    #pi.set_name('codeeidtor').set_caption(LANG[:CODEBLOCK][:TITLE])
    #pi.top.set_maximize_button#.set_close_button(false)
    #@mgr.add_pane(@codeeditor = CodeEditor.new(self), pi)
    page_bmp = Wx::ArtProvider::get_bitmap( Wx::ART_NORMAL_FILE, 
                                            Wx::ART_OTHER, 
                                            Wx::Size.new(16,16) )    
    @ctrl.add_page(@codeeditor=CodeEditor.new(self),LANG[:CODEBLOCK][:TITLE],false,page_bmp)
    pi = Wx::AuiPaneInfo.new
    pi.set_name('scriptGuide').set_caption(LANG[:CODEBLOCK][:GUIDE]).left.hide# {auto hide}
    @mgr.add_pane(ScriptGuide.new(self),pi)

    pi = Wx::AuiPaneInfo.new
    pi.set_name('outputWindow').set_caption(LANG[:OUTPUT]).bottom#.hide# {auto hide}
    pi.set_pin_button(true).set_minimize_button(true)
    #print pi.methods
    @mgr.add_pane(OutputPanel.new(self),pi)
    
    pi = Wx::AuiPaneInfo.new
    pi.set_name('notebook_content').center_pane.hide # {auto hide}
    @mgr.add_pane(@ctrl, pi)
    
    set_min_size( Wx::Size.new(400,300) )
    
    @mgr.update
    print "Welcome to use AEC-Project!"
    print "Debugger :http://bbs.66rpg.com/forum.php?mod=viewthread&tid=186955"
    #@mgr.evt_paint {|evt|paint{|dc| dc.gradient_fill_linear(get_client_rect(),Colour.new(228,240,252),Colour.new(196,208,220),Wx::SOUTH)};evt.skip(true)}
    reset("(none)")

  end
  def onOpening(t,p)
    print "#{t} #{p}"
  end
  def initializemenu
    menuBar = Wx::MenuBar.new()
    @FLAG=[]
    @menuHash={}
    for i in 0...LANG[:MENU][:KEYS].size
      if LANG[:MENU][:KEYS][i].is_a?(Symbol) and LANG[:MENU][:VALUES][i].is_a?(Symbol) and LANG[:MENU][LANG[:MENU][:VALUES][i]].is_a?(Array)
        proc {$SAFE=2;eval("@menu#{LANG[:MENU][:KEYS][i].to_s} = Wx::Menu.new();H.createMenu(@menu#{LANG[:MENU][:KEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:VALUES][i].to_s}],@FLAG,@menuHash);menuBar.append(@menu#{LANG[:MENU][:KEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:KEYS][i].to_s}])")}.call()
      else
        puts "Error on Loading Menu Language File #{LANG[:MENU][:KEYS][i]}\r\n"
      end
    end
    set_menu_bar( menuBar )
    evt_menu @menuHash[:NEW],:onMenuNew
    evt_menu @menuHash[:ABOUT],proc{|evt|box=AboutDialogInfo.new; box.set_copyright("Copyright (C) 2012-2013 Yangff@66RPG");box.set_name("ACE - Project");box.set_version("0.0.1");box.set_developers(["Yangff","WANTED YOU!"]);box.set_license($APACHEV2);box.set_web_site("http://bbs.66rpg.com","66RPG");about_box(box)}
    #evt_menu @menuHash[:OPEN],:onMenuOpen
  end
  def onMenuNew
    if ProjectManager.saved==false
      #TODO :ASK FOR SAVE#
      print "TODO :ASK FOR SAVE"
    end
    @newproj =NewProject.new(self)
    @newproj.show_modal
    @newproj.destroy
  end


  attr_reader :mgr,:codeeditor
end