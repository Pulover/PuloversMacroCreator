CDO(From := "", To := "", Subject := "", Msg := "", Atts := "", HtmlMsg := "", CC := "", BCC := "")
{
	pmsg          := ComObjCreate("CDO.Message")
	pmsg.From     := From
	pmsg.To       := To
	pmsg.BCC      := BCC   ; Blind Carbon Copy, Invisable for all, same syntax as CC
	pmsg.CC       := CC
	pmsg.Subject  := Subject

	If (HtmlMsg = "")
		;You can use either Text or HTML body like
		pmsg.TextBody    := Msg
	Elze
		pmsg.HtmlBody := HtmlMsg


	sAttach         := Atts ; can add multiple attachments, the delimiter is |

	fields := Object()
	fields.smtpserver            := "smtp.gmail.com" ; specify your SMTP server
	fields.smtpserverport        := 465 ; 25
	fields.smtpusessl            := True ; False
	fields.sendusing             := 2   ; cdoSendUsingPort
	fields.smtpauthenticate      := 1   ; cdoBasic
	fields.sendusername          := "...@gmail.com"
	fields.sendpassword          := "your_password_here"
	fields.smtpconnectiontimeout := 60
	schema := "http://schemas.microsoft.com/cdo/configuration/"


	pfld :=   pmsg.Configuration.Fields

	For field,value in fields
	   pfld.Item(schema . field) := value
	pfld.Update()

	Loop, Parse, sAttach, |, %A_Space%%A_Tab%
	  pmsg.AddAttachment(A_LoopField)
	pmsg.Send()
}
