module Flowable
  def str2fix(str)
    case str.size
    when 1
      str.unpack("c")[0]
    when 2
      str.unpack("s")[0]
    when 4
      str.unpack("v")[0]
    end
  end
  
  def fix2str(fix)
    str = [fix].pack("s")
    return str
  end
  
  def str2int(str)
    return str.unpack("L")[0]
  end
  
  def int2str(int)
    return [int].pack("L")
  end
  
  def str2float(str)
    return str.unpack("d")[0]
  end
  
  def float2str(float)
    return [float].pack("d")
  end
  
end
class Table
  include Flowable
  def initialize(*arg)
    tempAry=arg
    txsize = tempAry[0]
    tysize = tempAry[1] != nil ? tempAry[1] : 1
    tzsize = tempAry[2] != nil ? tempAry[2] : 1
    # 缁存暟
    tdim = [tempAry.size,3].min
    
    if tempAry[tdim].nil?
      @data = int2str(tdim)+int2str(txsize)+int2str(tysize)+int2str(tzsize)+int2str(txsize*tysize*tzsize)
      
      for z in 0...tzsize
        for y in 0...tysize
          for x in 0...txsize
            @data += fix2str(0)
          end
        end
      end
    else
      @data = tempAry[tdim]
    end
    
  end
  
  def [](x,y=0,z=0)
    return nil unless x < xsize and y < ysize and z < zsize
    pos = 10 + z*xsize*ysize + y*xsize + x
    pos *= 2
    
    str = @data[pos,2]
    return str2fix(str)
  end
  
  def []=(*arg)
    x = 0
    y = 0
    z = 0
    
    tempAry=arg
    
    value = tempAry[tempAry.size-1]
    
    case tempAry.size
    when 2
      x = tempAry[0]
    when 3
      x = tempAry[0]
      y = tempAry[1]
    when 4
      x = tempAry[0]
      y = tempAry[1]
      z = tempAry[2]
    end
    
    pos = 10 + z*xsize*ysize + y*xsize + x
    pos *= 2
    str = fix2str(value)
    
    @data = @data[0,pos] + str + @data[pos+2,@data.size - pos - 2]
    
    return value
  end
  
  def resize(*arg)
    tempAry=[*arg]
    txsize = tempAry[0]
    tysize = tempAry[1] != nil ? tempAry[1] : 1
    tzsize = tempAry[2] != nil ? tempAry[2] : 1
    # 缁存暟
    tdim = [tempAry.size,3].min
    
    if tempAry[3].nil?
      @data = int2str(tdim)+int2str(txsize)+int2str(tysize)+int2str(tzsize)
      for z in 0...tzsize
        for y in 0...tysize
          for x in 0...txsize
            @data += fix2str(0)
          end
        end
      end
    else
      @data = tempAry[3]
    end
    
  end
  
  def data;@data;end
  def dim;str2int(@data[0,4]);end
  def xsize;str2int(@data[4,4]);end
  def ysize;str2int(@data[8,4]);end
  def zsize;str2int(@data[12,4]);end
  def size;str2int(@data[16,4]);end
  
  def _dump(aDepth)
    return @data
  end
  
  def Table._load(data)
    dim = str2int(data[0,4])
    xsize = str2int(data[4,4])
    ysize = str2int(data[8,4])
    zsize = str2int(data[12,4])
    size = str2int(data[16,4])
    return Table.new(xsize,ysize,zsize,data)
  end
end
