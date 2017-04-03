.rsu_install_all_packages <- function() {

  if (!nzchar(Sys.getenv("GITHUB_PAT")))
    warning("GITHUB_PAT may not be set correctly.\n\n\tHINT:   try   source('~rsaporta/.Rprofile')\n\n")

  devtools::install_github("rsaporta/rsugeneral",       dependencies=FALSE)
  devtools::install_github("rsaporta/rsuaspath",        dependencies=FALSE)
  devtools::install_github("rsaporta/rsuaws",           dependencies=FALSE)
  devtools::install_github("rsaporta/rsubitly",         dependencies=FALSE)
  devtools::install_github("rsaporta/rsuconsoleutils",  dependencies=FALSE)
  devtools::install_github("rsaporta/rsucurl",          dependencies=FALSE)
  devtools::install_github("rsaporta/rsudb",            dependencies=FALSE)
  devtools::install_github("rsaporta/rsudict",          dependencies=FALSE)
  devtools::install_github("rsaporta/rsujesus",         dependencies=FALSE)
  devtools::install_github("rsaporta/rsunotify",        dependencies=FALSE)
  devtools::install_github("rsaporta/rsuorchard",       dependencies=FALSE)
  devtools::install_github("rsaporta/rsuplotting",      dependencies=FALSE)
  devtools::install_github("rsaporta/rsuprophesize",    dependencies=FALSE)
  devtools::install_github("rsaporta/rsuscrubbers",     dependencies=FALSE)
  devtools::install_github("rsaporta/rsushiny",         dependencies=FALSE)
  devtools::install_github("rsaporta/rsuvydia",         dependencies=FALSE)
  devtools::install_github("rsaporta/rsuworkspace",     dependencies=FALSE)
  devtools::install_github("rsaporta/rsuxls",           dependencies=FALSE)
  devtools::install_github("rsaporta/rsutils2",         dependencies=FALSE)
  devtools::install_github("rsaporta/rsutils3",         dependencies=FALSE)
}

.rsu_pull_all_packages <- function(
    parent_folder = "~/Development/rsutils_packages"
  , pkgs = 
c("rsugeneral"
, "rsuaspath"
, "rsuaws"
, "rsubitly"
, "rsuconsoleutils"
, "rsucurl"
, "rsudb"
, "rsudict"
, "rsujesus"
, "rsunotify"
, "rsuorchard"
, "rsuplotting"
, "rsuprophesize"
, "rsuscrubbers"
, "rsushiny"
, "rsuvydia"
, "rsuworkspace"
, "rsuxls"
, "rsutils"
, "rsutils2"
, "rsutils3")
    ) {

  
  if (!file.exists(parent_folder))
    dir.create(parent_folder, recursive = TRUE)

  for (pkg in pkgs) {
    catn(sprintf(" --------- ========== [ % 15s   ] ========== ----------- ", pkg))
    folder <- file.path(parent_folder, pkg)

    if (!file.exists(folder)) {
      message("cloning '", pkg, "' ")
      cmd.clone <- sprintf("cd %s; git clone git@github.com:rsaporta/%s.git", parent_folder, pkg)
      system(cmd.clone)
    }

    stopifnot(file.exists(folder))
    cmd.pull_push <- sprintf("cd %s; git pull; git push", folder)
    system(cmd.pull_push)

  }
}
