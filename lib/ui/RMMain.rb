require 'zlib'
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
      yxo=205
      super(parent,-1,:title=>l[:TITLE],:size=>[479,178+yxo],:style=>Wx::CAPTION|Wx::SYSTEM_MENU|Wx::CLOSE_BOX|TRANSPARENT_WINDOW)
      @templatel = StaticText.new(self,:label=>l[:TEMPLATEN],:pos=>Wx::Point.new(13,12),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      @templatec = ListCtrl.new(self,:pos=>Point.new(13,28+13-8),:size=>Size.new(450,200-22),:style=>LC_ICON|LC_SINGLE_SEL)
      id=0
      img=ImageList.new(60,60)
      @templatec.set_image_list(img,IMAGE_LIST_NORMAL)
      @its=[]
      for i in TemplateManager.getall.keys
        p=TemplateManager.getall[i]
        li=ListItem.new()
        li.set_text(p[:name])
        b=Bitmap.new(Config.ProgramPath+"templates\\#{i}.png",BITMAP_TYPE_PNG)#from_image(imgs)
        img<<b
        li.set_image(id)
        @templatec.insert_item(li)
        @its<<i
      end
      
      @fonamesl =StaticText.new(self,:label=>l[:FONAME],:pos=>Wx::Point.new(13,12+yxo),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      @fonames  = TextCtrl.new(self,:value=>ProjectManager.getProjectAutoNewName,:pos=>Wx::Point.new(13,28+yxo),:size=>Size.new(154,23))
      @titlesl  =StaticText.new(self,:label=>l[:TINAME],:pos=>Wx::Point.new(181,12+yxo),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      @titles   = TextCtrl.new(self,:value=>ProjectManager.getProjectAutoTitle,:pos=>Wx::Point.new(181,28+yxo),:size=>Size.new(280,23))
      @projurll =StaticText.new(self,:label=>l[:PROJURL],:pos=>Wx::Point.new(13,60+yxo),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      @projurl  = TextCtrl.new(self,:value=>ProjectManager.getProjectAutoURL,:pos=>Wx::Point.new(13,77+yxo),:size=>Size.new(417,23))
      @projurlb = Button.new(self,:label=>"...",:pos=>Wx::Point.new(434,77+yxo),:size=>Size.new(28,23))
      @yes = Button.new(self,:label=>l[:YES],:pos=>Wx::Point.new(280,117+yxo),:size=>Size.new(88,23));@yes.set_default()
      @no = Button.new(self,:label=>l[:NO],:pos=>Wx::Point.new(375,117+yxo),:size=>Size.new(88,23))
      evt_paint {|evt|paint{|dc|dc.gradient_fill_linear(get_client_rect(),Colour.new(228,240,252),Colour.new(196,208,220),Wx::SOUTH)}}
      @oldfod=ProjectManager.getProjectAutoNewName
      evt_button(@no.id){self.close}
      evt_button(@yes.id){
        if @templatec.get_selections().size<=0
        errorMsg(l[:NOSELECTION]) 
        else
        ProjectManager.create(@fonames.get_value,@projurl.get_value,@titles.get_value,@its[@templatec.get_selections[0]]) {|t,p| $mainWindow.onOpening(t,p)}
        end
        ;self.close
        }
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
    #SHOW Windows
    #ENABLE MENU
    @mgr.get_pane(@ctrl).show
    scripts=[nil]
    for i in $scripts
      scripts<<CodePage.new(i[1],Zlib::Inflate.inflate(i[2]),[])
      #print Zlib::Inflate.inflate(i[2])
    end
    @codeeditor.scip.clear(scripts)
    @scriptguide.clear(scripts)
    onChangedPage
    @mgr.update
  end
  def close
    #HIDE Windows
    #DISABLE MENU
  end
  def initialize(open="")
    super(nil,:title=>ProjectManager.title,:size=>[1115,700])
    
    #@textbox=CodeBlock.new(self)
    @mgr = AuiManager.new()
    @mgr.set_managed_window(self)
    client_size = get_client_size
    @ctrl = Wx::AuiNotebook.new( self, Wx::ID_ANY,
                                Wx::Point.new(client_size.x, client_size.y),
                                Wx::Size.new(500, 500),
                                AUI_NB_TAB_SPLIT|AUI_NB_TAB_MOVE|AUI_NB_SCROLL_BUTTONS|
      Wx::AUI_NB_TAB_EXTERNAL_MOVE|Wx::NO_BORDER)
    @ctrl.use_glossy_art()  
    #pi = AuiPaneInfo.new  
    #pi.set_name('codeeidtor').set_caption(LANG[:CODEBLOCK][:TITLE])
    #pi.top.set_maximize_button#.set_close_button(false)
    #@mgr.add_pane(@codeeditor = CodeEditor.new(self), pi)
    page_bmp = Wx::ArtProvider::get_bitmap( Wx::ART_NORMAL_FILE, 
                                            Wx::ART_OTHER, 
                                            Wx::Size.new(16,16) )    
    @ctrl.add_page(@codeeditor=CodeEditor.new(self),LANG[:CODEBLOCK][:TITLE],false,page_bmp)
    @ctrl.add_page(@xxx=Panel.new(self),"Some fuck",false,page_bmp)
    @ctrlindex=0
    #puts @ctrl.methods
    evt_auinotebook_page_changed(@ctrl.id){|evt|
      @ctrlindex = evt.index
      $mainWindow.onChangedPage
    }
    
    pi = Wx::AuiPaneInfo.new
    pi.set_name('scriptGuide').set_caption(LANG[:CODEBLOCK][:GUIDE]).left.set_close_button(false).hide# {auto hide}
    @mgr.add_pane(@scriptguide=ScriptGuide.new(self),pi)

    pi = Wx::AuiPaneInfo.new
    pi.set_name('outputWindow').set_caption(LANG[:OUTPUT]).bottom#.hide# {auto hide}
    pi.set_pin_button(true).set_minimize_button(true)
    #print pi.methods
    @mgr.add_pane(OutputPanel.new(self),pi)
    
    pi = Wx::AuiPaneInfo.new
    pi.set_name('notebook_content').center_pane.hide # {auto hide}
    @mgr.add_pane(@ctrl, pi)
    
    set_min_size( Wx::Size.new(400,300) )
    t=@TemplateOpener = FileDialog.new(self,LANG[:TEMPLATEOPENER][:MESSAGE])
    t.set_wildcard(LANG[:TEMPLATEOPENER][:WILDCARD])
    t.set_directory(Dir.pwd)   
    
    initializemenu
    
    @mgr.update
    print "Welcome to use AEC-Project!"
    print "Debugger :http://bbs.66rpg.com/forum.php?mod=viewthread&tid=186955"
    #@mgr.evt_paint {|evt|paint{|dc| dc.gradient_fill_linear(get_client_rect(),Colour.new(228,240,252),Colour.new(196,208,220),Wx::SOUTH)};evt.skip(true)}
    reset("(none)")

  end
  def onChangedPage
    if @ctrl.get_page(@ctrlindex)==@codeeditor
        @mgr.get_pane('scriptGuide').show
      else
        @mgr.get_pane('scriptGuide').hide
      end
      @mgr.update
  end
  def initializemenu
    @FLAG=[]
    @menuHash={}    
    #MainMenuBar
    menuBar = @mainmenuBar = Wx::MenuBar.new()

    for i in 0...LANG[:MENU][:KEYS].size
      if LANG[:MENU][:KEYS][i].is_a?(Symbol) and LANG[:MENU][:VALUES][i].is_a?(Symbol) and LANG[:MENU][LANG[:MENU][:VALUES][i]].is_a?(Array)
        proc {$SAFE=2;eval("@menu#{LANG[:MENU][:KEYS][i].to_s} = Wx::Menu.new();H.createMenu(@menu#{LANG[:MENU][:KEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:VALUES][i].to_s}],@FLAG,@menuHash);menuBar.append(@menu#{LANG[:MENU][:KEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:KEYS][i].to_s}])")}.call()
      else
        puts "Error on Loading Menu Language File #{LANG[:MENU][:KEYS][i]}\r\n"
      end
    end
   #set_menu_bar( menuBar )

    for i in 0...LANG[:MENU][:MAPKEYS].size
      if LANG[:MENU][:MAPKEYS][i].is_a?(Symbol) and LANG[:MENU][:MAPVALUES][i].is_a?(Symbol) and LANG[:MENU][LANG[:MENU][:MAPVALUES][i]].is_a?(Array)
        proc {$SAFE=2;eval("@menu#{LANG[:MENU][:MAPKEYS][i].to_s} = Wx::Menu.new();H.createMenu(@menu#{LANG[:MENU][:MAPKEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:MAPVALUES][i].to_s}],@FLAG,@menuHash);menuBar.append(@menu#{LANG[:MENU][:MAPKEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:MAPKEYS][i].to_s}])")}.call()
      else
        puts "Error on Loading Menu Language File #{LANG[:MENU][:MAPKEYS][i]}\r\n"
      end
    end
    for i in 0...LANG[:MENU][:TKEYS].size
      if LANG[:MENU][:TKEYS][i].is_a?(Symbol) and LANG[:MENU][:TVALUES][i].is_a?(Symbol) and LANG[:MENU][LANG[:MENU][:TVALUES][i]].is_a?(Array)
        proc {$SAFE=2;eval("@menu#{LANG[:MENU][:TKEYS][i].to_s} = Wx::Menu.new();H.createMenu(@menu#{LANG[:MENU][:TKEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:TVALUES][i].to_s}],@FLAG,@menuHash);menuBar.append(@menu#{LANG[:MENU][:TKEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:TKEYS][i].to_s}])")}.call()
      else
        puts "Error on Loading Menu Language File #{LANG[:MENU][:TKEYS][i]}\r\n"
      end
    end
   set_menu_bar( menuBar )
    evt_menu @menuHash[:NEW],:onMenuNew
#    puts @menuHash[:ADDTEMPLATE]
    evt_menu @menuHash[:ADDTEMPLATE],:onMenuAddTemplate
    evt_menu @menuHash[:ABOUT],proc{|evt|box=AboutDialogInfo.new; box.set_copyright("Copyright (C) 2012-2013 Yangff@66RPG");box.set_name("ACE - Project");box.set_version("0.0.1");box.set_developers(["Yangff","WANTED YOU!"]);box.set_license($APACHEV2);box.set_web_site("http://bbs.66rpg.com","66RPG");about_box(box)}
    
    
    evt_menu @menuHash[:OPEN],:onMenuOpen
  end
  def onMenuOpen
    if TemplateManager.getall.keys.size<=0
      #TODO :ASK TO INSTALL Template
      return false
    end
    if ProjectManager.saved==false
      #TODO :ASK FOR SAVE#
      print "TODO :ASK FOR SAVE"
    end
    
  end
  def onOpening(t,p)
    print "#{t} #{p}"
  end
  def onMenuNew(e)
    if TemplateManager.getall.keys.size<=0
      #TODO :ASK TO INSTALL Template
      return false
    end
    if ProjectManager.saved==false
      #TODO :ASK FOR SAVE#
      print "TODO :ASK FOR SAVE"
    end
    
    newproj =NewProject.new(self)
    newproj.show_modal
    newproj.destroy
  end
  def onMenuAddTemplate(e)
    t=@TemplateOpener
    if t.show_modal==ID_OK
      TemplateManager.add(t.get_path())
    end
    
  end
  attr_reader :mgr,:codeeditor ,:scriptguide
end