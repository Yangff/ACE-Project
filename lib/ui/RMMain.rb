module Helpers
  module_function
  def createMenu(menu,lang,fLAG,hash={})
    for i in lang
      if (i[0]==:separator)
        menu.append_separator()
      else
        menu.append(fLAG.size, i[1],i[0].to_s)
        hash[i[0]]=fLAG.size
        fLAG<<i[0]
      end
    end    
  end
end
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
      @fonames =StaticText.new(self,:label=>l[:FONAME],:pos=>Wx::Point.new(20,12),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      @titles =StaticText.new(self,:label=>l[:TINAME],:pos=>Wx::Point.new(182,12),:style=>TRANSPARENT_WINDOW|CLIP_CHILDREN )
      evt_paint {|evt|paint{|dc|dc.gradient_fill_linear(get_client_rect(),Colour.new(228,240,252),Colour.new(196,208,220),Wx::SOUTH)}}
    end
    def show_modal
      center(Wx::BOTH)
      super
    end
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
    
  end
  def initializemenu
    menuBar = Wx::MenuBar.new()
    @FLAG=[]
    @menuHash={}
    for i in 0...LANG[:MENU][:KEYS].size
      if LANG[:MENU][:KEYS][i].is_a?(Symbol) and LANG[:MENU][:VALUES][i].is_a?(Symbol) and LANG[:MENU][LANG[:MENU][:VALUES][i]].is_a?(Array)
        proc {$SAFE=2;eval("@menu#{LANG[:MENU][:KEYS][i].to_s} = Wx::Menu.new();Helpers.createMenu(@menu#{LANG[:MENU][:KEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:VALUES][i].to_s}],@FLAG,@menuHash);menuBar.append(@menu#{LANG[:MENU][:KEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:KEYS][i].to_s}])")}.call()
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
      #TODO :ASK FOR SAVE
      print "TODO :ASK FOR SAVE"
    end
    @newproj =NewProject.new(self)
    @newproj.show_modal
    @newproj.destroy
  end
  def title
    set_title(ProjectManager.title)
  end

  attr_reader :mgr,:codeeditor
end