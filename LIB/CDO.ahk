/*
Account	:= {email					: "email@gmail.com"
		,	smtpserver				: "smtp.gmail.com"
		,	smtpserverport			: 465
		,	sendusername			: "email@gmail.com"
		,	sendpassword			: "password"
		,	smtpauthenticate		: 1
		,	smtpusessl				: 1
		,	smtpconnectiontimeout	: 60
		,	sendusing				: 2}
*/

CDO(Account, To, Subject := "", Msg := "", Html := false, Attach := "", CC := "", BCC := "")
{
	MsgObj			:= ComObjCreate("CDO.Message")
	MsgObj.From		:= Account.email
	MsgObj.To		:= StrReplace(To, ",", ";")
	MsgObj.BCC		:= StrReplace(BCC, ",", ";")
	MsgObj.CC		:= StrReplace(CC, ",", ";")
	MsgObj.Subject	:= Subject

	If (Html)
		MsgObj.HtmlBody	:= Msg
	Else
		MsgObj.TextBody	:= Msg

	Schema	:= "http://schemas.microsoft.com/cdo/configuration/"
	Pfld	:= MsgObj.Configuration.Fields

	For Field, Value in Account
		(Field != "email") ? Pfld.Item(Schema . Field) := Value : ""
	Pfld.Update()

	Attach := StrReplace(Attach, ",", ";")
	Loop, Parse, Attach, `;, %A_Space%%A_Tab%
		MsgObj.AddAttachment(A_LoopField)
	
	MsgObj.Send()
}
