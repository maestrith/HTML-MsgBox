#SingleInstance,Force
global CSS,wb,v:=[]
m:=New MsgBoxClass(,"My Title")
m.AddButton({InnerHTML:"<u>D</u>rop Shadows",ID:"Drop"})
m.AddButton({InnerHTML:"<u>R</u>ound Edges",ID:"Edges"})
m.AddButton({InnerHTML:"<u>P</u>retty Title",ID:"Pretty"})
m.AddButton({InnerHTML:"<u>S</u>how Me Something Cool",ID:"Cool"})
m.AddButton({InnerHTML:"Fancy ScrollBar",ID:"Fancy"})
m.AddButton({InnerHTML:"<u>M</u>ake A Sound",ID:"Sound"})
m.AddButton({InnerHTML:"My Actual Response",Name:"Neat stuff man"})
SeeCode:=0
if(SeeCode)
	Response:=m.Display(RegExReplace(m.Body.OuterHtml,"<","`n<"),1)
else
	Response:=m.Display("<font size='9'><b>H</b>el<font color='red'>l</font><i>o</i><font size='3'><br>Press any of the buttons to see an effect<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>Here to show the scrollbar :)")
MsgBox,%Response%
ExitApp
return
Exit(){
	ExitApp
}
Class MsgBoxClass{
	Keep:=[]
	MM(){
		m(Clipboard:=RegExReplace(this.Body.OuterHtml,"<","`n<"))
	}
	__New(Win:="MsgBox",Title:=""){
		static
		Gui,%Win%:Destroy
		Gui,%Win%:Default
		Gui,%Win%:-Resize +HWNDMain -Caption +LabelMsgBoxClass.
		this.Title:=Title?Title:A_ScriptName
		Gui,Margin,0,0
		Ver:=this.FixIE(11)
		Gui,Add,ActiveX,w800 h400 vwb HWNDIE,mshtml
		this.Main:=Main,this.FixIE(Ver),this.Doc:=wb.Document,MsgBoxClass.Keep[Main]:=this,wb.Navigate("about:blank")
		while(wb.ReadyState!=4)
			Sleep,10
		this.Doc:=wb.Document
		wb.Doc.Body.OuterHtml:="<Body><Div ID='WinForm' Style='Visibility:hidden'></Div><Div ID='OverAll'><Div ID='Header'><Div ID='Close' UnSelectable='on'>X</Div><Div ID='Save-Position' UnSelectable='on' Class='tooltip'>S<Span Class='ToolTipText' Style='Border:2px Solid Grey'>Save The MsgBox Position</Span></Div><Div ID='Title' UnSelectable='on'>" this.Title "</Div></Div><Div ID='ContentDiv'><Div ID='Image' Style='Display:Flex;Width-0px;Flex-Direction:Column;Text-Align:Center'><img ID='Img' Style='Float:Left;Align:Center'/><p ID='Icon' Style='Float:Left;Color:Grey'/></Div><Div ID='Content'></Div></Div><Div ID='Buttons'></Div></Div><Styles ID='Styles'></Styles></Body>"
		SysGet,Border,33
		SysGet,Edge,45
		this.Border:=Border,this.Edge:=Edge,this.Body:=this.Doc.Body,this.ID:="ahk_id" Main,this.Win:=Win,this.IE:=IE,this.Doc.ParentWindow.ahk_event:=this._Event.Bind(this),this.CreateElement("Script",,"onmousedown=function(event){ahk_event('MouseDown',event);" Chr(125) ";onclick=function(event){ahk_event('OnClick',event);" "}")
		RegRead,CheckReg,HKCU\SOFTWARE\Microsoft\Windows\DWM,ColorizationColor
		Color:=SubStr(Format("{:x}",CheckReg+0),-5),this.Color:=Color?Color:"AAAAAA"
		this.Elements:={Buttons:{Position:"Absolute",Left:0,Right:0,Bottom:0,Height:"30px"}
					,Header:{Position:"Absolute",Left:0,Right:0,Top:0}
					,Content:{OverFlow:"Auto",Height:"100%",Color:"Pink",Width:"100%"}
					,"Save-Position":{"Z-Index":2,Position:"Relative",Cursor:"Hand","Text-Align":"Center",Top:0,Color:"Black",Float:"Right",Width:"30px",Height:"20px","Line-Height":"20px",Background:this.Color}
					,Close:{"Z-Index":4,Cursor:"Hand","Text-Align":"Center",Top:0,Color:"Black",Float:"Right",Right:0,Width:"30px",Height:"20px","Line-Height":"20px",Background:this.Color,Position:"Relative"}
					,Title:{"Z-Index":1,"Line-Height":"20px","Height":"20px","White-Space":"NoWrap","OverFlow":"Hidden","Text-Overflow":"Ellipsis","Text-Align":"Center",Cursor:"Move",Background:this.Color}
					,"Close:Hover":{Background:"Red","Border-Color":"Red"}
					,"Close:Active":{Background:"Pink"}
					,"Save-Position:Hover":{Background:"Blue"}
					,Buttons:{Bottom:"0px",Left:"0px",Position:"Absolute",Display:"Flex",Height:"40px"}
					,ContentDiv:{Position:"Absolute",Display:"Flex",Top:"20px",Bottom:"40px",Right:0,Left:0}
					,Img:{Width:"0px"}}
		for a,b in this.Elements
			this.Update(a,b)
		this.Update(".tooltip",{Position:"Relative",Display:"Inline-Block"},1),this.Update(".tooltip .tooltiptext",{Width:"120px","Background-Color":"Black",Color:"#FFF","Text-Align":"Center","Border-Radius":"6px",Padding:"5px",Position:"Absolute","Z-Index":"8",Top:"10px",Right:"105%",Visibility:"Hidden"},1),this.Update(".tooltip:hover .tooltiptext",{Visibility:"Visible"},1),this.Update("HTML Body",{"Background":"Black"},1)
		return this
	}_Event(Name,Event){
		local
		Node:=Event.srcElement
		if(Name="MouseDown"){
			if(Node.ID="Title"){
				Mode:=A_CoordModeMouse
				CoordMode,Mouse,Screen
				Focus:=this.Document.ActiveElement
				MouseGetPos,x,y,Win
				WinGetPos,xx,yy,w,h,% this.ID
				OffSetX:=xx-x,OffSetY:=yy-y,this.HWND:=Win,this.ID:="ahk_id" Win
				while(GetKeyState("LButton")){
					MouseGetPos,x,y
					WinMove,% this.ID,,% x+OffSetX,% y+OffSetY
					Sleep,10
				}
				SetTimer,MSGFocus,-10
				CoordMode,Mouse,%Mode%
				return
				MSGFocus:
				Focus.Focus()
				return
			}
			return
		}else if(Node.ID="Save-Position"){
			this.Get("OverAll").Style.Visibility:="Hidden"
			Form:=this.Get("WinForm")
			this.Get("WinForm").Style.Visibility:="Visible"
			if(!this.Get("Window-Title")){
				for a,b in [["Div","NotWorking","NOT WORKING YET!",Form,"",{Color:"Red","Font-Size":"40px"}],["Div","","Move and Resize this window where you want it",Form],["Div","","It will return here when the below window is Active",Form],["Div","","Window Title:",Form],["Input","Window-Title","",Form],["Div","","Window Class:",Form],["Input","Window-Class","",Form],["Div","","Window EXE:",Form],["Input","Window-EXE","",Form],["Div","","`n",Form],["Input","Window-Submit","For Above Window",Form,{Type:"Button"}],["Input","Window-Submit-Global","Global",Form,{Type:"Button"}]]
					this.CreateElement(b*)
			}
			WinGetPos,x,y,w,h,% this.ID
			Gui,% this.Win ":+Resize +Caption"
			WinMove,% this.ID,,% x-(this.Border)+this.Edge,,% w+(this.Border*2)-(this.Edge*2)+1,% h+(this.Border)-(this.Edge)+1
			for a,b in {Title:"Window-Title",Class:"Window-Class",EXE:"Window-EXE"}
				this.Get(b).Value:=this.WinInfo[a]
			this.BackgroundColor:=(OO:=this.Elements)["HTML Body","background-color"]
			this.Color:=OO["HTML Body"].Color
			this.Update("HTML Body",{"Background-Color":"Black",Color:"Grey"},1)
		}else if(SubStr(Node.ID,1,13)="Window-Submit"){
			Title:=this.Get("Window-Title").Value
			Class:=this.Get("Window-Class").Value
			EXE:=this.Get("Window-EXE").Value
			WinGetPos,x,y,w,h,% this.ID
			Gui,% this.Win ":-Caption -Resize"
			WinMove,A,,% x+this.Border-this.Edge,,% w-(this.Border*2)+(this.Edge*2)-1,% h-(this.Border)+(this.Edge)-1
			if(){
				if(InStr(Node.ID,"Global"))
					m("GLOBAL!")
				else
					m(Title,Class,EXE)
			}
			this.Get("OverAll").Style.Visibility:="Visible"
			Form:=this.Get("WinForm").ParentNode
			this.Get("WinForm").Style.Visibility:="Hidden"
			this.Update("HTML Body",{Color:this.Color},1)
			this.Update("HTML Body",{"Background-Color":this.BackgroundColor},1)
			return
		}else if(Node.ID="Close"){
			ExitApp
			Gui,% this.Win ":Hide"
		}else if(IsFunc(Function:=Node.ID))
			%Function%(this)
		else if(Node.NodeName="Button"){
			this.Response:=Node.Name?Node.Name:Node.ID
		}
	}AddButton(Values:=""){
		static Buttons:=[]
		local
		New:=this.CreateElement("Button",,,this.Doc.GetElementById("Buttons"))
		Buttons.Push(New)
		Values.ID:=RegExReplace(Values.ID,"\s","_")
		for a,b in Values
			New[a]:=b
		for a,b in Buttons
			b.SetAttribute("Style","Z-Index:" A_Index ";Position:Relative;")
		return New
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
		WinGetTitle,Title,A
		WinGetClass,Class,A
		WinGet,Process,ProcessName,A
		this.WinInfo:={Title:Title,Class:Class,EXE:Process}
		this.Get("Content")[(AsText?"InnerText":"InnerHTML")]:=Text
		Gui,% this.Win ":Show",h400,% this.Title
		while(!this.Response)
			Sleep,200
		return this.Response
	}Escape(){
		Gui,% MsgBoxClass.Keep[this].Win ":Hide"
		if(IsFunc(Exit:="Exit"))
			%Exit%()
	}FixIE(Version=0){
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
	}Get(Control){
		return this.Doc.GetElementById(Control)
	}Img(Text:="",ImageLocation:="",Width:="",Height:="",FontSize:=""){
		local
		(Element:=this.Doc.GetElementById("Img")).SRC:=ImageLocation
		Element.Style.Width:=Width
		Element.Style.Height:=Height
		(Element:=this.Doc.GetElementById("Icon")).InnerHTML:=Text
		if(FontSize)
			Element.Style.FontSize:=FontSize "px"
	}Shadow(OffSetX:=4,OffSetY:=4,Color:="444",Controls:="All"){
		local
		for a,Control in (Controls="All"?["Header","Buttons","ContentDiv"]:[Controls]){
			this.Doc.GetElementById(Control)
			if(Control="Header"){
				this.Update("Header",{"Margin-Bottom":OffSetY "px","Margin-Right":OffSetX "px"})
				this.Update("Header > Div",{"Box-Shadow":OffSetX " " OffSetY "px " (SubStr(Color,1,1)="#"?"":"#") Color})
				this.Update("ContentDiv",{Top:this.Doc.GetElementById(Control).OffSetHeight+OffSetY "px"})
				this.Update("Save-Position:Active",{"Box-Shadow":"0 0 0",Transform:"TranslateX(" OffSetX "px)TranslateY(" OffSetY "px)"})
				this.Update("Close:Active",{"Box-Shadow":"0 0 0",Transform:"TranslateX(" OffSetX "px)TranslateY(" OffSetY "px)"})
			}if(Control="ContentDiv"){
				this.Update(Control,{"Box-Shadow":OffSetX " " OffSetY "px " (SubStr(Color,1,1)="#"?"":"#") Color,"Margin-Right":OffSetX "px"})
			}if(Control="Buttons"){
				this.Update("ContentDiv",{Bottom:Round(this.Doc.GetElementById(Control).OffSetHeight+OffSetY) "px"})
				this.Update("Buttons > Button",{"Box-Shadow":OffSetX " " OffSetY "px " (SubStr(Color,1,1)="#"?"":"#") Color})
				this.Update("Buttons",{"Margin-Bottom":OffSetY "px","Margin-Right":OffSetX "px"})
				this.Update("Buttons > Button:Active",{"Box-Shadow":"0 0 0",Transform:"TranslateX(" OffSetX "px)TranslateY(" OffSetY "px)"})
			}
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
		/*
			if(InStr(Control,"HTML Body"))
				m(this.Elements["HTML Body"])
		*/
		if(!Update:=this.Doc.GetElementById(Control "Style"))
			Update:=this.Doc.CreateElement("Style"),Update.ID:=Control "Style",this.Doc.GetElementById("Styles").AppendChild(Update)
		Update.InnerText:=(No#?"":"#") Control "{" List "}"
		/*
			if(Control="Save-Position")
				m(List,Update.OuterHtml)
		*/
	}WinPos(){
		VarSetCapacity(Rect,16),DllCall("GetClientRect",Ptr,this.Main,Ptr,&Rect)
		return {w:NumGet(Rect,8),h:NumGet(Rect,12)}
	}
}
return
F1::
Gui,% m.Win ":Show"
return
+Escape::
ExitApp
return
Sound(){
	SoundBeep,500,500
	return
}
Drop(this){
	this.Shadow(9,4)
}
Stop(this){
	this.Img()
	Button:=this.Doc.GetElementById("Stop")
	Button.InnerText:="Cool Again"
	Button.ID:="Cool"
	SetTimer,HTMLCool,Off
}
Cool(this){
	static Object,Colors:=["Red","Purple","Green"],Index:=1,Node
	Object:=this
	(Node:=Object.Doc.GetElementById("Icon"))
	Button:=Object.Doc.GetElementById("Cool")
	Button.InnerText:="Make It Stop!"
	Button.ID:="Stop"
	this.Img("&#x2622;   Neahhhhhh","https://cdn68.picsart.com/191507689000201.gif",250,,40)
	SetTimer,HTMLCool,500
	return
	HTMLCool:
	Node.Style.Color:=Colors[Mod(++Index,Colors.MaxIndex())+1]
	Object.Update("Stop",{Background:Colors[Mod(Index,Colors.MaxIndex())+1]})
	return
}
Pretty(this){
	this.Update("Title",{Background:"Linear-Gradient(90deg, #000 0%, #444 15%,#ff0000 50%, #fff 100%)",Border:"",Height:"22px","Line-Height":"22px"})
}
Edges(this){
	static Toggle:=0
	if(Toggle:=!Toggle){
		for a,b in ["Div","Button"]
			this.Update("OverAll " b,{"Border-Radius":"20px"})
		this.Update("ContentDiv",{Padding:"10px"})
	}else{
		for a,b in ["Div","Button"]
			this.Elements.Delete("OverAll " b),Rem:=this.Get("OverAll " b "Style"),Rem.ParentNode.RemoveChild(Rem)
		this.Elements.ContentDiv.Delete("Padding"),this.Update("ContentDiv")
	}
}
Fancy(this){
	Color:=(BG:=this.Elements.Content.Background)?BG:this.Elements["HTML Body"].Background
	this.Update("HTML Body",{overflow:"Hidden","scrollbar-base-color":"#AAAAAA","scrollbar-3dlight-color":Color,"scrollbar-highlight-color":Color,"scrollbar-track-color":Color,"scrollbar-arrow-color":"white","scrollbar-shadow-color":Color,"scrollbar-dark-shadow-color":Color,margin:"0px"},1)
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