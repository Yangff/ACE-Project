class CodeEditor < Panel
  def initialize(parent, options = {})
    super(parent, options.merge!(:size => [1000, 1000]))
    arrange_vertically do  
      
      @textbox=CodeBlock.new(self)
    end
  end
end
class ScriptGuide < Panel
  def initialize(parent, options = {})
    super(parent, options.merge!(:size => [200, -1]))
    arrange_vertically do 
      @lb=ListCtrl.new(self)
      add @lb,:proportion => 1  
    end
  end
end