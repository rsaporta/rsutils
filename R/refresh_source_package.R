.refresh_plotting <- function(parent_folder=getOption("rsu.homeDir"), verbose=TRUE) {
  pkg <- "rsuplotting"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, verbose=verbose)
}

.refresh_vydia <- function(parent_folder=getOption("rsu.homeDir"), verbose=TRUE) {
  pkg <- "rsuvydia"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, verbose=verbose)
}

.refresh_general <- function(parent_folder=getOption("rsu.homeDir"), verbose=TRUE) {
  pkg <- "rsugeneral"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, verbose=verbose)
}

.refresh_workspace <- function(parent_folder=getOption("rsu.homeDir"), verbose=TRUE) {
  pkg <- "rsuworkspace"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, verbose=verbose)
}

.rsu_source_package_files <- function(pkg, folder=file.path(parent_folder, pkg, "R"), parent_folder=getOption("rsu.homeDir"), verbose=TRUE) {
  ## trim superfluous slash at end of parent_folder, if present
  if (length(parent_folder) && nzchar(parent_folder))
    parent_folder <- gsub(pat="/$", repl="", x=parent_folder)

  if (!length(folder) || !nzchar(parent_folder)) {
    msg <- "'folder' has no length."
    if (is.null(parent_folder))
      msg <- paste0(msg, "  Additionally 'parent_folder' is NULL\n\nHINT: it's helpful to have in your ~/.Rprofile an options setting such as:\n\n    options(rsu.homeDir = '/path/to/rsutils/') ")
    stop(msg)
  }

  # sourceEntireFolder(folder, verbose=verbose)
  rsugeneral::sourceEntireFolder(folder, verbose=verbose)
}
