class MapEditor<Panel
  def changeto(newmap=[])
    
  end
  def redo
    
  end
  def undo
    
  end
end
class MapGuide < Panel
  def initialize(parent, options = {})
    super(parent, options.merge!(:size => [200, -1]))
    @root_bmp = Wx::ArtProvider::get_bitmap( Wx::ART_FOLDER, 
                                            Wx::ART_OTHER, 
                                            Wx::Size.new(16,16) )    
    @map_bmp = Wx::ArtProvider::get_bitmap( Wx::ART_NORMAL_FILE, 
                                            Wx::ART_OTHER, 
                                            Wx::Size.new(16,16) )  
    arrange_vertically do 
      @lb=TreeCtrl.new(self,:style=>TR_LINES_AT_ROOT|TR_EDIT_LABELS|TR_HAS_BUTTONS|TR_SINGLE)
      add @lb,:proportion => 1  
      evt_tree_sel_changed(@lb.id){|evt|
        $mainWindow.mapeditor.changeto(@lb.get_selection())
      }
      @il=ImageList.new(16,16)
      @rootbmp = @il.add(@root_bmp)
      @mapbmp=@il.add(@map_bmp)
      @lb.set_image_list @il
      evt_tree_item_expanded (@lb.id){|evt|@lb.get_item_data(evt.get_item()).enpanded=!@lb.get_item_data(evt.get_item()).enpanded unless evt.get_item()==@root}
      @lb.instance_eval{
          def on_compare_items(a,b)
            return 0 if @lb.get_item_data(a).order>@lb.get_item_data(b).order
            return 1
          end
      }
      
    end
  end
  def changeto(mapinfos=$data_mapinfos)
    @lb.delete_all_items()
    @selected=1
    @root=@lb.add_root(ProjectManager.title,@rootbmp)
    @mapid=[]
    @mapid[0]=@root
    for ii in mapinfos
       i=ii[1]
      item=@lb.append_item(@mapid[i.parent_id] ,i.name,@mapbmp,-1,i)
      @mapid[ii[0]]=item
      #@root
      if i.expanded
        @lb.expand(item)
      end
    end
    @lb.sort_children 0
  end
  def changetitle(newtitle)
    
  end
end