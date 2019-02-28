#   sudo R --vanilla -e 'options(rsunotify.NO_OPTIONS_AT_STARTUP=TRUE); require(colorout); source("~rsaporta/Development/rsutils_packages/rsutils/R/rsu_install_all_packages.R"); source("~rsaporta/Development/R_init/personal_settings_and_options.R"); .rsu_install_all_packages();'
#         OR
#   sudo R --vanilla -e 'source(\"~rsaporta/Development/rsutils_packages/rsutils/R/rsu_install_all_packages.R\"); Sys.setenv(GITHUB_PAT   = \"xxxxxxx\");  .rsu_install_all_packages();'

#' @import collectArgs
#' @import rcreds
#' @importFrom remotes install_github
#' @importFrom remotes install_local
#' @export
.rsu_install_all_packages <- function(
    local_folder                = rsutils::.get_rsu_homeDir(default = "~/Development/rsutils_packages")
  , pkgs                        = rsutils::.rsu_pkgs_strings()
  , rsutils.load_on_startup     = FALSE
  , update_public_rsaporta_pkgs = TRUE
  , public_rsaporta_pkgs        = c("rcreds", "collectArgs")
  , github                      = "auto"
  , attempt                     = 0
  , max_attempts                = 3
  , quiet_install               = FALSE
) {

  ## ------------------------------------------------------------------------------- ##
  ##                  So that we know where we are in the output
  ## ------------------------------------------------------------------------------- ##
  cat("\n\n\n")
  cat(" ------------------ STARTING .rsu_install_all_packages() ------------------ ")
  cat("\n\n\n")
  ## ------------------------------------------------------------------------------- ##

  ## BANK ANY CURRENT OPTIONS, WHICH WILL BE REPLACED
  current_options <- list()

  current_options[["notify.startup"]] <- getOption("notify.startup")
  options("notify.startup" = FALSE)

  current_options[["rsutils.installing"]] <- getOption("rsutils.installing")
  options("rsutils.installing" = TRUE)


  if (!rsutils.load_on_startup) {
    current_options[["rsutils.load_on_startup"]] <- getOption("rsutils.load_on_startup")
    options(rsutils.load_on_startup = FALSE)
  }
  
  .rsu_check_branch_is_master(parent_folder=local_folder, pkgs=pkgs, wait_on_verbose=3)

  caught <- try(force(local_folder))
  if (inherits(caught, "try-error")) {
    warning("local_folder error'd.  Will use '~/Development/rsutils_packages'")
    local_folder <- '~/Development/rsutils_packages'
  }

  if (!file.exists(local_folder))
    stop("local_folder '", local_folder, "' does not exist.")

  if (attempt > max_attempts)
    stop("TRIED ", ifelse (max_attempts==3, "THREE", max_attempts), " TIMES. SOME FAILURES REMAIN:\n\t", paste(pkgs, collapse="\n\t"))

  stopifnot(requireNamespace("remotes"))

  ## Rick's Public Packages, such as rcreds and collectArgs
  if (update_public_rsaporta_pkgs)
    pkgs <- c(public_rsaporta_pkgs, pkgs)

  if (!nzchar(Sys.getenv("GITHUB_PAT")))
    warning("GITHUB_PAT may not be set correctly.\n\n\tHINT:   try   source('~rsaporta/.Rprofile')\n\n")

  if (attempt != 0) {
    cat("\n\n\n\n")
    cat(" + ~~~ ----- ========================================================================= ------ ~~~ +\n")
    cat("                                   RE RUNNING, attempt # ", attempt, "\n")
    cat(" + ~~~ ----- ========================================================================= ------ ~~~ +\n")
    cat("\n\n")
    Sys.sleep(0.8)

    message("\n\nTrying again for packages: \n\t", paste(pkgs, collapse="\n\t"))
    Sys.sleep(1.2)
  }

  errd <- c()
  for (pkg in pkgs) {
    cat(sprintf(" --------- ========== [ % 15s   ] ========== ----------- \n", pkg))
    f <- file.path(local_folder, pkg)
    if (isTRUE(github) || !file.exists(f)) {
      cat("   |- installing from GITHUB\n")
      repo <- paste0("rsaporta/", pkg)
      caught <- try({remotes::install_github(repo, dependencies=FALSE, quiet=quiet_install)})
    } else if (file.exists(f)) {
      cat("   |- installing locally\n")
      caught <- try({remotes::install_local(f, dependencies=FALSE, quiet=quiet_install)})
    } else {
      caught <- try(stop("Could not install '", pkg, "'"), silent=TRUE)
    }

    if (inherits(caught, "try-error")) {
      errd <- c(errd, pkg)
      cat ("   |- FAILED for ", pkg, "       <~~~~~~~~~~~~~~~~  \n")
      Sys.sleep(0.8)
    }
  }

  options(current_options)

  if (length(errd))
    return(.rsu_install_all_packages(local_folder=local_folder, pkgs=errd, attempt=attempt+1))

  return(invisible(NULL))
}

#' @export
.rsu_pull_all_packages <- function(parent_folder=rsutils::.get_rsu_homeDir(default="~/Development/rsutils_packages"), pkgs=rsutils::.rsu_pkgs_strings() ) {

  try(check_git_status_of_rsutils_packages(fetch=FALSE) )

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

#' @importFrom data.table data.table
#' @export
.rsu_check_branch_is_master <- function(parent_folder=rsutils::.get_rsu_homeDir(default="~/Development/rsutils_packages"), pkgs=rsutils::.rsu_pkgs_strings(), wait_on_verbose=0, verbose="auto") {
  stopifnot(require("data.table", character.only = TRUE))

  DT.ret <- data.table(pkg = pkgs, exists = NA)
  DT.ret[, exists := file.exists(file.path(parent_folder, pkg))]
  DT.ret[, is_master := rsutils::confirm_git_branch_is_as_expected(branch="master", dir=file.path(parent_folder, pkg))]

  are_non_master   <- DT.ret[(exists), !is_master & !is.na(is_master)]
  have_no_git_repo <- DT.ret[(exists), is.na(is_master)]

  if (identical(verbose, "auto"))
    verbose <- any(are_non_master, na.rm=TRUE) || any(have_no_git_repo, na.rm=TRUE)

  if (verbose) {
    pkgs_non_master  <- DT.ret[(exists)][are_non_master]$pkg
    pkgs_no_git_repo <- DT.ret[(exists)][have_no_git_repo]$pkg
    if (all(!are_non_master & !have_no_git_repo))
      cat("All RSU packages are set to MASTER branch\n")
    if (any(have_no_git_repo))
      cat("Some RSU packages have NO GIT REPO:", paste(c("", pkgs_no_git_repo), collapse="\n\t * "), "\n\n")
    if (any(are_non_master))
      cat("Some RSU packages are not set to MASTER:", paste(c("", pkgs_non_master), collapse="\n\t * "), "\n\n")

    if (wait_on_verbose)
      Sys.sleep(wait_on_verbose)
  }

  return(invisible(DT.ret))
}

#' @importFrom utils install.packages
#' @export
.rsu_pkgs_strings <- function(only_installed=FALSE) {
  pkgs <- 
    c(
      "rsuaspath"
    , "rsubitly"
    , "rsuconsoleutils"
    , "rsucurl"
    , "rsudb"
    , "rsuaws"
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
    )

  try(expr = {
    if (only_installed) {
      ## cross reference against what is installed

      ## TWO DIFFERENT WAYS TO GET INSTALLED PACKAGES
      if (FALSE)
        installed_packages <- unlist(dir(.libPaths()), use.names=FALSE)
      else
        installed_packages <- utils::installed.packages()[, "Package"]
      
      pkgs <- intersect(pkgs, installed_packages)
    }
  })

  return(pkgs)
}


## RUN THIS MANUALLY
if (FALSE) 
{
  ## CHANGE THE PATH TO POINT TO THIS FILE
  source(paste0(parent_folder="~rsaporta/Development/rsutils_packages/rsutils/R/", file="rsu_install_all_packages.R"))

  install.packages("prophet")
  install.packages("remotes")
  remotes::install_github("RcppCore/Rcpp")
  remotes::install_github("rstats-db/DBI")
  remotes::install_github("rstats-db/RPostgres")
  remotes::install_github("rstats-db/RSQLite")
  remotes::install_github("rstats-db/RMySQL")
  try(remove.packages("rsutils"))
  .rsu_install_all_packages()


  ## GITHUB SETTINGS FOR THE PACKAGES
  if (FALSE)
  openChromeTabs(sprintf("https://github.com/rsaporta/%s/settings/collaboration", .rsu_pkgs_strings()))
}

