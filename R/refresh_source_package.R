#' @export
.refresh_plotting <- function(parent_folder     = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  if (source_instead_of_devtools) {
    library(ggplot2)
    library(gridExtra)
    library(grid)
    library(scales)
  }

  pkg <- "rsuplotting"

  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
  .create_axis_functions()
}

#' @export
.refresh_general <- function(parent_folder      = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  if (exists(".Pfm", envir = globalenv(), inherits = FALSE))
      rm(".Pfm", envir = globalenv())
  if (exists("print.bytes", envir = globalenv(), inherits = FALSE))
      rm("print.bytes", envir = globalenv())

  pkg <- "rsugeneral"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
}

#' @export
.refresh_aspath <- function(parent_folder           = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  pkg <- "rsuaspath"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
}

#' @export
.refresh_db <- function(parent_folder           = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  pkg <- "rsudb"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
}

#' @export
.refresh_prophesize <- function(parent_folder           = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  pkg <- "rsuprophesize"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
}

#' @export
.refresh_consoleutils <- function(parent_folder = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  pkg <- "rsuconsoleutils"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
}

#' @export
.refresh_workspace <- function(parent_folder    = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  pkg <- "rsuworkspace"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
}

#' @export
.refresh_utils <- function(parent_folder        = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  pkg <- "rsutils"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
}

#' .refresh_rsu_pkg
#' 
#' This is a wrapper to a wrapper! hahah. calls .rsu_source_package_files()
#' 
#' Because I have gotten so use to .refresh_general() and similar, I now need a .refresh_rsu_pkg()
#' 
#' Although truthfully, I should probably just take a moment to type one for each, and the end.
#' 
#' ## TODO:  The other .refresh_.. should probably call this, no?
#' @export
.refresh_rsu_pkg <- function(pkg, parent_folder = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, helpers_devtools = TRUE, verbose = TRUE) {
  if (missing(pkg)) {
    stop("You must specificy which `pkg` to refresh\n\nHINT: .refresh_rsu_pkg() is the generic function")
  }

  stopifnot(is.character(pkg))

  stopifnot(length(pkg) == 1L)

  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, helpers_devtools = helpers_devtools, verbose = verbose)
}

#' .rsu_source_package_files
#' 
#' @export
.rsu_source_package_files <- function(
    pkg            = .rsu_pkgs_strings(only_installed=only_installed)
  , folder         = file.path(parent_folder, pkg, "R")
  , parent_folder  = .get_rsu_homeDir()
  , git_pull       = FALSE
  , only_installed = TRUE
  , document_too   = FALSE
  , diff_shown.for_documenting = verbose
  , source_instead_of_devtools = FALSE
  , helpers_devtools = TRUE
  , verbose        = TRUE
) {
  
  if (!diff_shown.for_documenting && !document_too) {
    warning("diff_shown is set to FALSE, while also NOT documenting.\nHINT:  Did you mean to also set:    document_too = TRUE")
  }

  ## trim superfluous slash at end of parent_folder, if present
  if (length(parent_folder) && nzchar(parent_folder))
    parent_folder <- gsub(pat="/$", repl="", x=parent_folder)

  ## Allow for pacakge name like "general" instead of "rsugeneral"
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
    git_pull(folder = folder)
  }

  if (document_too)
    .rsu_document_package_files(pkg = pkg, folder = folder, parent_folder = parent_folder, git_pull = FALSE, diff_shown = diff_shown.for_documenting, verbose = verbose, verbose.diff = diff_shown.for_documenting, verbose.git_cmd = FALSE)

  ## devtools method is better in that packages that call those functions will still work
  if (source_instead_of_devtools) {
    rsugeneral::sourceEntireFolder(folder, verbose=verbose)
  } else {
    devtools::load_all(path = folder, quiet = !verbose, helpers = helpers_devtools)
  }

  return(invisible(folder))
}


#' .rsu_document_package_files
#' 
#' @export
.rsu_document_package_files <- function(
    pkg                        = .rsu_pkgs_strings(only_installed=only_installed)
  , folder                     = file.path(parent_folder, pkg, "R")
  , parent_folder              = .get_rsu_homeDir()
  , git_pull                   = FALSE
  , only_installed             = TRUE
  , diff_shown                 = TRUE
  , verbose                    = TRUE
  , verbose.devtools           = verbose
  , verbose.git_cmd            = verbose
  , verbose.diff               = diff_shown && verbose
) {

  if (verbose) {
    hr <- rep("=", 78 + nchar(pkg)) %>% paste0(collapse = "") %>% paste0("\n", ., "\n")
    message("\n\n\n", hr, "----------- STARTING rsu_document_package_files for ", pkg, " (", format(Sys.time(), "%l:%M:%S %p") ,") ----------- \n")
  }

  if (!identical(verbose.diff, diff_shown))
    stop("'verbose.diff' is a synonym for 'diff_shown'. These values should be the same")

  ## trim superfluous slash at end of parent_folder, if present
  if (length(parent_folder) && nzchar(parent_folder))
    parent_folder %<>% remove_text(pat = "/$")
    # parent_folder <- gsub(pat="/$", repl="", x=parent_folder)

  ## Allow for pacakge name like "general" instead of "rsugeneral"
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
    git_pull(folder = folder, verbose = FALSE)
  }

  ## BEFORE
  if (verbose || verbose.git_cmd)
      message("\n\n*** BEFORE RUNNING document() ***       | Git Status is as follows: ")
  git_status(folder = folder, verbose.cmd = verbose.git_cmd)

  ## DURING
  if (verbose || verbose.devtools)
      message("\n\n*** RUNNING document() ***              | The below output is from devtools / oxygen: ")
  devtools::document(folder, quiet = !verbose.devtools)

  ## AFTER
  if (verbose || verbose.git_cmd)
      message("\n\n*** AFTER  RUNNING document() ***       | Git Status is as follows: ")
  git_status(folder = folder, verbose.cmd = verbose.git_cmd)


  if (verbose.diff) {
    message("\n\n*** Git Diff is now as follows ***")
    git_diff(folder = folder, verbose.cmd = TRUE)
  }

  if (verbose) {
    message(" \n\n---------- COMPLETED rsu_document_package_files for ", pkg, " (", format(Sys.time(), "%l:%M:%S %p") ,") -----------", hr, "\n\n")
  }

  return(invisible(NULL))
}

#' @export
.document_plotting <- function(parent_folder     = .get_rsu_homeDir(), git_pull = FALSE, diff_shown = TRUE, verbose = TRUE, verbose.git_cmd = TRUE, verbose.diff = diff_shown) {
  pkg <- "rsuplotting"
  .rsu_document_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, verbose = verbose, verbose.git_cmd = verbose.git_cmd, verbose.diff = verbose.diff)
}

#' @export
.document_general <- function(parent_folder      = .get_rsu_homeDir(), git_pull = FALSE, diff_shown = TRUE, verbose = TRUE, verbose.git_cmd = TRUE, verbose.diff = diff_shown) {
  pkg <- "rsugeneral"
  .rsu_document_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, verbose = verbose, verbose.git_cmd = verbose.git_cmd, verbose.diff = verbose.diff)
}

#' @export
.document_db <- function(parent_folder           = .get_rsu_homeDir(), git_pull = FALSE, diff_shown = TRUE, verbose = TRUE, verbose.git_cmd = TRUE, verbose.diff = diff_shown) {
  pkg <- "rsudb"
  .rsu_document_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, verbose = verbose, verbose.git_cmd = verbose.git_cmd, verbose.diff = verbose.diff)
}

#' @export
.document_consoleutils <- function(parent_folder = .get_rsu_homeDir(), git_pull = FALSE, diff_shown = TRUE, verbose = TRUE, verbose.git_cmd = TRUE, verbose.diff = diff_shown) {
  pkg <- "rsuconsoleutils"
  .rsu_document_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, verbose = verbose, verbose.git_cmd = verbose.git_cmd, verbose.diff = verbose.diff)
}

#' @export
.document_workspace <- function(parent_folder    = .get_rsu_homeDir(), git_pull = FALSE, diff_shown = TRUE, verbose = TRUE, verbose.git_cmd = TRUE, verbose.diff = diff_shown) {
  pkg <- "rsuworkspace"
  .rsu_document_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, verbose = verbose, verbose.git_cmd = verbose.git_cmd, verbose.diff = verbose.diff)
}

#' @export
.document_utils <- function(parent_folder        = .get_rsu_homeDir(), git_pull = FALSE, diff_shown = TRUE, verbose = TRUE, verbose.git_cmd = TRUE, verbose.diff = diff_shown) {
  pkg <- "rsutils"
  .rsu_document_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, verbose = verbose, verbose.git_cmd = verbose.git_cmd, verbose.diff = verbose.diff)
}
