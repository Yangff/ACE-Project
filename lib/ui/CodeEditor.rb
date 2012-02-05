class CodeEditor < Panel
  def initialize(parent, options = {})
    super(parent, options.merge!(:size => [1000, 1000]))
    arrange_vertically do
      @textbox=CodeBlock.new(self)
    end
  end
  def scip
    return @textbox
  end
end
class ScriptGuide < Panel
  def initialize(parent, options = {})
    super(parent, options.merge!(:size => [200, -1]))
    arrange_vertically do 
      @lb=ListCtrl.new(self,:style=>LC_SINGLE_SEL|LC_REPORT|LC_EDIT_LABELS|LC_HRULES|LC_NO_HEADER)
      add @lb,:proportion => 1  
      evt_list_item_selected(@lb.id){|evt|
        $mainWindow.codeeditor.scip.changeto(@lb.get_selections()[0]+1)
      }
    end
  end
  def clear(scripts)
    @lb.clear_all()
    lit=ListItem.new
    lit.set_text("NO Head")
    lit.set_width(LIST_AUTOSIZE)
    @lb.insert_column(1,lit)
    for i in 1...scripts.size
      li = ListItem.new
      li.set_text(scripts[i].name)
      li.set_id(i-1)
      li.set_column(0)
      @lb.insert_item(li)
    end
    @lb.set_column_width(0,LIST_AUTOSIZE)
    
  end
end