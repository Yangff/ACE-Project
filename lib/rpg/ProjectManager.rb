require 'uri'
module ProjectManager
  ERRORS = {
    :DIRECTIONEXITS => 1
  }
  def self.programURL=(url)
    @@programURL=url
  end
  def self.programURL
    return @programURL
  end
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
    DataManager.load_normal_database()
    @@saved=true
  end
  def self.title
    return @@title
  end
  def self.init
    @@title=LANG[:TITLE]
    @@saved=true
    @@projectName=nil
  end
  def self.create(name,url,title,&progress)
    progress.call(:CREATEINGProject,0)
    begin
      uri =  URI.join(url,name)
      return ERRORS[:DIRECTIONEXITS] if FileTest.directory?(uri.address)
      progress.call(LANG[:CREATEINGProject],20)
      proj = URI.join(url,name,name+".rvproject2x")
      ini=URI.join(url,name,name+".ini")
      progress.call(LANG[:CREATEINGProject],50)
      File.open(proj.address,"wb"){|f|f.write("ACEPROJECTX")}
      progress.call(LANG[:CREATEINGProject],70)
      File.open(ini.address,"wb"){|f|f.write("[Game]\nRTP=RPGVXAce\nLibrary=System\\RGSS300.dll\nScripts=Data\\Scripts.rvdata2\nTitle=#{title}\n")}
      progress.call(LANG[:CREATEINGProject],100)
      self.open(proj.address)
    rescue
      
    end
  end
  def self.open(proj,&progress)
    self.close unless @@projectName.nil?
    Dir.chdir(proj)
    @@title="TODO:Set Title by ini title"
    $mainWindow.reset(proj)
    progress.call(LANG[:OPENINGProject],3)
    DataManager.load_normal_database()
    progress.call(LANG[:OPENINGProject],33)
    $mainWindow.changeto()
    progress.call(LANG[:OPENINGProject],100)
    @@saved=true
  end
end