#' @export
.refresh_plotting <- function(parent_folder     = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, verbose = TRUE) {
  if (source_instead_of_devtools) {
    library(ggplot2)
    library(gridExtra)
    library(grid)
    library(scales)
  }

  pkg <- "rsuplotting"

  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
  .create_axis_functions()
}

#' @export
.refresh_general <- function(parent_folder      = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, verbose = TRUE) {
  if (exists(".Pfm", envir = globalenv(), inherits = FALSE))
      rm(".Pfm", envir = globalenv())
  if (exists("print.bytes", envir = globalenv(), inherits = FALSE))
      rm("print.bytes", envir = globalenv())

  pkg <- "rsugeneral"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}

#' @export
.refresh_db <- function(parent_folder           = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsudb"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}
#' @export
.refresh_consoleutils <- function(parent_folder = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsuconsoleutils"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}

#' @export
.refresh_workspace <- function(parent_folder    = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsuworkspace"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}

#' @export
.refresh_utils <- function(parent_folder        = .get_rsu_homeDir(), git_pull = FALSE, document_too = FALSE, diff_shown.for_documenting = verbose, source_instead_of_devtools = FALSE, verbose = TRUE) {
  pkg <- "rsutils"
  .rsu_source_package_files(pkg = pkg, parent_folder = parent_folder, git_pull = git_pull, document_too = document_too, diff_shown.for_documenting = diff_shown.for_documenting, source_instead_of_devtools = source_instead_of_devtools, verbose = verbose)
}

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
    devtools::load_all(path = folder, quiet = !verbose)
  }

  return(invisible(folder))
}


#' @export
.rsu_document_package_files <- function(
    pkg                        = .rsu_pkgs_strings(only_installed=only_installed)
  , folder                     = file.path(parent_folder, pkg, "R")
  , parent_folder              = .get_rsu_homeDir()
  , git_pull                   = FALSE
  , only_installed             = TRUE
  , diff_shown                 = TRUE
  , verbose                    = TRUE
  , verbose.git_cmd            = TRUE
  , verbose.diff               = diff_shown
) {

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
  message("*** BEFORE RUNNING document()  ***    Git Status is as follows")
  git_status(folder = folder, verbose.cmd = verbose.git_cmd)

  ## DURING
  message("*** RUNNING document()  ***    below output is from devtools / oxygen")
  devtools::document(folder, quiet = !verbose)

  ## AFTER
  message("*** AFTER  RUNNING document()  ***    Git Status is as follows")
  git_status(folder = folder, verbose.cmd = verbose.git_cmd)
  if (verbose.diff)
    git_diff(folder = folder, verbose.cmd = TRUE)

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
