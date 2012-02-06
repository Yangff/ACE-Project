=begin
TODO: !!Rewrite StyledTextCtrl By using new SciLexer!! or update wxRuby -> WTF!
=end
def deep_copy(obj)
  Marshal.load(Marshal.dump(obj))
end
class CodePage
  attr_accessor         :script
  attr_accessor         :name
  attr_accessor         :stoppoints
  attr_accessor         :row
  def initialize(name="",script="",stoppoints=[])
    @script=script
    @name=name
    @stoppoints=stoppoints
  end
end
class CodeBlock < Panel
  class KeywordsDialog < Dialog  
    
      def initialize(parent,helper,func=0, options = {})  
          super(parent, options.merge!(:size => [500, 500],:title=>LANG[:CODEBLOCK][:FIND])) 
          @helper=helper
          arrange_vertically do  
              add @keyword = TextCtrl.new(self, :style => Wx::TE_MULTILINE,:size => [420, -1]), :proportion => 1              

              arrange_horizontally do  
                  add @status = StaticText.new(self, :label => '', :size => [150, -1]), :proportion => 1  
                  add Button.new(self, :label => LANG[:CODEBLOCK][:FIND]) do |button|  
                      evt_button(button) do |event|  
                          #search  
                          self.hide
                          @helper.onSearch(@keyword.get_value,func)  
                          @helper.sci.set_focus()
                          get_parent.set_focus()
                      end                   
                  end               
              end  
          end       
      end  
      def clear_all
        @keyword.set_value("")
      end
      attr_reader :keyword, :status  
  end  
  #StatementIndent="class module def begin rescue ensure while for case when unless if else elsif do" *TODO
  #StatementEnd="end else elsif when rescue ensure"                                                   *TODO
  #BlockStart="{"                                                                                     *TODO
  #BlockEnd="}"                                                                                       *TODO
  KeyWords="__FILE__ __LINE__ attr_accessor attr_reader attr_writer module_function begin break elsif module retry unless end case next return until class ensure nil self when def false not super while alias defined? for or then yield and do if redo true else in rescue undef"
  
  def sci
    return @sci
  end
  def dirty?
    return @dirty
  end
  def result
    return @pages
  end
  def initialize(window,auto=[],now=0)

    font = Font.new(12, TELETYPE, NORMAL, NORMAL,false,"Simsun")#"Lucida Console")
    @dirty=false
    @oldpages=deep_copy(auto)
    @sci = StyledTextCtrl.new(window)
    window.add @sci, :proportion => 1  
    @sci.use_pop_up false
    @sci.set_edge_mode(STC_EDGE_LINE)
    @sci.set_margin_type(1,STC_MARGIN_NUMBER)
    @sci.set_margin_width 1, @sci.text_width(STC_STYLE_LINENUMBER, '_9999')
    @sci.set_tab_width(2)
    @sci.set_use_tabs(false)
    @sci.set_tab_indents(true)
    @sci.set_back_space_un_indents(true)
    @sci.set_indent(2)
    @sci.set_edge_column(80)
    @sci.style_set_font(STC_STYLE_DEFAULT, font);
    @sci.style_set_foreground(STC_STYLE_DEFAULT, BLACK);
    @sci.style_set_background(STC_STYLE_DEFAULT, Colour.new(250,255,250));
    @sci.style_clear_all()
    @sci.ensure_caret_visible();
    @sci.set_caret_line_visible(true)
    @sci.set_caret_line_background(Colour.new(200,200,248))
    @sci.set_caret_line_back_alpha(40)
    @sci.style_set_foreground(STC_STYLE_LINENUMBER, LIGHT_GREY);
    #@sci.style_set_background(STC_STYLE_LINENUMBER, WHITE);
    @sci.style_set_foreground(STC_STYLE_INDENTGUIDE, LIGHT_GREY);
    @sci.set_lexer(STC_LEX_RUBY)
    @sci.style_set_foreground(0, Colour.new(0,0,0))           #SCE_RB_DEFAULT
    @sci.style_set_foreground(2,Colour.new(0,128,0))          #SCE_RB_COMMENTLINE
    @sci.style_set_foreground(3, Colour.new(0,128,0))         #SCE_RB_POD
    @sci.style_set_foreground(4, Colour.new(128,0,0))         #SCE_RB_NUMBER
    @sci.style_set_foreground(5, BLUE)                        #SCE_RB_WORD
    @sci.style_set_foreground(6, Colour.new(128,0,128))       #SCE_RB_STRING
    @sci.style_set_foreground(7, Colour.new(128,0,128))       #SCE_RB_CHARACTER
    @sci.style_set_foreground(8, Colour.new(0,0,128))         #SCE_RB_CLASSNAME
    @sci.style_set_foreground(9, Colour.new(0,0,128))         #SCE_RB_DEFNAME
    @sci.style_set_foreground(10, Colour.new(0,128,192))      #SCE_RB_OPERATOR
    #@sci.style_set_bold(11,true)                             #SCE_RB_IDENTIFIER 局部变量 函数。。
    #@sci.style_set_italic(11,true)
    @sci.style_set_foreground(12,Colour.new(128,0,128))       #SCE_RB_REGEX
    #@sci.style_set_italic(13,true)                            #SCE_RB_GLOBAL
    #@sci.style_set_bold(13,true)
    @sci.style_set_foreground(14,Colour.new(192,96,0))        #SCE_RB_SYMBOL
    @sci.style_set_foreground(15, Colour.new(0,0,128))        #SCE_RB_MODULE_NAME
    @sci.style_set_italic(16,true)                            #SCE_RB_INSTANCE_VAR
    #@sci.style_set_bold(16,true)                             #SCE_RB_INSTANCE_VAR
    @sci.style_set_italic(17,true)                            #SCE_RB_CLASS_VAR
    @sci.style_set_bold(17,true)                              #SCE_RB_CLASS_VAR
    @sci.style_set_foreground(18, Colour.new(128,0,128))      #SCE_RB_BACKTICKS
    #SCE_RB_DATASECTION
    @sci.style_set_foreground(19, Colour.new(0,0,0))          #SCE_RB_DATASECTION
    @sci.style_set_foreground(20, Colour.new(128,0,128))      #SCE_RB_HERE_DELIM
    @sci.style_set_foreground(21, Colour.new(128,0,128))      #SCE_RB_HERE_DELIM Q
    @sci.style_set_foreground(22, Colour.new(128,0,128))      #SCE_RB_HERE_DELIM QQ
    @sci.style_set_foreground(23, Colour.new(0,128,0))        #SCE_RB_HERE_DELIM QX
    @sci.style_set_foreground(24, Colour.new(128,0,128))      #SCE_RB_STRING Q  
    @sci.style_set_foreground(25, Colour.new(128,0,128))      #SCE_RB_STRING QQ
    @sci.style_set_foreground(26, Colour.new(128,0,128))      #SCE_RB_STRING QX
    @sci.style_set_foreground(27, Colour.new(128,0,128))      #SCE_RB_STRING QR
    @sci.style_set_foreground(28, Colour.new(128,0,128))      #SCE_RB_STRING QW 
    @sci.style_set_foreground(29, BLUE)                       #SCE_RB_WORD_DEMOTED
    @sci.style_set_foreground(30, BLUE)                       #SCE_RB_STDIN
    @sci.style_set_foreground(31, BLUE)                       #SCE_RB_STDOUT
    @sci.style_set_foreground(40, BLUE)                       #SCE_RB_STDERR
    
    #SCE_RB_UPPER_BOUND
    @sci.set_key_words(0, KeyWords)
    
    
    @sci.set_property("fold","1")
    @sci.set_property("fold.compact", "0")
    @sci.set_property("fold.comment", "1")
    @sci.set_property("fold.preprocessor", "1")
    
    @sci.set_margin_width(2, 0)
    @sci.set_margin_type(2, STC_MARGIN_SYMBOL)
    @sci.set_margin_mask(2, STC_MASK_FOLDERS)
    @sci.set_margin_width(2, 20)

    @sci.marker_define(STC_MARKNUM_FOLDER, STC_MARK_PLUS)
    @sci.marker_define(STC_MARKNUM_FOLDEROPEN, STC_MARK_MINUS)
    @sci.marker_define(STC_MARKNUM_FOLDEREND, STC_MARK_EMPTY)
    @sci.marker_define(STC_MARKNUM_FOLDERMIDTAIL, STC_MARK_EMPTY)
    @sci.marker_define(STC_MARKNUM_FOLDEROPENMID, STC_MARK_EMPTY)
    @sci.marker_define(STC_MARKNUM_FOLDERSUB, STC_MARK_EMPTY)
    @sci.marker_define(STC_MARKNUM_FOLDERTAIL, STC_MARK_EMPTY)
    #SendEditor(SCI_SETFOLDFLAGS, 16, 0);
    @sci.set_fold_flags(16)

    @sci.set_margin_sensitive(2,true)
    
    
    @sci.set_margin_type(0,STC_MARGIN_SYMBOL)
    @sci.set_margin_width(0, 9)
    @sci.set_margin_mask(0,1)
    @sci.set_margin_mask(1,0)
    @sci.marker_define(0,STC_MARK_ARROW)
    
    @sci.marker_set_foreground(0,Colour.new(255,0,0))
    @sci.set_margin_sensitive(0,true)
    @sci.set_indentation_guides(true)
    window.evt_stc_charadded(@sci.get_id) {|evt| onCharadded(evt)}
    window.evt_stc_marginclick(@sci.get_id) {|evt| onMarginClick(evt)}
    window.evt_stc_savepointreached(@sci.get_id) { | evt | @dirty=false }
    window.evt_stc_savepointleft(@sci.get_id) { | evt | @dirty=false }
    @popmenu=Wx::Menu.new()
    @FLAG=[]
    Helpers.createMenu(@popmenu,LANG[:MENU][:CODEPOPs],@FLAG)
    @sci.evt_right_up{|evt|@sci.popup_menu(@popmenu)}
    @popmenu.evt_menu 0,proc{|evt|@sci.cut}
    @popmenu.evt_menu 1,proc{|evt|@sci.copy}
    @popmenu.evt_menu 2,proc{|evt|@sci.paste}
    @popmenu.evt_menu 3,proc{|evt|@sci.select_all}
    @popmenu.evt_menu 4,proc{|evt|@keyWordDialog=KeywordsDialog.new(window,self);@keyWordDialog.show_modal;@keyWordDialog.destroy}
    @popmenu.evt_menu 5,proc{|evt|searchNext}
    @popmenu.evt_menu 6,proc{|evt|changeto(2)}
    #Integer search_next(Integer flags, String text)
    #@keyWordDialog=KeywordsDialog.new(window,self)
    #@keyWordDialogWhole=KeywordsDialog.new(window,self,1)
    @window=window
    #
    if auto.size==0
      @page=1
      @pages=[nil,CodePage.new("","",[])]
    else
      @page=now
    end
    impolitechangeto(@page)
  end

  def searchWrong(text)
    Wx::MessageDialog.new(nil, LANG[:CODEBLOCK][text],LANG[:CODEBLOCK][:SearchWrong]).show_modal
  end
  def onSearch(keyword,func=0)
    @searchflag=0
    @keyword=keyword
    if @keyword.to_s==""
      searchWrong(:KEYWORDMISS)
      return false     
    end
    @sci.search_anchor
    beg_pos=@sci.search_next(@searchflag,keyword)
    if (beg_pos!=-1)
      @end_pos = beg_pos + keyword.length+1
      @sci.goto_pos beg_pos
      @sci.set_selection(beg_pos,@end_pos-1)
      @sci.show_lines(@sci.line_from_position(beg_pos), @sci.line_from_position(@end_pos))
      @sci.update
      @sci.search_anchor
    else
      searchWrong(:PAGEOVER)
      @end_pos = 0
      @sci.goto_pos 0
    end
  end
  def searchNext
    if @keyword.to_s==""
      searchWrong(:KEYWORDMISS)
      return false
    end
    @sci.goto_pos @end_pos
    @sci.search_anchor
    
    beg_pos=@sci.search_next(@searchflag,@keyword)
    if (beg_pos!=-1)
      @end_pos = beg_pos + @keyword.length+1
      @sci.goto_pos beg_pos
      @sci.set_selection(beg_pos,@end_pos-1)
      @sci.show_lines(@sci.line_from_position(beg_pos), @sci.line_from_position(@end_pos))
      @sci.update
      @sci.search_anchor
    else
      searchWrong(:PAGEOVER)
      @end_pos = 0
    end    
  end
  def apply
    save_page
    @oldpages=deep_copy(@pages)
    GC.start
  end
  def cancel
    @pages=deep_copy(@oldpages)
    GC.start
  end
  def clear(pages=[nil,CodePage.new("","",[])])
    clear_all
    @pages=pages
    @oldpages=deep_copy(@pages)
    GC.start
    impolitechangeto(1)
  end
  def save_page
    @pages[@page].script=@sci.get_text()
    @sci.set_save_point
    @dirty=false
  end
  def clear_all
    @sci.clear_all()
    @sci.marker_delete_all(0)
    @sci.set_stc_focus true
  end
  def changeto(page)
    save_page
    clear_all
    impolitechangeto(page)
  end
  def impolitechangeto(page)
    @sci.set_undo_collection(false)
    @page=page
    @sci.cancel
    @sci.set_text(@pages[@page].script)
    @sci.goto_pos(0)
    for i in @pages[@page].stoppoints
      @sci.marker_add(i,0)
    end
    @sci.set_undo_collection(true)
    @sci.empty_undo_buffer()
    @sci.set_save_point
    @dirty=false
    @sci.set_stc_focus true
  end
  def insert(p)
    @pages.insert(p,CodePage.new)
    changeto(p)
  end
  def delete(p)
    return false if @pages.size==2
    @pages.delete_at(p)
    p=[1,[@pages.size-1,p].min].max
    impolitechangeto(p)
    @dirty=false
  end
  def rename(p,n)
    @pages[p].name=n
  end
  def onCharadded(evt)
    chr =  evt.get_key
    curr_line = @sci.get_current_line
    
    if(chr == 13)
        if curr_line > 0
          line_ind = @sci.get_line_indentation(curr_line - 1)
          if line_ind > 0
            @sci.set_line_indentation(curr_line, line_ind)
            @sci.goto_pos(@sci.position_from_line(curr_line)+line_ind)
            @pages[@page].row=curr_line
          end
        end
    end

  end

  def onMarginClick(evt)
    line_num = @sci.line_from_position(evt.get_position)
    margin = evt.get_margin
    if(margin == 0)
	
      if (@sci.marker_get(line_num)&1)==1
        @sci.marker_delete(line_num,0)
        @pages[@page].stoppoints.delete(line_num) if @pages[@page].stoppoints.include?(line_num)
      else
        @sci.marker_add(line_num,0)
        @pages[@page].stoppoints.push(line_num) if not @pages[@page].stoppoints.include?(line_num)
      end
      
    end
    if(margin == 2)
      @sci.toggle_fold(line_num)
      
    end  

  end
=begin
    for i in $scripts
      d=Zlib::Inflate.inflate(i[2]).force_encoding("UTF-8")
      ary=[]
      ary=i[0] if i[0].is_a?(Array)
      scripts<<CodePage.new(i[1],d,ary)
     
    end
=end
  def save
    apply
    $scripts=[]
    for i in @pages
      next if i.nil?
      $scripts<<[i.stoppoints,i.name,Zlib::Deflate.deflate(i.script)]
    end
    GC.start
  end
end