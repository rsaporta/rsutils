#   sudo R --vanilla -e 'require(colorout); source("~rsaporta/Development/rsutils_packages/rsutils/R/rsu_install_all_packages.R"); source("~rsaporta/Development/R_init/personal_settings_and_options.R"); .rsu_install_all_packages();'

.rsu_install_all_packages <- function(local_folder="~rsaporta/Development/rsutils_packages", pkgs=.rsu_pkgs_strings()) {
  require(devtools)
  if (!nzchar(Sys.getenv("GITHUB_PAT")))
    warning("GITHUB_PAT may not be set correctly.\n\n\tHINT:   try   source('~rsaporta/.Rprofile')\n\n")

  for (pkg in pkgs) {
    cat(sprintf(" --------- ========== [ % 15s   ] ========== ----------- \n", pkg))
    f <- file.path(local_folder, pkg)
    if (file.exists(f)) {
      cat("   |- installing locally\n")
      try({install_local(f, depen=FALSE)})
    } else {
      cat("   |- installing from GITHUB\n")
      repo <- paste0("rsaporta/", pkg)
      print(repo)
      Sys.sleep(2)
      try({install_github(f, depen=FALSE)})
    }
  }
}

.rsu_pkgs_strings <- function() {
  c(
    "rsuaspath"
  , "rsuaws"
  , "rsubitly"
  , "rsuconsoleutils"
  , "rsucurl"
  , "rsudb"
  , "rsudict"
  , "rsujesus"
  , "rsunotify"
  # , "rsuorchard"
  , "rsuplotting"
  , "rsuprophesize"
  , "rsuscrubbers"
  , "rsushiny"
  , "rsuvydia"
  , "rsuworkspace"
  , "rsuxls"
  , "rsugeneral"
  , "rsutils3"
  # , "rsutils2"
  # , "rsutils"
  )
}

.rsu_pull_all_packages <- function(parent_folder="~/Development/rsutils_packages", pkgs=.rsu_pkgs_strings() ) {

  if (file.exists("~/Development/R_init"))
    system("cd ~/Development/R_init; git pull")

  if (!file.exists(parent_folder))
    dir.create(parent_folder, recursive = TRUE)

  for (pkg in pkgs) {
    cat(sprintf(" --------- ========== [ % 15s   ] ========== ----------- \n", pkg))
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
