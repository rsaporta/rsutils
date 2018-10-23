#' @export
create_personal_RProfile <- function(
    file_full_path = as.path(folder, base_file_name, ext = ext)
  , folder         = "~/Development/R_init/"
  , base_file_name = "personal_settings_and_options"
  , ext            = "R"
) {


  is.character_of_length1(file_full_path, fail.if.not=TRUE)

  if (!file.exists(file_full_path))
    stop("Could not find file \n'", file_full_path, "'")

  BODY_OF_FILE <- sprintf(
"## %s
## --------------------------------------------------------------- ##


## --------------------------------------------------------------- ##
##  This file will get called by the ~/.Rprofile when sourced      ##
##  The file we use for ~/.Rprofile is shared amongst              ##
##    many users and machines, and is checked in to git            ##
##                                                                 ##
##  This file is unique to just this machine and does              ##
##     not get checked in                                          ##
## --------------------------------------------------------------- ##



## Add in your Github Personal Access Token so that you can sync from github
## --------------------------------------------------------------------------- ##
## Github Personal Access Token
Sys.setenv(GITHUB_PAT   = \"WHAT IS YOUR GITHUB PAT\")
## --------------------------------------------------------------------------- ##


## Should rsunotify send you an email on startup to let you know it's working?
## --------------------------------------------------------------------------- ##
## NOTIFY EMAIL ON STARTUP
options(notify.startup = getOption(\"notify.startup\", default=FALSE))
## --------------------------------------------------------------------------- ##
", basename(file_full_path))


  writeLines(text=BODY_OF_FILE, con=file_full_path)

  catn("
      Your personal settings file has been created.
      Make sure to edit it as you see fit

      Anything that would usually need to go to ~/.Rprofile 
       should instead go to this new file.edit

      ", file_full_path, "\n"
      )
}
