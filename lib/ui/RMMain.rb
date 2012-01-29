module Helpers
  module_function
  def createMenu(menu,lang,fLAG)
    for i in lang
      if (i[0]==:separator)
        menu.append_separator()
      else
        menu.append(fLAG.size, i[1],i[0].to_s)
        fLAG<<i[0]  
      end
    end    
  end
end
class RMMain < Frame

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
    pi.set_name('notebook_content').center_pane #.hide  {auto hide}
    @mgr.add_pane(@ctrl, pi)
    set_min_size( Wx::Size.new(400,300) )
    @mgr.update
  end
  def initializemenu
    menuBar = Wx::MenuBar.new()
    @FLAG=[]
    for i in 0...LANG[:MENU][:KEYS].size
      if LANG[:MENU][:KEYS][i].is_a?(Symbol) and LANG[:MENU][:VALUES][i].is_a?(Symbol) and LANG[:MENU][LANG[:MENU][:VALUES][i]].is_a?(Array)
        proc {$SAFE=2;eval("@menu#{LANG[:MENU][:KEYS][i].to_s} = Wx::Menu.new();Helpers.createMenu(@menu#{LANG[:MENU][:KEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:VALUES][i].to_s}],@FLAG);menuBar.append(@menu#{LANG[:MENU][:KEYS][i].to_s},LANG[:MENU][:#{LANG[:MENU][:KEYS][i].to_s}])")}.call()
      else
        print "Error on Loading Menu Language File\r\n"
      end
    end
    set_menu_bar( menuBar )
    
  end
  attr_reader :mgr,:codeeditor
end