#encoding:utf-8
LANG={
  :TITLE=>"ACE Project",
  :CREATEINGProject=>"正在创建工程",
  :OPENINGProject=>"正在打开工程",
  :DIRECTIONEXITS=>"目录已存在",
  :NOEXIT=>"工程[%s]不存在！",
  :OPENED=>"工程[%s]已经打开了！！",
  :MENU=>
    {
                        #:MODE,:DRAW,:BILLY,
      :KEYS=>[:FILE,:EDIT,:TOOLS,:TEST,:WINDOWS,:PLUGINS,:HELP],
                            #,:MODEs,:DRAWs,:BILLYs
      :VALUES=>[:FILEs,:EDITs,:TOOLSs,:TESTs,:WINDOWSs,:PLUGINSs,:HELPs],
      :FILE   =>"文件(&F)",
      :EDIT   =>"编辑(&E)",
      :MODE   =>"模式(&M)",
      :DRAW   =>"绘图(&D)",
      :BILLY  =>"比例(&S)",
      :TOOLS  =>"工具(&T)",
      :TEST   =>"测试(&T)",
      :WINDOWS=>"窗口(&W)",
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
      [:ADDTEMPLATE,"添加模板(&T)"],
      [:MANTEMPLATE,"管理模板(&T)"],
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
      :WINDOWSs=>[
        [:WORKING,"施工重地，非请勿入"],
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
        :TINAME =>"游戏标题：",
        :PROJURL =>"项目位置",
        :YES =>"确定(&S)",
        :NO =>"取消(&C)",
        :TEMPLATEN => "选择模板：",
        :NOSELECTION=>"乃真的忍心人家光光的……不给人一个模板吗？"
      },
    :NORMALFONT=>Font.new(9,FONTFAMILY_DEFAULT,FONTSTYLE_NORMAL,FONTWEIGHT_NORMAL,false,"微软雅黑"),
    :TEMPLATEOPENER=>{
      :MESSAGE=>"请选择要添加的模板文件",
      :WILDCARD=>"模板文件(*.tpl)|*.tpl",
    },
}
$APACHEV2=<<EOF
Based on RPG MAKER VX ACE Version 1.0.0 Copyright (C) 2011 Enterbrain , Inc. / 
Yoji Ojima
Apache License
http://www.apache.org/licenses/LICENSE-2.0
wxRuby2
Copyright (c) 2004-2007 wxRuby Development Team
Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
Enterbrain License
Ruby Version 1.9.2 Copyright (C) 1993-2010 Yukihiro Matsumoto
libogg Version 1.2.2 Copyright (C) 2002 Xiph.Org Foundation
libvorbis Version 1.3.2 Copyright (C) 2002-2008 Xiph.Org Foundation
libtheora Version 1.1.1 Copyright (C) 2002-2009 Xiph.Org Foundation
libtheoraplayer Version 1.0 Copyright (C) 2008-2009 Kresimir Spes <kreso@cateia.com>
This software is based in part on the work of the Independent JPEG Group.
EOF
