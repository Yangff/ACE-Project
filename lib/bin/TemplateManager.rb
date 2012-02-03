require 'find'
require "zlib"
require "openssl"
require "digest/sha2"
module TemplateManager
  module_function
  
  def self._init
    @@config_file_path =Config.ProgramPath+"templates\\config.cfg"
    unless File.exists?(@@config_file_path)
      save_data({},@@config_file_path)
    end
    @@config_file =load_data(@@config_file_path)
  end
  def self.save
    save_data(@@config_file,@@config_file_path)
  end
  
  def self.remove(id)
          @@config_file[id]=nil
          removeall(Config.ProgramPath+"templates\\#{id}\\")
          Dir.delete(Config.ProgramPath+"templates\\#{id}")
          save
          print "Removed #{id}"
  end
  def self.getall
    return @@config_file
  end
  def self.add(path)
    $f.open(path){|f|
      head=$m.load(f)
      
      if @@config_file[head[:id]] != nil
        if (@@config_file[head[:id]][:templatever]>=head[:templatever])
          print "You have already install such a template."
          return
        else
          remove(head[:id])
        end
      end
      if File.directory?(Config.ProgramPath+"templates\\#{head[:id]}\\")
        remove(head[:id])
      end
      if head[:ver]=="0.0.1 b3"
        if head[:keyed]
          print "Keyed ,you need to install Template Center to install the template."
        else
          print "Informations:"
          print "id:#{head[:id]}"
          print "name:#{head[:name]}"
          print "ver:#{head[:templatever]}"
          print "maker:#{head[:maker]}"
          key=head[:code]
          
          Dir.mkdir(Config.ProgramPath+"templates\\#{head[:id]}")
          File.open(Config.ProgramPath+"templates\\#{head[:id]}.png","wb"){|f1|f1.write(head[:icon])}
          dd=$m.load(f)
          for d in dd
            puts d[1]
            if d[0]=="dir"
              Dir.mkdir(Config.ProgramPath+"templates\\#{head[:id]}" + d[1])
            end
            if d[0]=="file"
              File.open(Config.ProgramPath+"templates\\#{head[:id]}" + d[1],"wb"){|f1|
                data=Zlib::Inflate.inflate(d[3])
                skey=OpenSSL::Cipher.new('aes-256-cbc').decrypt
                skey.key=key[0]
                skey.iv=key[1]
                data=skey.update(data)+skey.final
                if Digest::SHA512.base64digest(data)==d[2]
                  f1.write(data)
                else
                  print "SHA512 Bad Returns!"
                  return false
                end
                
              }
            end
          end
          @@config_file[head[:id]]=head
        end
      else
        print "Cannot load template."
      end
    }
    save
  end
end