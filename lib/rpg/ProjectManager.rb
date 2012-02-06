require "fileutils" 
module ProjectManager
  ERRORS = {
    :DIRECTIONEXITS => 1
  }
  @@projfile=""
  def self.projectURL=(url)
    @@projectURL=url
  end
  def self.projectURL
    return @@projectURL
  end
  def self.saved
    return @@saved
  end
  
  def self.save(&progress)
    progress.call(LANG[:SAVINGProject],0)
    DataManager.save_normal_database()
    progress.call(LANG[:SAVINGProject],98)
    @@saved=true
    progress.call(LANG[:SAVINGProject],100)
  end
  def self.title
    return @@title
  end
  def self.init
    @@title="(none)"#LANG[:TITLE]
    @@saved=true
    @@projectName=nil
    @@projectPath=""
  end
  def self.create(name,url,title,template,&progress)
    progress.call(LANG[:CREATEINGProject],0)
    begin
      
      proc {progress.call(LANG[:DIRECTIONEXITS],0);return ERRORS[:DIRECTIONEXITS]}.call if FileTest.directory?(url)
      Dir::mkdir(url)
      progress.call(LANG[:CREATEINGProject],20)
      proj = url+name+".rvproject2x"#URI.join(url,name,name+".rvproject2x")
      ini=url+name+".ini"
      progress.call(LANG[:CREATEINGProject],30)
      #File.open(proj,"wb"){|f|f.write()}
      save_data({:name=>name,:title=>title,:game=>"ace project",:group=>"no",:plugins=>[],:encoding=>"UTF8",:KEY=>"ACE-PROJECT OBJECT AUTO SAFELY KEY 201221@YANGFF#{rand(1048576).to_s}",:ver=>"0.0.1 b3"},proj)
      progress.call(LANG[:CREATEINGProject],40)
      File.open(ini,"wb"){|f|f.write("[Game]\n\rRTP=RPGVXAce\n\rLibrary=System\\RGSS300.dll\n\rScripts=Data\\Scripts.rvdata2\n\rTitle=#{title}\n\r")}
      progress.call(LANG[:CREATEINGProject],50)
      copyall Config.ProgramPath + "templates\\#{template}\\",url
      progress.call(LANG[:CREATEINGProject],90)
      s=load_data(url+"Data\\System.rvdata2")
      s.japanese =false
      s.game_title = title
      s.version_id = rand(255)
      save_data(s,url+"Data\\System.rvdata2")
      File.rename(url+"Game.exe","#{url+name}.exe")
      self.open(proj) {|t,v| progress.call(t,v)}
    rescue
      self.close
    end
  end
  def self.open(proj,&progress)
    begin
      self.close #unless @@projectName.nil?
      return unless @@projectName.nil?
      if File.exists?(proj+".lock") #if File.exists?(@@projfile+".lock")
        self.close
        return errorMsg(sprintf(LANG[:OPENED],proj))
      end

      p=proj.split(/\\/)
      p.delete_at(p.size-1)
      p=pathary2path(p)
      proc{self.close;progress.call(sprintf(LANG[:NOEXIT],proj),0);Config.set_last_open("(none)"); return 0 }.call unless FileTest.directory?(p)
      File.open(proj+".lock","wb"){|f|f.write("locked")}
      Dir.chdir(p)
      @@projectPath=p
      p=p.split(/\\/)
      p.delete_at(p.size-1)
      p=pathary2path(p)
      Config.set_auto_path(p)
      @@projectConfig=load_data(proj)
      @@title=@@projectConfig[:title]
      @@projfile=proj
      $mainWindow.reset(proj)
      progress.call(LANG[:OPENINGProject],3)
      DataManager.load_normal_database()
      progress.call(LANG[:OPENINGProject],33)
      $mainWindow.changeto()
      progress.call(LANG[:OPENINGProject],100)
      @@saved=true
      Config.set_last_open(proj)
    rescue
      self.close
    end
  end
  def self.close
    @@title="(none)" 
    $mainWindow.reset("(none)") unless $mainWindow.nil? or $exited
    File.delete(@@projfile + ".lock") if File.exists?(@@projfile+".lock") #.exits?()
  end
  def self.getProjectAutoNewName
    return getProjectAutoTitle
  end
  def self.getProjectAutoURL
    return Config.getProjectSaveUrl+"#{self.getProjectAutoNewName}\\"
  end
  def self.getProjectAutoTitle
    hash={}
    for i in Dir.entries(Config.getProjectSaveUrl)
      if i[0,7]=="Project"
        index=i[/\d+/].to_i
        hash[index]=true
      end
    end
    i=1;
    while (hash[i]==true)
      i+=1
    end
    return "Project#{i}"
  end
  
  def self.projectPath
    return @@projectPath
  end
end