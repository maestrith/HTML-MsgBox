#SingleInstance,Force
global CSS,wb
RegRead,CheckReg,HKCU\SOFTWARE\Microsoft\Windows\DWM,ColorizationColor
Setformat,Integer,Hex
CheckReg:=CheckReg+0
StringRight,CheckReg,CheckReg,6
SetFormat,Integer,Dec
CheckReg:=CheckReg?CheckReg:"AAAAAA"
m:=New MsgBoxClass()
m.Update("Close",{"Z-Index":3,Border:"2px Solid " CheckReg,Cursor:"Hand","Text-Align":"Center",Top:0,Color:"Black",Float:"Right",Right:0,Width:"30px",Height:"18px","Line-Height":"18px",Background:CheckReg})
m.Doc.GetElementById("Header").InsertBefore(m.CreateElement("Div","Why","Y",,{UnSelectable:"On"}),m.Doc.GetElementById("Title"))
m.Update("Why",{"Z-Index":2,Position:"Relative",Border:"2px Solid " CheckReg,Cursor:"Hand","Text-Align":"Center",Top:0,Color:"Black",Float:"Right",Width:"30px",Height:"18px","Line-Height":"18px",Background:CheckReg,InnerText:"Y"})
m.Update("Close:Hover",{Background:"Red","Border-Color":"Red"})
m.Update("Close:Active",{Background:"Pink"})
m.Update("Content",{Color:"Pink"})
m.Update("Footer",{Bottom:"0px",Position:"Absolute",Display:"Flex",Height:"40px"})
m.Update("Header",{Position:"Absolute",Top:"0px",Left:"0px",Right:"0px"})
m.Update("HTML Body",{"background-color":"black"},1)
m.Update("ContentDiv",{Position:"Absolute",Display:"Flex",Top:"22px",Bottom:"40px",Right:0,Left:0})
m.Update("Title",{"Z-Index":1,"Line-Height":"15px","Height":"18px","White-Space":"NoWrap","OverFlow":"Hidden","Text-Overflow":"Ellipsis","Text-Align":"Center",Cursor:"Move",Border:"2px Solid",Background:CheckReg,"Border-Color":CheckReg})
m.AddButton("Button",{InnerHTML:"<u>D</u>rop Shadows",ID:"Drop"})
m.AddButton("Button",{InnerHTML:"<u>R</u>ound Edges",ID:"Edges"})
m.AddButton("Button",{InnerHTML:"<u>P</u>retty Title",ID:"Pretty"})
m.AddButton("Button",{InnerHTML:"<u>S</u>how Me Something Cool",ID:"Cool"})
m.AddButton("Button",{InnerHTML:"<u>M</u>ake A Sound",ID:"Sound"})
m.AddButton("Button",{InnerHTML:"My Actual Response",ID:"What I Asked For"})
m.Update("Close",{Position:"Relative","Z-Index":4})
m.Update("Button",{"Z-Index":2,Display:"Relative"})
Response:=m.Display("<font size='9'><b>H</b>el<font color='red'>l</font><i>o</i><font size='3'><br>Press any of the buttons to see an effect")
MsgBox,%Response%
ExitApp
Class MsgBoxClass{
	Keep:=[]
	__New(Win:="MsgBox"){
		static
		Gui,%Win%:Destroy
		Gui,%Win%:Default
		Gui,%Win%:-Resize +HWNDMain -Caption +LabelMsgBoxClass.
		Gui,Margin,0,0
		Ver:=this.FixIE(11)
		Gui,Add,ActiveX,w800 h400 vwb HWNDIE,mshtml
		this.FixIE(Ver)
		wb.Navigate("about:blank")
		while(wb.ReadyState!=4)
			Sleep,100
		this.Doc:=wb.Document,MsgBoxClass.Keep[Main]:=this,wb.Navigate("about:<Body><div ID='Header'><div ID='Close' unselectable='on'>X</div><div ID='Title' unselectable='on'>" A_ScriptName "</div></div><div ID='ContentDiv'><div ID='Image' Style='Display:Flex;Flex-Direction:Column;Text-Align:Center'><img ID='Img' Style='Float:Left;Align:Center'/><p ID='Icon' Style='Float:Left;Color:Grey'/></div><div ID='Content'></div></div><div ID='Footer'></div><Styles ID='Styles'></Styles></Body>")
		while(wb.ReadyState!=4)
			Sleep,10
		this.Body:=this.Doc.Body,this.ID:="ahk_id" Main,this.Win:=Win,this.IE:=IE,this.Doc.ParentWindow.ahk_event:=this._Event.Bind(this),this.CreateElement("Script",,"onmousedown=function(event){ahk_event('MouseDown',event);" Chr(125) ";onclick=function(event){ahk_event('OnClick',event);" "}")
		return this
	}_Event(Name,Event){
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
		}else if(Node.ID="Close"){
			ExitApp
			Gui,% this.Win ":Hide"
		}else if(IsFunc(Function:=Node.ID))
			%Function%(this)
		else
			this.Response:=Node.ID
	}AddButton(Type,Values:=""){
		New:=this.CreateElement(Type,,,this.Doc.GetElementById("Footer"))
		Values.ID:=RegExReplace(Values.ID,"\s","_")
		for a,b in Values
			New[a]:=b
		return New
	}CreateElement(Type,ID:="",Text:="",Parent:="",Attributes:=""){
		New:=this.Doc.CreateElement(Type),New.ID:=ID,New.InnerText:=Text,Parent?Parent.AppendChild(New):this.Body.AppendChild(New)
		for a,b in Attributes
			New.SetAttribute(a,b)
		return New
	}Display(Text){
		this.Get("Content").InnerHTML:=Text
		Gui,% this.Win ":Show",h400
		while(!this.Response)
			Sleep,100
		return this.Response
	}Escape(){
		Gui,% MsgBoxClass.Keep[this].Win ":Hide"
	}FixIE(Version=0){
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
		(Element:=this.Doc.GetElementById("Img")).SRC:=ImageLocation
		Element.Style.Width:=Width
		Element.Style.Height:=Height
		(Element:=this.Doc.GetElementById("Icon")).InnerHTML:=Text
		if(FontSize)
			Element.Style.FontSize:=FontSize "px"
	}Shadow(OffSetX:=4,OffSetY:=4,Color:="444"){
		All:=this.Doc.GetElementsByTagName("Div")
		while(aa:=All.Item[A_Index-1]){
			if(aa.ParentNode.ID="Header"){
				this.Update(aa.ID,{"Box-Shadow":OffSetX " " OffSetY "px " (SubStr(Color,1,1)="#"?"":"#") Color})
				if(aa.ID!="Title"){
					this.Update(aa.ID ":Active",{"Box-Shadow":"0 0 0",Transform:"TranslateX(" OffSetX "px)TranslateY(" OffSetY "px)","Z-Index":1})
					this.Update(aa.ID ":Hover",{Background:"Pink"})
				}
			}
		}
		this.Update("ContentDiv",{"Box-Shadow":OffSetX " " OffSetY "px " (SubStr(Color,1,1)="#"?"":"#") Color,"Margin-Top":OffSetY "px","Margin-Bottom":OffSetY*2 "px","Margin-Right":OffSetX "px"})
		this.Update("Button:Active",{"Box-Shadow":"0 0 0",Transform:"TranslateX(4px)TranslateY(4px)","Z-Index":1},1)
		this.Update("Button",{"Box-Shadow":OffSetX " " OffSetY " " (SubStr(Color,1,1)="#"?"":"#") Color},1)
		this.Update("Button:Active",{"Box-Shadow":"0 0 0","Z-Index":1,Transform:"TranslateX(" OffSetX "px)TranslateY(" OffSetY "px)"},1)
		this.Update("Footer",{"Margin-Bottom":OffSetY "px"})
		this.Update("Header",{"Margin-Right":OffSetX "px"})
	}Size(Something,W,H){
		this:=MsgBoxClass.Keep[this]
		ControlMove,,,,%W%,%H%,% "ahk_id" this.IE
	}Update(Control:="",Info:="",No#:=""){
		static Elements:={Footer:{Position:"Absolute",Left:0,Right:0,Bottom:0,Height:"30px"}
					  ,Header:{Position:"Absolute",Left:0,Right:0,Top:0}
					  ,Content:{OverFlow:"Auto",Height:"100%"}}
		if(!Control)
			return Elements
		if(!Obj:=Elements[Control])
			Obj:=Elements[Control]:=[]
		for a,b in Info
			Obj[a]:=b
		for a,b in Obj
			List.=a ":" b ";"
		if(!Update:=this.Doc.GetElementById(Control "Style"))
			Update:=this.Doc.CreateElement("Style"),Update.ID:=Control "Style",this.Doc.GetElementById("Styles").AppendChild(Update)
		Update.InnerText:=(No#?"":"#") Control "{" List "}"
		/*
			if(InStr(Control," "))
				m(Update.OuterHtml)
		*/
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
	return this.Shadow(4,5)
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
	for a,b in ["Close","Why","Title","ContentDiv"]
		this.Update(b,{"Border-Radius":"20px"})
	this.Update("ContentDiv",{Padding:"10px",Border:"2px Solid Grey"})
	this.Update("Button",{"Border-Radius":"20px"},1)
	/*
		All:=this.Doc.GetElementsByTagName("Button")
		while(aa:=All.Item[A_Index-1])
			this.Update(aa.ID,{"Border-Radius":"20px"})
	*/
}
Why(this){
	MsgBox,Because I can :)
}