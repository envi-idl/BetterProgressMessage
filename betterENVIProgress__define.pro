
;+
; :Description:
;    Simple function method that will return whether or not a 
;    user pressed the cancel button in ENVI.
;
;
; :Author: Zachary Norman - GitHub: znorman17
;-
function betterENVIProgress::AbortRequested
  compile_opt idl2
  return, self.ABORTABLE.abort_requested
end



;+
; :Description:
;    Simple procedure method that will close the current
;    progress message in ENVI
;
;
; :Author: Zachary Norman - GitHub: znorman17
;-
pro betterENVIProgress::Finish
  compile_opt idl2
  self.CHANNEL.Broadcast, ENVIFinishMessage(self.ABORTABLE)
end



;+
; :Description:
;    Simple procedure method that is used to set default object
;    properties in the init method.
;
;
; :Author: Zachary Norman - GitHub: znorman17
;-
pro betterENVIProgress::_Initialize
  compile_opt idl2
  
  ;set default object properties
  self.PROGRESS = 0
  self.MESSAGE = ''
  self.INIT = 0
end



;+
; :Description:
;    Init method when creating the better ENVI progress message 
;    object. This is instantiated when you call the object as 
;    a function. i.e.:
;      
;      prog = betterENVIProgress()
;
; :Params:
;    progressTitle: in, required, type=string
;      Set this required argument to a string that represents
;      the title in the progress bar when initialized.
;
;
; :Author: Zachary Norman - GitHub: znorman17
;-
function betterENVIProgress::Init, progressTitle
  compile_opt idl2
  ;on_error, 2
  
  ;get current session of ENVI
  e = envi(/CURRENT)
  if (e eq !NULL) then begin
    message, 'ENVI has not been started yet, required!'
  endif

  ;make sure we passed in a progress title
  if (progressTitle eq !NULL) then begin
    message, 'progressTitle argument was not provided, required!'
  endif

  ;initialize object properties
  self._Initialize
  self.CHANNEL = e.GetBroadCastChannel()
  self.ABORTABLE = ENVIAbortable()
  
  ; Broadcast a start message to the ENVI system
  start = ENVIStartMessage(progressTitle, self.ABORTABLE)
  self.CHANNEL.Broadcast, start
  
  return, 1
end


;+
; :Description:
;    Procedure method that will set the progress message and
;    progress percent for the current progress bar.
;
;
;
; :Params:
;    msg: in, required, type=string
;      Set this required argument to a string that represents
;      the message that is shown with the updated progress.
;    percent: in, required, type=int/long/byte, range=[0:100]
;      This required parameter is the percent (from zero to 
;      100) that will set the progress on the progress bar.
;
;
; :Author: Zachary Norman - GitHub: znorman17
;-
pro betterENVIProgress::SetProgress, msg, percent
  compile_opt idl2
  
  ;make sure we passed in our arguments
  if (msg eq !NULL) then begin
    message, 'msg not provided, required!'
  endif
  if (percent eq !NULL) then begin
    message, 'percent not provided, required!'
  endif
  
  ;make our progress message
  progress = ENVIProgressMessage(msg, round(percent), self.ABORTABLE)
  self.CHANNEL.Broadcast, progress
  
end

;+
; :Description:
;    Core object definition.
;
;
; :Author: Zachary Norman - GitHub: znorman17
;-
pro betterENVIProgress__define
  compile_opt idl2
  e = envi()
  void = {betterENVIProgress,$
    CHANNEL:e.GetBroadcastChannel(),$
    ABORTABLE: ENVIAbortable(),$
    PROGRESS: 0l,$
    MESSAGE: '',$
    INIT: 0 $
  }
end