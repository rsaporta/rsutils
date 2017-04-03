.rs_install_all_packages <- function() {
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

.rs_pull_all_packages <- function(
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
    catn(sprintf(" --------- ========== [ % 15s ] ========== ----------- ", pkg))
    folder <- file.path(parent_folder, pkg)
    dir.create(folder, recursive = TRUE)
    cmd <- sprintf("cd %s; git clone ")
    catn(folder)
  }
}#; .rs_pull_all_packages()
