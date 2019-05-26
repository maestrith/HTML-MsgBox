#SingleInstance,Force
global CSS,wb,v:=[]
m:=New MsgBoxClass("My Title")
m.AddButton(0,{Btn:{Text:"Drop Shadows",ID:"Drop"},CSS:{Background:"Red",Color:"Orange"}},"Round Edges",{Btn:{Text:"Pretty Title"}},{Btn:{Text:"Show Me Something Cool",ID:"Cool"}},{Btn:{Text:"Fancy ScrollBar",ID:"Fancy"}},"This Windows Code","Change Buttons")
if(ShowSettings:=0){
	m.Get("Save-Position").Click()
	m.Display("Nice")
}
/*
	;~ Adding Icons
	II:=m.Img("&#x24CD;",,60,60,40) ;Circle With X
	II:=m.Img("&#x26D4;",,60,60,40) ;Circle With Dash
	II:=m.Img("&#x26D2;",,60,60,40) ;Circle With X Better?
	II:=m.Img("&#x2297;",,60,60,40) ;Nicer Circle With X Better?
*/
(Style:=m.Get("Icon").Style).OverFlow:="Hidden"
Style.Color:="Red"
SeeCode:=0
if()
	Cool(m)
MsgBox,% m.Display("<font size='9'><b>H</b>el<font color='red'>l</font><i>o</i><font size='3'><br>Press any of the buttons to see an effect<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>Here to show the scrollbar :)")
ExitApp
return
Escape(){
	MsgBox,You Pressed Escape
	ExitApp
}
Close(){
	MsgBox,You Pressed The X
	ExitApp
}
Class MsgBoxClass{
	Keep:=[]
	__New(Title:="",Owner:="",Win:="MsgBox"){
		static
		this.File:=A_LineFile "\..\Settings.XML",this.XML:=ComObjCreate("MSXML2.DOMDocument"),this.XML.SetProperty("SelectionLanguage","XPath"),this.XML.Load(this.File)
		if(!this.XML.SelectSingleNode("//*"))
			this.XML.AppendChild(this.XML.CreateElement("Settings"))
		Gui,%Win%:Destroy
		Gui,%Win%:Default
		Gui,-Resize +HWNDMain -Caption +LabelMsgBoxClass.
		Gui,Margin,0,0
		Ver:=this.FixIE(11),this.Action:=this.Action.Bind(this),this.SetHotkey(),this.Title:=Title?Title:A_ScriptName,this.MoveSize:=this.MoveSize.Bind(this)
		Gui,Add,ActiveX,w800 h400 vwb HWNDIE,mshtml
		wb.Navigate("about:blank"),wb.Silent:=1,this.FixIE(Ver)
		while(wb.ReadyState!=4)
			Sleep,10
		SysGet,Border,33
		SysGet,Caption,31
		SysGet,Edge,45
		RegRead,CheckReg,HKCU\SOFTWARE\Microsoft\Windows\DWM,ColorizationColor
		wb.Doc.Body.OuterHtml:="<Body><Div ID='WinForm' Style='Visibility:hidden'></Div><Div ID='OverAll'><Div ID='Header'><Div ID='Close' UnSelectable='on'>X</Div><Div ID='Save-Position' UnSelectable='on' Class='tooltip'>S<Span Class='ToolTipText' Style='Border:2px Solid Grey'>Save The MsgBox Position</Span></Div><Div ID='Title' UnSelectable='on'>" this.Title "</Div></Div><Div ID='ContentDiv'><Div><Img ID='Img' Style='Display:Flex;Width-0px;Flex-Direction:Column'/><p ID='Icon' Style='Float:Left;Color:Grey;Flex-Direction:Column;Text-Align:Center;Width:100%;Margin-Top:0px;OverFlow:Auto'/></Div><Div ID='Content'></Div></Div><Div ID='Buttons'></Div></Div><Styles ID='Styles'></Styles></Body>",this.Main:=Main,this.Doc:=wb.Document,MsgBoxClass.Keep[Main]:=this,this.Buttons:=[],this.Dup:=[],this.Color:=(CC:=SubStr(Format("{:x}",CheckReg+0),-5))?CC:"AAAAAA",this.Border:=Border,this.Caption:=Caption,this.Edge:=Edge,this.Body:=this.Doc.Body,this.ID:="ahk_id" Main,this.Win:=Win,this.IE:=IE,this.Doc.ParentWindow.ahk_event:=this._Event.Bind(this),this.CreateElement("Script",,"onmousedown=function(event){ahk_event('MouseDown',event);" Chr(125) ";onclick=function(event){ahk_event('OnClick',event);" "}"),this.Elements:={Buttons:{Position:"Absolute",Left:0,Right:0,Bottom:0,Height:"30px"},Header:{Position:"Absolute",Left:0,Right:0,Top:0},Content:{OverFlow:"Auto",Height:"100%",Color:"Pink",Width:"100%"},"Save-Position":{"Z-Index":2,Position:"Relative",Cursor:"Hand","Text-Align":"Center",Top:0,Color:"Black",Float:"Right",Width:"30px",Height:"20px","Line-Height":"20px",Background:this.Color},Close:{"Z-Index":4,Cursor:"Hand","Text-Align":"Center",Top:0,Color:"Black",Float:"Right",Right:0,Width:"30px",Height:"20px","Line-Height":"20px",Background:this.Color,Position:"Relative"},Title:{"Z-Index":1,"Line-Height":"20px","Height":"20px","White-Space":"NoWrap","OverFlow":"Hidden","Text-Overflow":"Ellipsis","Text-Align":"Center",Cursor:"Move",Background:this.Color},"Close:Hover":{Background:"Red","Border-Color":"Red"},"Close:Active":{Background:"Pink"},"Save-Position:Hover":{Background:"Blue"},Buttons:{Bottom:"0px",Left:"0px",Position:"Absolute",Display:"Flex",Height:"40px"},ContentDiv:{Position:"Absolute",Display:"Flex",Top:"20px",Bottom:"40px",Right:0,Left:0},Img:{Width:"0px"}}
		for a,b in this.Elements
			this.Update(a,b)
		this.Update(".tooltip",{Position:"Relative",Display:"Inline-Block"},1),this.Update(".tooltip .tooltiptext",{Width:"120px","Background-Color":"Black",Color:"#FFF","Text-Align":"Center","Border-Radius":"6px",Padding:"5px",Position:"Absolute","Z-Index":"8",Top:"10px",Right:"105%",Visibility:"Hidden"},1),this.Update(".tooltip:hover .tooltiptext",{Visibility:"Visible"},1),this.Update("HTML Body",{"Background":"Black"},1),this.Arrows:=[]
		for a,b in ["Up","Down","Left","Right"]
			this.Arrows.Push("+" b),this.Arrows.Push("!" b)
		return this
	}_Event(Name,Event){
		static
		Node:=Event.srcElement,CTRL:=this
		if((Node.NodeName="TD"||Node.ParentNode.NodeName="TD")&&Name="OnClick"){
			if(Node.GetElementsByTagName("Input").Item[0])
				ToolTip
			else{
				InputBox,NewInfo,Update Information,% "New Value For " Node.GetAttribute("Name"),,,,,,,,% Node.InnerText
				if(ErrorLevel)
					return
				this.XML.SelectSingleNode("//Window[" Node.ID "]").SetAttribute(Node.GetAttribute("Name"),NewInfo),Node.InnerText:=NewInfo,this.Save()
			}return
		}if(Name="MouseDown"){
			if(Node.ID="Title"){
				Mode:=A_CoordModeMouse
				CoordMode,Mouse,Screen
				MouseGetPos,x,y,Win
				WinGetPos,xx,yy,w,h,% this.ID
				Focus:=this.Document.ActiveElement,OffSetX:=xx-x,OffSetY:=yy-y,this.HWND:=Win,this.ID:="ahk_id" Win
				while(GetKeyState("LButton")){
					MouseGetPos,x,y
					WinMove,% this.ID,,% x+OffSetX,% y+OffSetY
					Sleep,10
				}SetTimer,MSGFocus,-10
				CoordMode,Mouse,%Mode%
				return
				MSGFocus:
				Focus.Focus()
				return
			}return
		}else if(Node.ID="Save-Position"){
			this.Get("OverAll").Style.Visibility:="Hidden",Form:=this.Get("WinForm"),this.Get("WinForm").Style.Visibility:="Visible",this.SetHotkey(0),EA:=this.EA(this.CurrentNode:=this.FindTitle(this.Window))
			if(!this.Get("Window-Title"))
				Form.AppendChild(New:=this.CreateElement("Div")),WW:="Type='Text' Style='Width:100%'",AddHTML:="<Div>Window Title:</Div><Input ID='Window-Title' " WW "/><Div>Window Class:</Div><Input ID='Window-Class' " WW "/><Div>Window EXE:</Div><Input ID='Window-EXE' " WW "/><fieldset Style='Width:calc(100% - 35px)'><legend Style=''>Based On:</legend><Input Type='Checkbox' ID='Window-Height'/>Window Height<Div/><Button ID='Window-Pos' Name='Window'>Window Position</Button></fieldset></Div><Div></Div><Button ID='Window-Global' Name='Global' Style='Margin-Top:10px'>Global Position</Button><Style>Input:Focus{Background:Gold;outline:2px Solid Gold;" Chr(125) "</Style><Div ID='Table' Style='Padding-Top:10px'><table></table></Div><Style>table {Border-Collapse:Collapse;Border-Spacing:0;Width:100%;Border:2px Solid #ddd;" Chr(125) "td{Border:1px Solid #dddddd;Text-Align:Left;Padding:8px;" Chr(125) "td{Text-Align:Left;Padding:16px;Text-Align:Left;Cursor:Hand;" Chr(125) "th{Text-Align:Left;Padding:16px;Color:Red;" Chr(125) "</Style>",New.InnerHTML:=AddHTML
			if(1){
				Table:=this.Doc.GetElementsByTagName("Table").Item[0],PP:=Table.ParentNode,Table.ParentNode.RemoveChild(Table),Table:=this.CreateElement("Table",,,PP)
				for a,b in {TR:(Headers:=["Title","Class","EXE"])}{
					Parent:=Table.AppendChild(this.CreateElement(a))
					for c,d in b
						Parent.AppendChild(this.CreateElement("TH",,d))
				}All:=this.XML.SelectNodes("//Window")
				while(aa:=All.Item[A_Index-1],ea1:=this.EA(aa)){
					Index:=A_Index,Parent:=Table.AppendChild(this.CreateElement("tr"))
					for a,b in Headers{
						Parent.AppendChild(TD:=this.CreateElement("td",,(b!="Height"?ea1[b]:""),,{ID:Index,Name:b}))
						if(b="Height"){
							TD.AppendChild(Check:=this.CreateElement("Input",,,,{Type:"Checkbox",ID:Index,Name:b}))
							if(ea1.Height)
								Check.SetAttribute("Checked","on")
			}}}}PP.Style.Width:="100%"
			(EA.Height)?this.Get("Window-Height").SetAttribute("Checked","On"):this.Get("Window-Height").RemoveAttribute("Checked")
			Hotkey,IfWinActive,% this.ID
			Hotkey,Tab,MsgBox-Tab,On
			Hotkey,+Tab,MsgBox-Tab,On
			MS:=this.MoveSize
			for a,b in this.Arrows
				Hotkey,%b%,%MS%,On
			this.Update("HTML Body",{OverFlow:"Auto"},1)
			WinGetPos,x,y,w,h,% this.ID
			Gui,% this.Win ":+Resize" ;" +Caption"
			WinMove,% this.ID,,% x-(this.Border)+this.Edge,,% w+(this.Border*2)-(this.Edge*2),% h+(this.Border)-(this.Edge)
			for a,b in {Title:"Window-Title",Class:"Window-Class",EXE:"Window-EXE"}
				this.Get(b).Value:=this.CurrentNode?EA[a]:this.Window[a] ;,m(this.CurrentNode?EA[a]:this.Window[a],this.Window)
			this.BackgroundColor:=(OO:=this.Elements)["HTML Body","Background-Color"],this.Color:=OO["HTML Body"].Color,this.Update("HTML Body",{"Background-Color":"Black",Color:"Grey"},1),TabOrder:=[],OrderTab:=[],Tab:=0
			for a,b in ["Window-Title","Window-Class","Window-EXE","Window-Height","Window-Pos","Window-Global"]
				TabOrder.Push(b),OrderTab[b]:=A_Index
			SetTimer,MsgBox-Tab,-1
			return
			MsgBox-Tab:
			Tab:=Round(OrderTab[CTRL.Doc.ActiveElement.ID]),Tab+=InStr(A_ThisHotkey,"+")?-1:1,Tab:=Tab<1?TabOrder.MaxIndex():Tab>TabOrder.MaxIndex()?1:Tab,CTRL.Get(TabOrder[Tab]).Focus()
			return
		}if(Node.ID="Window-Pos"||Node.ID="Window-Global"){
			Win:=this.Window,Win.Height:=this.Get("Window-Height").Checked?1:0,Win.Title:=this.Get("Window-Title").Value,Win.Class:=this.Get("Window-Class").Value,Win.EXE:=this.Get("Window-EXE").Value
			WinGetPos,x,y,w,h,% this.ID
			Gui,% this.Win ":-Resize"
			WinMove,A,,% (X:=x+this.Border-this.Edge),,% (W:=w-(this.Border*2)+(this.Edge*2)),% (H:=h-(this.Border)+(this.Edge))
			for a,b in this.Arrows
				Hotkey,%b%,Off
			(Node.Name="Global")?(Win.Pos:="Global",Win.X:=X,Win.Y:=Y,Win.W:=W,Win.H:=H):(Win.Pos:="Window",Win.X:=x-(Win.X+Win.W),Win.Y:=Y-Win.Y,Win.W:=W,Win.H:=(Win.Height?H-Win.H:H))
			if(!IsObject(this.CurrentNode))
				this.CurrentNode:=this.AddNode("Window",Win)
			for a,b in Win
				this.CurrentNode.SetAttribute(a,b)
			if(Node.Name="Global"){
				for a,b in ["Height"]
					this.CurrentNode.RemoveAttribute(b)
				this.Get("Window-Height").RemoveAttribute("checked"),OO:=this.Get("Window-Height").Checked:=0
			}this.Save()
			if(){
				if(InStr(Node.ID,"Global"))
					m("GLOBAL!")
				else
					m(Title,Class,EXE)
			}this.Set("OverAll",{Visibility:"Visible"}),this.Set("WinForm",{Visibility:"Hidden"}),this.Update("HTML Body",{"Background-Color":this.BackgroundColor,Color:this.Color},1),this.Update("HTML Body",{OverFlow:"Hidden"},1),this.Body.ScrollTop:="0px",this.Body.ScrollLeft:="0px",this.SetHotkey(1)
			return
		}else if(IsFunc(Function:=Node.ID))
			%Function%(this)
		else if(Node.ID="Close"){
			this.Response:="CloseGUI"
			Gui,% this.Win ":Hide"
		}else if(Node.NodeName="Button")
			this.Response:=Node.Name?Node.Name:Node.ID
	}Action(){
		Node:=this.Hotkeys[A_ThisHotkey]
		if(IsFunc(Function:=Node.ID))
			%Function%(this)
		else if(Node.NodeName="Button")
			this.Response:=Node.Name?Node.Name:Node.ID
	}AddButton(Buttons*){
		for a,b in Buttons{
			if(!b){
				this.SetHotkey(0),this.Buttons:=[],this.Dup:=[],this.Hotkeys:=[]
				while(aa:=this.Doc.GetElementsByTagName("Button").Item[0])
					aa.ParentNode.RemoveChild(aa)
				Continue
			}if(this.Dup[(IsObject(b)?b.Btn.Text:b)]),this.Dup[(IsObject(b)?b.Btn.Text:b)]:=1
				Continue
			New:=this.CreateElement("Button",,,this.Doc.GetElementById("Buttons")),this.Buttons.Push(New)
			if(!IsObject(b)){
				New.InnerHTML:=b,New.ID:=RegExReplace(b,"\s","_")
				Continue
			}else{
				Btn:=b.Btn,Btn.InnerHTML:=Btn.Text,Btn.Delete("Text")
				if(!Btn.ID)
					Btn.ID:=RegExReplace(Btn.InnerHTML,"\s","_")
				for c,d in Btn
					New[c]:=d
				if(b.CSS)
					this.Update(Btn.ID,b.CSS)
		}}for a,b in this.Buttons{
			b.SetAttribute("Style","Z-Index:" A_Index ";Position:Relative;")
			for c,d in StrSplit(b.InnerHTML){
				if(!this.Hotkeys[d]&&d~="\w"){
					this.Hotkeys[d]:=b,this.Hotkeys["!" d]:=b,b.InnerHTML:=(c>1?SubStr(b.InnerHTML,1,c-1):"") "<u>" SubStr(b.InnerHTML,c,1) "</u>" SubStr(b.InnerHTML,c+1)
					Break
		}}}this.SetHotkey(1)
	}AddNode(NodeName,Window){
		if(!Node:=this.FindTitle(Window))
			Node:=this.XML.DocumentElement.AppendChild(this.XML.CreateElement(NodeName))
		for a,b in Window
			Node.SetAttribute(a,b)
		return Node
	}Close(){
		Gui,% this.Win "Hide"
		this.Set("OverAll",{Visibility:"Visible"}),this.Set("WinForm",{Visibility:"Hidden"}),this.Update("HTML Body",{"Background-Color":this.BackgroundColor,Color:this.Color},1)
	}CompileTitle(ea){
		return ea.Title (ea.EXE?" ahk_exe " ea.EXE:"")(ea.Class?" ahk_class " ea.Class:"")
	}ConCat(Att,Text){
		if(!Text)
			return "@" Att "='' or not(@" Att ")"
		Text:=(InStr(Text,"'"))?RegExReplace("concat('" RegExReplace(Text,"'","'," Chr(34) "'" Chr(34) ",'") "')","('',|,'')"):"'" Text "'",Text:="contains(" Text ",@" Att ") and @" Att "!='' or @" Att "=''"
		return Text
	}CreateElement(Type,ID:="",Text:="",Parent:="",Attributes:="",CSS:=""){
		local
		New:=this.Doc.CreateElement(Type),New.ID:=ID,New.InnerText:=Text,Parent?Parent.AppendChild(New):this.Body.AppendChild(New)
		for a,b in Attributes
			New.SetAttribute(a,b)
		if(CSS&&ID)
			this.Update(ID,CSS)
		return New
	}Display(Text,AsText:=0){
		local
		this.WinInfo:={Title:Title,Class:Class,EXE:Process},this.Get("Content")[(AsText?"InnerText":"InnerHTML")]:=Text,this.Window:=this.GetWindow(),ea:=this.EA(this.FindTitle(this.Window)),this.SetHotkey(1),Win:=this.Window
		if(ea.Pos="Global")
			Pos:=(ea.X?"x" ea.X:"") (ea.Y?" y" ea.Y:"") " w" ea.W " h" ea.H
		else if(ea.W)
			Pos:=((X:=Win.X+Win.W+ea.X)?"x" X:"") ((Y:=Win.Y+ea.Y)?" y" Y:"") " w" ea.W " h" ((NH:=(ea.Height?Win.H+ea.H:ea.H))>0?NH:100)
		Owner:=this.Window.HWND
		if(Owner)
			Gui,% this.Win ":+Owner" Owner
		Gui,% this.Win ":Show",% (Pos?Pos:"xCenter yCenter w800 h300"),% this.Title
		Pos:="",this.Get("Window-Settings").Click()
		while(!this.Response)
			Sleep,200
		return this.Response,this.Response:=""
	}EA(Node){
		EA:=[],All:=Node.SelectNodes("@*")
		while(aa:=All.Item[A_Index-1])
			EA[aa.NodeName]:=aa.Text
		return EA
	}Escape(){
		this:=MsgBoxClass.Keep[this],this.Body.ScrollTop:="0px",this.Body.ScrollLeft:="0px",this.Set("OverAll",{Visibility:"Visible"}),this.Set("WinForm",{Visibility:"Hidden"}),this.Update("HTML Body",{"Background-Color":this.BackgroundColor,Color:this.Color,OverFlow:"Hidden"},1),this.Response:="GuiEscape"
		Gui,% this.Win ":Default"
		Gui,-Resize
		Gui,Hide
		if(IsFunc(Escape:="Escape"))
			%Escape%()
	}FixIE(Version=0){ ;Thanks GeekDude
		local
		static Key:="Software\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION",Versions:={7:7000,8:8888,9:9999,10:10001,11:11001}
		Version:=Versions[Version]?Versions[Version]:Version
		if(A_IsCompiled)
			ExeName:=A_ScriptName
		else
			SplitPath,A_AhkPath,ExeName
		RegRead,PreviousValue,HKCU,%Key%,%ExeName%
		if(!Version)
			RegDelete,HKCU,%Key%,%ExeName%
		else
			RegWrite,REG_DWORD,HKCU,%Key%,%ExeName%,%Version%
		return PreviousValue
	}FindTitle(Info){
		for a,b in {Title:Info.Title,Class:Info.Class,EXE:Info.EXE}
			Total.="(" this.ConCat(a,b) ") and "
		return this.XML.SelectSingleNode("//*[" Trim(Total," and ") "]")
	}Get(Control){
		return this.Doc.GetElementById(Control)
	}GetWindow(){
		WinGetTitle,Title,A
		WinGetClass,Class,A
		WinGet,HWND,ID,A
		WinGet,Process,ProcessName,A
		WinGetPos,X,Y,W,H,A
		return {Title:Title,Class:Class,EXE:Process,X:X,Y:Y,W:W,H:H,HWND:HWND}
	}Hotkey(Btn){
		for a,b in StrSplit(Btn.Text)
			if(!this.Hotkeys[b])
				return Btn,Btn.ID:=Btn.Text,Btn.Text:=(a>1?SubStr(Btn.Text,1,a-1):"") "<u>" SubStr(Btn.Text,a,1) "</u>" SubStr(Btn.Text,a+1),Btn.Hotkey:=b
		return Btn,Btn.ID:=RegExReplace(Btn.Name,"\s","_")
	}Img(Text:="",ImageLocation:="",Width:="",Height:="",FontSize:=""){
		local
		(Img:=this.Get("Img")).SRC:=ImageLocation,Img.Style.Width:=(Width?Width "px":Width),Img.Style.Height:=Height,(Icon:=this.Get("Icon")).InnerHTML:=Text
		if(FontSize)
			Icon.Style.FontSize:=FontSize "px"
		return {Img:Img,Icon:Icon}
	}MoveSize(){
		Pos:=this.WinPos()
		WinMove,% this.ID,,% (A_ThisHotkey~="\+\b(Left|Right)\b"&&!InStr(A_ThisHotkey,"!")?(Pos.X+(A_ThisHotkey="+Left"?-1:1)):""),% (A_ThisHotkey~="\b(Up|Down)\b"&&!InStr(A_ThisHotkey,"!")?Pos.Y+(A_ThisHotkey="Up"?-1:1):""),% (A_ThisHotkey~="!\b(Left|Right)\b"?(Pos.W+this.Border+(this.Edge*3)+(A_ThisHotkey="!Left"?-1:1)):""),% (A_ThisHotkey~="!\b(Up|Down)\b"?Pos.H+this.Border+this.Border-(this.Edge)+(A_ThisHotkey="!Down"?1:-1):"")
	}Obj2String(Obj,FullPath:="Blank",BottomBlank:=0){
		static String,Blank
		if(FullPath="Blank")
			FullPath:=String:=FullPath:=Blank:=""
		if(IsObject(Obj)){
			Try
				if(Obj.XML){
					if(Obj.XML.XML){
						Obj.Transform()
						return String.=FullPath "XML Object:`n" Obj[]
					}return String.=(FullPath?FullPath ".":"") Obj.XML "`n"
				}
			Try
				if(Obj.OuterHtml)
					return String.=FullPath "." Obj.OuterHtml "`n"
			Try
				for a,b in Obj{
					if(IsObject(b))
						this.Obj2String(b,FullPath "." a,BottomBlank)
					else{
						if(BottomBlank=0){
							String.=(FullPath?FullPath ".":"") a " = " b "`n"
						}else if(b!=""){
							String.=(FullPath?FullPath ".":"") "." a " = " b "`n"
						}else
							Blank.=(FullPath?FullPath ".":"") "." a " =`n"
					}
				}
			Catch
				String.=FullPath ".Unknown Object Type`n"
		}return Trim(String Blank,"`n")
	}Save(){
		if(!IsObject(XSL))
			XSL:=ComObjCreate("MSXML2.DOMDocument"),XSL.LoadXML("<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""><xsl:output method=""xml"" indent=""yes"" encoding=""UTF-8""/><xsl:template match=""@*|node()""><xsl:copy>`n<xsl:apply-templates select=""@*|node()""/><xsl:for-each select=""@*""><xsl:text></xsl:text></xsl:for-each></xsl:copy>`n</xsl:template>`n</xsl:stylesheet>"),Style:=null
		this.XML.TransformNodeToObject(XSL,this.XML),this.XML.Save(this.File)
	}Set(ID,Obj){
		local
		Style:=this.Get(ID).Style
		for a,b in Obj
			Style[a]:=b
	}SetHotkey(On:=0){
		local
		if(!On){
			for a,b in this.Hotkeys
				Hotkey,%a%,Off
			return
		}Action:=this.Action
		Hotkey,IfWinActive,% this.ID
		for a,b in this.Hotkeys
			Hotkey,%a%,%Action%,% (On?"On":"Off")
	}Shadow(OffSetX:=4,OffSetY:=4,Color:="444",Controls:="All"){
		local
		for a,Control in (Controls="All"?["Header","Buttons","ContentDiv"]:[Controls]){
			this.Doc.GetElementById(Control)
			if(Control="Header")
				for a,b in [["Header",{"Margin-Bottom":OffSetY "px","Margin-Right":OffSetX "px"}],["Header > Div",{"Box-Shadow":OffSetX " " OffSetY "px " (SubStr(Color,1,1)="#"?"":"#") Color}],["ContentDiv",{Top:this.Doc.GetElementById(Control).OffSetHeight+OffSetY "px"}],["Save-Position:Active",{"Box-Shadow":"0 0 0",Transform:"TranslateX(" OffSetX "px)TranslateY(" OffSetY "px)"}],["Close:Active",{"Box-Shadow":"0 0 0",Transform:"TranslateX(" OffSetX "px)TranslateY(" OffSetY "px)"}]]
					this.Update(b*)
			if(Control="ContentDiv")
				this.Update(Control,{"Box-Shadow":OffSetX " " OffSetY "px " (SubStr(Color,1,1)="#"?"":"#") Color,"Margin-Right":OffSetX "px"})
			if(Control="Buttons")
				for a,b in [["ContentDiv",{Bottom:Round(this.Doc.GetElementById(Control).OffSetHeight+OffSetY) "px"}],["Buttons > Button",{"Box-Shadow":OffSetX " " OffSetY "px " (SubStr(Color,1,1)="#"?"":"#") Color}],["Buttons",{"Margin-Bottom":OffSetY "px","Margin-Right":OffSetX "px"}],["Buttons > Button:Active",{"Box-Shadow":"0 0 0",Transform:"TranslateX(" OffSetX "px)TranslateY(" OffSetY "px)"}]]
					this.Update(b*)
		}
	}Size(){
		local
		global MsgBoxClass
		Pos:=(this:=MsgBoxClass.Keep[this]).WinPos()
		ControlMove,,,,% Pos.W,% Pos.H,% "ahk_id" this.IE
	}Update(Control:="",Info:="",No#:="",Dot:=""){
		if(!Control)
			return Elements
		if(!Obj:=this.Elements[Control])
			Obj:=this.Elements[Control]:=[]
		for a,b in Info
			Obj[a]:=b
		for a,b in Obj
			List.=a ":" b ";"
		if(!Update:=this.Doc.GetElementById(Control "Style"))
			Update:=this.Doc.CreateElement("Style"),Update.ID:=Control "Style",this.Doc.GetElementById("Styles").AppendChild(Update)
		Update.InnerText:=(No#?"":"#") Control "{" List "}"
	}WinPos(HWND:=""){
		WinGetPos,X,Y,W,H,% "ahk_id" (HWND?HWND:this.Main)
		VarSetCapacity(Rect,16),DllCall("GetClientRect",Ptr,(HWND?HWND:this.Main),Ptr,&Rect)
		return {X:X,Y:Y,W:NumGet(Rect,8),H:NumGet(Rect,12)}
	}
}
return
F1::
ToolTip,% m.Display("<font size='9'><b>H</b>el<font color='red'>l</font><i>o</i><font size='3'><br>Press any of the buttons to see an effect<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>Here to show the scrollbar :)")

return
+Escape::
ExitApp
return
Sound(){
	SoundBeep,500,500
	return
}
Drop(this){
	static Toggle:=0
	if(Toggle:=!Toggle)
		this.Shadow(9,4)
	else
		this.Shadow(0,0)
}
Stop(this){
	this.Img()
	(Button:=this.Get("Stop")).InnerText:="Cool Again",Button.ID:="Cool"
	SetTimer,HTMLCool,Off
}
Cool(this){
	static Object,Colors:=["Red","Purple","Green"],Index:=1,Node
	Object:=this
	(Node:=Object.Doc.GetElementById("Icon"))
	Button:=Object.Doc.GetElementById("Cool")
	Button.InnerText:="Make It Stop!"
	Button.ID:="Stop"
	this.Img("&#x2622;<br>Neahhhhhh","https://cdn68.picsart.com/191507689000201.gif",240,,40)
	SetTimer,HTMLCool,500
	return
	HTMLCool:
	Node.Style.Color:=Colors[Mod(++Index,Colors.MaxIndex())+1]
	Object.Update("Stop",{Background:Colors[Mod(Index,Colors.MaxIndex())+1]})
	return
}
Pretty_Title(this){
	static Toggle:=0
	if(Toggle:=!Toggle){
		this.Update("Title",{Background:"Linear-Gradient(90deg, Purple 0%, #ff0000 70%,Black 100%)",Border:"",Height:"20px","Line-Height":"20px"})
		this.Update("Close",{Background:"Black",Color:"White"})
		this.Update("Save-Position",{Background:"Black",Color:"White"})
	}else{
		this.Update("Title",{Background:this.Color})
		this.Update("Close",{Background:this.Color,Color:"Black"})
		this.Update("Save-Position",{Background:this.Color,Color:"Black"})
	}
}
Round_Edges(this){
	static Toggle:=0
	if(Toggle:=!Toggle){
		for a,b in ["Div","Button"]
			this.Update("OverAll " b,{"Border-Radius":"20px"})
		this.Update("ContentDiv",{Padding:"10px"})
		this.Update("Content",{"Padding-Left":"10px"})
	}else{
		for a,b in ["Div","Button"]
			this.Elements.Delete("OverAll " b),Rem:=this.Get("OverAll " b "Style"),Rem.ParentNode.RemoveChild(Rem)
		this.Elements.ContentDiv.Delete("Padding"),this.Update("ContentDiv")
		this.Elements.Content.Delete("Padding-Left"),this.Update("Content")
	}
}
Fancy(this){
	static Toggle:=1
	if(!Toggle:=!Toggle){
		Color:=(BG:=this.Elements.Content.Background)?BG:this.Elements["HTML Body"].Background
		this.Update("HTML Body",{"scrollbar-base-color":"#AAAAAA","scrollbar-3dlight-color":Color,"scrollbar-highlight-color":Color,"scrollbar-track-color":Color,"scrollbar-arrow-color":"white","scrollbar-shadow-color":Color,"scrollbar-dark-shadow-color":Color},1)
	}else{
		for a,b in ["scrollbar-base-color","scrollbar-3dlight-color","scrollbar-highlight-color","scrollbar-track-color","scrollbar-arrow-color","scrollbar-shadow-color","scrollbar-dark-shadow-color"]
			this.Elements["HTML Body"].Delete(b)
		this.Update("HTML Body",this.Elements["HTML Body"],1)
	}
}
Change_Buttons(this){
	this.AddButton(0,{Btn:{Text:"Things",Name:"This will be returned"},CSS:{Background:"Orange",Color:"Blue"}},"Sound","Show Elements")
}
This_Windows_Code(this){
	static Toggle:=1
	if(!Toggle:=!Toggle)
		m.Get("Title").InnerHTML:="This Window's Code",m.Update("Content",{OverFlow:"Auto","White-Space":"NoWrap"}),this.Get("Content").InnerText:=Pretty(this,1)
	else
		m.Get("Title").InnerHTML:=A_ScriptName,this.Get("Content").InnerHTML:="<font size='9'><b>H</b>el<font color='red'>l</font><i>o</i><font size='3'><br>Press any of the buttons to see an effect<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>Here to show the scrollbar :)"
}
Pretty(this,Return:=0){
	All:=this.Doc.All
	this.Update("Content",{OverFlow:"Auto","White-Space":"NoWrap"})
	while(aa:=All.Item[A_Index-1]){
		Parent:=aa,Tabs:=""
		while(Parent:=Parent.ParentNode){
			if(Parent.NodeName~="i)\b(document|HTML|BODY)\b")
				Break
			Tabs.=(Return?"         ":"`t")
		}
		if(aa.NodeName!="Style")
			Total.=Tabs Str:=SubStr(aa.OuterHtml,1,InStr(aa.OuterHtml,">")) "`r`n"
		else{
			Total.=Tabs Str:=SubStr(aa.OuterHtml,1,InStr(aa.OuterHtml,"</" aa.NodeName ">")+8) "`r`n"
		}
	}
	if(Return)
		return Total
	MsgBox,%Total%
}
Show_Elements(this){
	this.Get("Content").InnerText:=this.Obj2String(this.Elements)
}
m(x*){
	static List:={BTN:{OC:1,ARI:2,YNC:3,YN:4,RC:5,CTC:6},ico:{X:16,"?":32,"!":48,I:64}},Msg:=[],xx,y,w,h,XPos:=Round(A_ScreenWidth*.7825),Center:=0,TT
	static Title
	List.Title:="Right Click Menu+",List.Def:=0,List.Time:=0,Value:=0,TXT:="",Bottom:=0
	WinGetTitle,Title,A
	for a,b in x
		Obj:=StrSplit(b,":"),(Obj.1="Bottom"?(Bottom:=1):""),(VV:=List[Obj.1,Obj.2])?(Value+=VV):(List[Obj.1]!="")?(List[Obj.1]:=Obj.2):TXT.=(b.XML?b.XML:IsObject(b)?Obj2String(b,,Bottom):b) "`n"
	Msg:={option:Value+262144+(List.Def?(List.Def-1)*256:0),Title:List.Title,Time:List.Time,TXT:TXT}
	Sleep,120
	MsgBox,% Msg.option,% Msg.Title,% Msg.TXT,% Msg.Time
	for a,b in {OK:Value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
		IfMsgBox,%a%
			return b
	return
}
/*
Obj2String(Obj,FullPath:="Blank",BottomBlank:=0){
	static String,Blank
	if(FullPath="Blank")
		FullPath:=String:=FullPath:=Blank:=""
	if(IsObject(Obj)){
		Try
			if(Obj.XML){
				if(Obj.XML.XML){
					Obj.Transform()
					return String.=FullPath "XML Object:`n" Obj[]
				}return String.=(FullPath?FullPath ".":"") Obj.XML "`n"
			}
		Try
			if(Obj.OuterHtml)
				return String.=FullPath "." Obj.OuterHtml "`n"
		Try
			for a,b in Obj{
				if(IsObject(b))
					Obj2String(b,FullPath "." a,BottomBlank)
				else{
					if(BottomBlank=0){
						String.=(FullPath?FullPath ".":"") a " = " b "`n"
					}else if(b!=""){
						String.=(FullPath?FullPath ".":"") "." a " = " b "`n"
					}else
						Blank.=(FullPath?FullPath ".":"") "." a " =`n"
				}
			}
		Catch
			String.=FullPath ".Unknown Object Type`n"
	}return Trim(String Blank,"`n")
}
*/


Obj2String(Obj,FullPath:=1,BottomBlank:=0){
	static String,Blank
	if(FullPath=1)
		String:=FullPath:=Blank:=""
	if(IsObject(Obj)){
		for a,b in Obj{
			if(IsObject(b)&&!b.XML)
				Obj2String(b,FullPath "." a,BottomBlank)
			else{
				if(BottomBlank=0)
					String.=FullPath "." a " = " (b.XML?b.XML:b) "`n"
				else if(b!="")
					String.=FullPath "." a " = " (b.XML?b.XML:b) "`n"
				else
					Blank.=FullPath "." a " =`n"
			}
	}}
	return String Blank
}