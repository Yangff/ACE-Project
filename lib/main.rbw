$:.push(Dir.pwd)
#http://wxruby.rubyforge.org/wxrubydoc.html
#高亮：StyledTextCtrl
require 'Win32API'
$sci=Win32API.new('kernel32','LoadLibraryW','p','i').call("SciLexer.DLL")
require 'rubygems'
require "win32api"
require "wx"
require 'wx_sugar/all'
require 'erb'  
require 'yaml'  
include Wx
require "lang/zh-cn"
Dir["ui/*.rb"].each{|f|require("./"+f)} 
#require "ui/RMMain.rb"
#require "bin/*"
#require "plugins/*"
require "rpg/ace"
require "rpg/Table"
require 'uri'
require "rpg/DataManager"
require "rpg/ProjectManager"

ProjectManager.init
ProjectManager.programURL=Dir.pwd
$DEBUG=true
#Win32API.new('user32', 'MessageBox', %w(p p p i), 'i').call(0,Dir.pwd  , "ACE-Project", 0) 
def msgbox(code,title="ACE-Project",hwnd=0,unit=0)
  return Win32API.new('user32', 'MessageBox', %w(p p p i), 'i').call(hwnd,code, title, unit)  if $DEBUG
end 

class RMApp < App
   def on_init   
     $mainWindow = RMMain.new
     $mainWindow.show
   end

end
$mainApp=RMApp.new

#$plugins=Plugins.new($plugins)
#$plugins.start($mainApp,$mainWindow)
$mainApp.main_loop