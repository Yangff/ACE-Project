#encoding : utf-8
def windows?  
!(RUBY_PLATFORM =~ /win32/).nil?  
end  
#if windows?
	require 'iconv'
	$i=Iconv.new("GBK","UTF-8")
	$g=Iconv.new("UTF-8","GBK")
	alias print_oo print
	alias gets_oo gets
	def print(str)
		print_oo $i.iconv str
	end
	def gets
		return $g.iconv gets_oo
	end
	
#end
require "zlib"
require "openssl"
require "digest/sha2"
print "模板名字："
name=gets.delete("\n").delete("\r")
print "模板版本（int）："
tv=gets.delete("\n").delete("\r")
print "模板ID（唯一标识符）："
id=gets.delete("\n").delete("\r").to_sym
print "模板作者："
maker=gets.delete("\n").delete("\r")
print "加密选项（yes/no）："
key=gets.delete("\n").delete("\r")

print "高级控制串（保留功能，不明白的留空即可）："
control=gets.delete("\n").delete("\r")
############################################################
## 您需要注意的是，加密只能保证您的模板在分发时不被窃取 ！##
##         需要准备ID名的Icon在根目录下（png格式）        ##
############################################################
def pathary2path(path)
    path1=""
  
  for i in path
    path1<<i<<"\\"
  end
  return path1
end
def copyall(src,flag)
  list=Dir.entries(src)
  list.each_index do |x| 
    next if list[x]=="." or list[x]==".." or list[x]==".svn" or list[x]=="entries" or list[x]==".git"
    #puts list[x]
    #print src+list[x] + "\n"
    unless File.directory?(src+list[x]) 
      #FileUtils.cp "#{src+list[x]}"
      skey=OpenSSL::Cipher.new('aes-256-cbc').encrypt
      skey.key=$key
      skey.iv=$iv
      print flag+list[x]+"\n"
    	File.open(src+list[x],"rb"){|f|fd=f.read();ck=Digest::SHA512.base64digest(fd);$flist<<["file",flag+list[x],ck,Zlib::Deflate.deflate(skey.update(fd)+skey.final,5)];};
    else
      #Dir::mkdir(target+list[x])
      $flist<<["dir",flag+list[x]]
      copyall(src+list[x]+"\\",flag+list[x]+"\\")
    end
  end
end
  path=Dir.pwd
  path.gsub!(/\//){"\\"}
  path<<"\\"
  @icon="(none)"
File.open(id.to_s+".png","rb"){|f|@icon=f.read} #
head={:id=>id,:name=>name,:maker=>maker,:control=>control,:ver=>"0.0.1 b3",:keyed=>(key=="yes"),:coder=>"aes-256-cbc",:icon=>@icon,:templatever=>tv.to_i}
$skey=OpenSSL::Cipher.new('aes-256-cbc').encrypt
$key = $skey.random_key
$iv = $skey.random_iv
if head[:keyed]
	File.open(path+id.to_s+".tpl.key","wb"){|f|Marshal.dump([$key,$iv],f)}
else
	head[:code]=[$key,$iv]
end
$flist=[]
Dir.chdir(path+"template\\")
copyall(path+"template\\","\\")
url=path+id.to_s+'.tpl'
print url
File.open(url,"wb"){|f|
	Marshal.dump(head,f)
	Marshal.dump($flist,f)
}
gets