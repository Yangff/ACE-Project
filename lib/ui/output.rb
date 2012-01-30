def print(args)
  OutputPanel.print(args)
end
def print(args)
  OutputPanel.p(args)
end
class OutputPanel < Panel
  def initialize(parent, options = {})
    super(parent, options.merge!(:size => [800, 320]))
    arrange_vertically do  
      add @@textctrl = TextCtrl.new(self, :style => Wx::TE_MULTILINE|TE_READONLY,:size => [-1, -1]), :proportion => 1
      
    end
  end
  def self.print(args)
    @@textctrl.append_text(args.to_s+"\r\n")
  end
  def self.p(args)
    @@textctrl.append_text(args.to_s+"\r\n")
  end
end