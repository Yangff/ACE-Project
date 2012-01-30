#encoding:utf-8
LANG={
  :TITLE=>"ACE Project",
  :CREATEINGProject=>"正在创建工程",
  :OPENINGProject=>"正在打开工程",
  :MENU=>
    {
      :KEYS=>[:FILE,:EDIT,:MODE,:DRAW,:BILLY,:TOOLS,:TEST,:PLUGINS,:HELP],
      :VALUES=>[:FILEs,:EDITs,:MODEs,:DRAWs,:BILLYs,:TOOLSs,:TESTs,:PLUGINSs,:HELPs],
      :FILE   =>"文件(&F)",
      :EDIT   =>"编辑(&E)",
      :MODE   =>"模式(&M)",
      :DRAW   =>"绘图(&D)",
      :BILLY  =>"比例(&S)",
      :TOOLS  =>"工具(&T)",
      :TEST   =>"测试(&T)",
      :PLUGINS=>"插件(&P)",
      :HELP   =>"帮助(&H)",
      :FILEs=>[
      [:NEW,"新建项目(&N)\tCtrl+N",],
      [:OPEN,"打开项目(&O)\tCtrl+O",],
      [:CLOSE,"关闭项目(&C)",],
      [:SAVE,"保存项目(&S)\tCtrl+S",],
      [:separator,""],
      [:PACK,"制作游戏发行包(&M)",],
      [:separator,""],
      [:EXIT,"关闭(&X)"],
      ],
      :EDITs=>[
      [:CANCEL,"撤销(&Z)\tCtrl+Z",],
      [:separator,""],
      [:CUT,"剪切(&X)\tCtrl+X",],
      [:COPY,"复制(&C)\tCtrl+C",],
      [:PASTE,"粘贴(&V)\tCtrl+X",],
      [:DEL,"删除\tDel",],
      ], 
      :MODEs=>[
      [:MAP,"地图\tF5"],
      [:EVENT,"事件\tF6"],
      [:AREA,"区域\tF7"],
      ],
      :DRAWs=>[
      [:PANCEL,"铅笔(&P)"],
      [:RECT,"矩形(&R)"],
      [:ECC,"椭圆(&E)"],
      [:FLORDFILL,"油漆桶(&F)"],
      [:SHADOW,"阴影(&S)"],
      ],
      :BILLYs=>[
        ["OO","1/1"],
        ["OT","1/2"],
        ["OF","1/4"],
        ["OE","1/8"],
      ],
      :TOOLSs=>[
        [:DATABASE,"数据库(&D)\tF9"],
        [:MEDIA,"媒体库(&R)\tF10"],
        [:SCRIPT,"脚本编辑器(&S)\tF11"],
        [:SCRIPTGuide,"脚本导航(&G)"],
        [:SOUND,"声音测试(&T)"],
        [:CHARACTER,"角色生成(&C)"],
        [:separator,""],
        [:CHARACTER,"选项(&O)"],
      ],
      :TESTs=>[
        [:RUN,"运行(&T)\tF12"],
        [:separator,""],
        [:FULL,"全屏模式(&F)"],
        [:CONTROL,"启用控制台(&C)"],
        [:separator,""],
        [:OPENGame,"打开游戏文件夹(&O)"],
      ],
      :PLUGINSs=>
      [
        [:GETMORE,"获取插件(&G)"],
        [:separator,""],
      ],
      :HELPs=>[
        [:LOOKHELP,"查看帮助(&C)\tF1"],
        [:UPDATE,"检查更新(&U)"],
        [:separator,""],
        [:ABOUT,"关于 ACE-Project"],
      ],
        
      :CODEPOPs=>[
      [:CUT,"剪切(&X)\tCtrl+X",],
      [:COPY,"复制(&C)\tCtrl+C",],
      [:PASTE,"粘贴(&V)\tCtrl+X",],
      [:PASTE,"全选(&A)\tCtrl+A",],
      [:separator,""],
      [:FIND,"查找（&F)\tCtrl+F"],
      [:FINDNEXT,"下一个\tF3"],
      [:REPLACE,"替换(&R)\tCrel+R"],
      [:GFIND,"全局查找（&L)\tCtrl+L"],
      [:separator,""],
      [:GOTO,"转到（&G)\tCtrl+G"],
      [:NOTE,"批注释(&N)\tCtrl+N"]
      ],
    },
    :HELPs=>
      {
        :NEW=>"新建项目\n新建一个项目"
      },
    :CODEBLOCK=>
      {
        :SearchWrong=>"搜索出错啦！~~>_<~~",
        :KEYWORDMISS=>"主人，关键词不能为空啦！！(σ・Д・)σ★",
        :PAGEOVER=>"讨厌啦，人家……人家已经把整个代码找遍了都找不到……~~~ヾ(○゜▽゜○) ",
        :TITLE=>"脚本编辑器",
        :GUIDE=>"脚本导航",
		:FIND=>"查找",
      },
      :OUTPUT=>"输出",
    :NEWProject=>
      {
        :TITLE =>"新建项目",
        :FONAME =>"文件夹名：",
        :TINAME =>"游戏标题："
      },
    :NORMALFONT=>Font.new(9,FONTFAMILY_DEFAULT,FONTSTYLE_NORMAL,FONTWEIGHT_NORMAL,false,"微软雅黑"),
}