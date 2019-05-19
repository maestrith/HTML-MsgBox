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
m.Update("ContentDiv",{Position:"Absolute",Top:"22px",Bottom:"40px",Right:0,Left:0})
m.Update("Title",{"Z-Index":1,"Line-Height":"15px","Height":"18px","White-Space":"NoWrap","OverFlow":"Hidden","Text-Overflow":"Ellipsis","Text-Align":"Center",Cursor:"Move",Background:CheckReg,Border:"2px Solid","Border-Color":CheckReg})
m.AddButton("Button",{InnerHTML:"<u>D</u>rop Shadows",ID:"Drop"})
m.AddButton("Button",{InnerHTML:"<u>R</u>ound Edges",ID:"Edges"})
m.AddButton("Button",{InnerHTML:"<u>S</u>how Me Something Cool",ID:"Cool"})
m.AddButton("Button",{InnerHTML:"<u>M</u>ake A Sound",ID:"Sound"})
m.Update("Close",{Position:"Relative","Z-Index":4})
m.Update("Button",{"Z-Index":2,Display:"Relative"})
m.Doc.GetElementById("Content").InnerHTML:="Hell<i>o</i><br><br><br><br>There"
m.Update("Content",{"Font-Size":"200pt"})
Gui,Show,h400
Class MsgBoxClass{
	Keep:=[]
	__New(Win:="MsgBox"){
		static
		Gui,%Win%:Destroy
		Gui,%Win%:Default
		Gui,%Win%:-Resize +HWNDMain -Caption +LabelMsgBoxClass.
		Gui,Margin,0,0
		Gui,Add,ActiveX,w800 h400 vwb HWNDIE,mshtml
		wb.Navigate("about:blank")
		while(wb.ReadyState!=4)
			Sleep,100
		this.Doc:=wb.Document,MsgBoxClass.Keep[Main]:=this,wb.Navigate("about:<Body><div ID='Header'><div ID='Close' unselectable='on'>X</div><div ID='Title' unselectable='on'>" A_ScriptName "</div></div><div ID='ContentDiv'><p ID='Icon' Style='Float:Left;Color:Orange;Font-Size:84px'></p><div ID='Content'></div></div><div ID='Footer'></div><Styles ID='Styles'></Styles></Body>")
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
	}AddButton(Type,Values:=""){
		New:=this.CreateElement(Type,,,this.Doc.GetElementById("Footer"))
		for a,b in Values
			New[a]:=b
		return New
	}CreateElement(Type,ID:="",Text:="",Parent:="",Attributes:=""){
		New:=this.Doc.CreateElement(Type),New.ID:=ID,New.InnerText:=Text,Parent?Parent.AppendChild(New):this.Body.AppendChild(New)
		for a,b in Attributes
			New.SetAttribute(a,b)
		return New
	}Escape(){
		Gui,% MsgBoxClass.Keep[this].Win ":Hide"
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
	return this.Shadow(9,9)
}
Cool(this){
	static Object
	Object:=this
	SetTimer,HTMLCool,-1
	return
	HTMLCool:
	(Node:=Object.Doc.GetElementById("Icon"))
	List:=[{Msg:"&#x2614;<br><font size='5px'>Rain Soon!",Colors:["Brown","Green","Blue"]},{Msg:"&#x2622<br><font size='5px'>RUN!",Colors:["Red","Yellow"]},{Msg:"&#x2764<br><font size='5px'>Hearts!",Colors:["Red","Purple","Green"]}]
	Node.Style.TextAlign:="Center"
	for a,b in List{
		Node.InnerHtml:=b.Msg
		Loop,4
			for c,d in b.Colors{
				Node.Style.Color:=d
				Sleep,500
	}}
	return
}
Edges(this){
	for a,b in ["Close","Why","Title","ContentDiv"]
		this.Update(b,{"Border-Radius":"20px"})
	this.Update("ContentDiv",{Padding:"10px",Border:"2px Solid Grey"})
	All:=this.Doc.GetElementsByTagName("Button")
	while(aa:=All.Item[A_Index-1]){
		this.Update(aa.ID,{"Border-Radius":"20px"})
	}
}
Why(this){
	MsgBox,Because I can :)
}