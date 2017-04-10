#   sudo R --vanilla -e 'require(colorout); source("~rsaporta/Development/rsutils_packages/rsutils/R/rsu_install_all_packages.R"); source("~rsaporta/Development/R_init/personal_settings_and_options.R"); .rsu_install_all_packages();'

.rsu_install_all_packages <- function(local_folder="~rsaporta/Development/rsutils_packages", pkgs=.rsu_pkgs_strings(), attempt=0) {
  require(devtools)
  if (!nzchar(Sys.getenv("GITHUB_PAT")))
    warning("GITHUB_PAT may not be set correctly.\n\n\tHINT:   try   source('~rsaporta/.Rprofile')\n\n")

  if (attempt != 0) {
    cat("\n\n\n\n")
    cat(" + ~~~ ----- ========================================================================= ------ ~~~ +\n")
    cat("                                   RE RUNNING, attempt # ", attempt, "\n")
    cat(" + ~~~ ----- ========================================================================= ------ ~~~ +\n")
    cat("\n\n")
    Sys.sleep(0.8)

    if (attempt > 4)
      stop("TRIED FOUR TIMES. SOME FAILURES REMAIN:\n\t", paste(pkgs, collapse="\n\t"))
    message("\n\nTrying again for packages: \n\t", paste(pkgs, collapse="\n\t"))
    Sys.sleep(1.2)
  }

  errd <- c()
  for (pkg in pkgs) {
    cat(sprintf(" --------- ========== [ % 15s   ] ========== ----------- \n", pkg))
    f <- file.path(local_folder, pkg)
    if (file.exists(f)) {
      cat("   |- installing locally\n")
      caught <- try({install_local(f, depen=FALSE)})
    } else {
      cat("   |- installing from GITHUB\n")
      repo <- paste0("rsaporta/", pkg)
      caught <- try({install_github(repo, depen=FALSE)})
    }

    if (inherits(caught, "try-error")) {
      errd <- c(errd, pkg)
      cat ("   |- FAILED for ", pkg, "       <~~~~~~~~~~~~~~~~  \n")
      Sys.sleep(0.8)
    }
  }

  if (length(errd))
    return(.rsu_install_all_packages(local_folder=local_folder, pkgs=errd, attempt=attempt+1))

  return(invisible(NULL))
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
  , "rsuplotting"
  , "rsuprophesize"
  , "rsuscrubbers"
  , "rsushiny"
  , "rsuvydia"
  , "rsuworkspace"
  , "rsuxls"
  , "rsugeneral"
  , "rsutils"

  # ------- NOT USED --------------- #
  # , "rsuorchard"
  # , "rsutils2"
  # , "rsutils3"
  )
}


## RUN THIS MANUALLY
if (FALSE) 
{
  ## CHANGE THE PATH TO POINT TO THIS FILE
  source(paste0(parent_folder="~rsaporta/Development/rsutils_packages/rsutils/R/", file="rsu_install_all_packages.R"))

  install.packages("prophet")
  install.packages("devtools")
  devtools::install_github("RcppCore/Rcpp")
  devtools::install_github("rstats-db/DBI")
  devtools::install_github("rstats-db/RPostgres")
  devtools::install_github("rstats-db/RSQLite")
  devtools::install_github("rstats-db/RMySQL")
  try(remove.packages("rsutils"))
  .rsu_install_all_packages()
}

