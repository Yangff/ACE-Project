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
    menuFile = Wx::Menu.new()
    menuEdit = Wx::Menu.new()
    @FLAG=[]
    Helpers.createMenu(menuFile,LANG[:MENU][:FILEs],@FLAG)
    Helpers.createMenu(menuEdit,LANG[:MENU][:EDITs],@FLAG)
    menuBar = Wx::MenuBar.new()
    menuBar.append(menuFile,LANG[:MENU][:FILE])
    menuBar.append(menuEdit,LANG[:MENU][:EDIT])
    set_menu_bar( menuBar )
    @textbox=CodeBlock.new(self)
  end

end