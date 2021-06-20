#' @export
.get_rsu_homeDir <- function(default="~/Development/rsutils_packages") {
  getOption("rsu.homeDir", default=default)
}


#' @export
.refresh_plotting <- function(parent_folder     = .get_rsu_homeDir(), git_pull = FALSE, source_instead_of_devtools = FALSE, verbose = TRUE) {
  if (source_instead_of_devtools) {
    library(ggplot2)
    library(gridExtra)
    library(grid)
    library(scales)
  }

  pkg <- "rsuplotting"

  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
  .create_axis_functions()
}

#' @export
.refresh_general <- function(parent_folder      = .get_rsu_homeDir(), git_pull = FALSE, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsugeneral"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}

#' @export
.refresh_db <- function(parent_folder           = .get_rsu_homeDir(), git_pull = FALSE, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsudb"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}
#' @export
.refresh_consoleutils <- function(parent_folder = .get_rsu_homeDir(), git_pull = FALSE, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsuconsoleutils"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}

#' @export
.refresh_workspace <- function(parent_folder    = .get_rsu_homeDir(), git_pull = FALSE, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsuworkspace"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}

#' @export
.refresh_utils <- function(parent_folder        = .get_rsu_homeDir(), git_pull = FALSE, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsutils"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}

#' @export
.rsu_source_package_files <- function(
    pkg            = .rsu_pkgs_strings(only_installed=only_installed)
  , folder         = file.path(parent_folder, pkg, "R")
  , parent_folder  = .get_rsu_homeDir()
  , git_pull       = FALSE
  , only_installed = TRUE
  , source_instead_of_devtools = FALSE
  , verbose        = TRUE
) {
  ## trim superfluous slash at end of parent_folder, if present
  if (length(parent_folder) && nzchar(parent_folder))
    parent_folder <- gsub(pat="/$", repl="", x=parent_folder)

  if (!missing(pkg) && length(pkg) == 1 && !grepl("^rsu", x=pkg)) {
    rsupkg <- paste0("rsu", pkg)
    if (rsupkg %in% .rsu_pkgs_strings())
      pkg <- rsupkg
  }

  if (!length(folder) || !nzchar(parent_folder)) {
    msg <- "'folder' has no length."
    if (is.null(parent_folder))
      msg <- paste0(msg, "  Additionally 'parent_folder' is NULL\n\nHINT: it's helpful to have in your ~/.Rprofile an options setting such as:\n\n    options(rsu.homeDir = '/path/to/rsutils/') ")
    stop(msg)
  }

  if (isTRUE(git_pull)) {
    folder %>% shellClean %>% sprintf(fmt="cd %s && git pull;") %>% system()
  }

  ## devtools method is better in that packages that call those functions will still work
  if (source_instead_of_devtools) {
    rsugeneral::sourceEntireFolder(folder, verbose=verbose)
  } else {
    devtools::load_all(path = folder, quiet = !verbose)
  }
}
