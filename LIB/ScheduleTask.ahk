;###########################################################
; Create a scheduled task natively [AHK_L]
; Original by shajul
; http://www.autohotkey.com/board/topic/61042-create-a-scheduled-task-natively-ahk-l/
;###########################################################
ScheduleTask(TriggerType, startTime, Path, Args, Name)
{
	; TriggerType := 1    ; specifies a time-based trigger.
	ActionTypeExec := 0    ; specifies an executable action.
	LogonType := 3   ; Set the logon type to interactive logon
	TaskCreateOrUpdate = 6
	;********************************************************
	; Create the TaskService object.
	service := ComObjCreate("Schedule.Service")
	service.Connect()
	;********************************************************
	; Get a folder to create a task definition in. 
	rootFolder := service.GetFolder("\")
	; The taskDefinition variable is the TaskDefinition object.
	; The flags parameter is 0 because it is not supported.
	taskDefinition := service.NewTask(0) 
	;********************************************************
	; Define information about the task.
	; Set the registration info for the task by 
	; creating the RegistrationInfo object.
	regInfo := taskDefinition.RegistrationInfo
	; regInfo.Description := "Start notepad at a certain time"
	; regInfo.Author := "shajul"
	;********************************************************
	; Set the principal for the task
	principal := taskDefinition.Principal
	principal.LogonType := LogonType  ; Set the logon type to interactive logon
	; Set the task setting info for the Task Scheduler by
	; creating a TaskSettings object.
	settings := taskDefinition.Settings
	settings.Enabled := True
	settings.StartWhenAvailable := True
	settings.Hidden := False
	;********************************************************
	; Create a time-based trigger.
	triggers := taskDefinition.Triggers
	trigger := triggers.Create(TriggerType)
	If (TriggerType = 3)
	{
		Time := 1
		FormatTime, WTime, startTime, WDay
		Loop, % WTime - 1
			Time := Time + Time
		trigger.DaysOfWeek := Time
	}
	If (TriggerType = 4)
	{
		Time := 1
		FormatTime, MTime, startTime, d
		Loop, % MTime - 1
			Time := Time + Time
		trigger.DaysOfMonth := Time
	}
	; Trigger variables that define when the trigger is active.
	trigger.StartBoundary := startTime
	trigger.Id := "TimeTriggerId"
	trigger.Enabled := True
	;***********************************************************
	; Create the action for the task to execute.
	; Add an action to the task to run notepad.exe.
	Action := taskDefinition.Actions.Create(ActionTypeExec)
	Action.Path := Path
	Action.Arguments := Args
	;***********************************************************
	; Register (create) the task.
	rootFolder.RegisterTaskDefinition(Name " - PMC Macro", taskDefinition, TaskCreateOrUpdate ,"","", 3)
}
