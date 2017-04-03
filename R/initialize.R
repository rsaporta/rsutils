# initialize.R

## gg_Helper_funcs
try(.create_axis_functions())


## NOTIFY
if (identical(Sys.info()[['sysname']], "Darwin")) {
  f.listener <- "~rsaporta/Development/rsutils/notify/RboxRelay_Parse.py"
  if (file.exists(f.listener))
    try(startListener(f.listener, verbose=FALSE))
  else
    message("DID NOT START notify-LISTENER -- could not find file '", f.listener, "'")

  rm(f.listenerzx)
}

{
  ## STARTUP TEST/WELCOME MESSAGE
  if (isTRUE(getOption("notify.startup", default=TRUE))) {
    notify(message="This is what the message will look like (120 char is a good max). The subtitle has an example of a time stamp. They are off by default, since the OS already stamps the notification. Also note that if two notifications have the same GROUP (aka ID), the latter will overwrite the older one.<EOM>", title="RSU Notify Has Loaded!  <~~  (Title)", subtitle="Congrats!   <~~ (Subtitle)", stamp.subtitle=TRUE, group="onLoad")
    turnOffStartUpMessage()
  }
}