.refresh_plotting <- function(parent_folder=getOption("rsu.homeDir"), git_pull=FALSE, verbose=TRUE) {
  pkg <- "rsuplotting"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, git_pull=git_pull, verbose=verbose)
  .create_axis_functions()
}

.refresh_vydia <- function(parent_folder=getOption("rsu.homeDir"), git_pull=FALSE, verbose=TRUE) {
  pkg <- "rsuvydia"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, git_pull=git_pull, verbose=verbose)
}

.refresh_general <- function(parent_folder=getOption("rsu.homeDir"), git_pull=FALSE, verbose=TRUE) {
  pkg <- "rsugeneral"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, git_pull=git_pull, verbose=verbose)
}

.refresh_dict <- function(parent_folder=getOption("rsu.homeDir"), git_pull=FALSE, verbose=TRUE) {
  pkg <- "rsudict"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, git_pull=git_pull, verbose=verbose)
}
.refresh_db <- function(parent_folder=getOption("rsu.homeDir"), git_pull=FALSE, verbose=TRUE) {
  pkg <- "rsudb"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, git_pull=git_pull, verbose=verbose)
}
.refresh_consoleutils <- function(parent_folder=getOption("rsu.homeDir"), git_pull=FALSE, verbose=TRUE) {
  pkg <- "rsuconsoleutils"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, git_pull=git_pull, verbose=verbose)
}

.refresh_workspace <- function(parent_folder=getOption("rsu.homeDir"), git_pull=FALSE, verbose=TRUE) {
  pkg <- "rsuworkspace"
  .rsu_source_package_files(pkg=pkg, parent_folder=parent_folder, git_pull=git_pull, verbose=verbose)
}

.rsu_source_package_files <- function(pkg, folder=file.path(parent_folder, pkg, "R"), parent_folder=getOption("rsu.homeDir"), git_pull=FALSE, verbose=TRUE) {
  ## trim superfluous slash at end of parent_folder, if present
  if (length(parent_folder) && nzchar(parent_folder))
    parent_folder <- gsub(pat="/$", repl="", x=parent_folder)

  if (!length(folder) || !nzchar(parent_folder)) {
    msg <- "'folder' has no length."
    if (is.null(parent_folder))
      msg <- paste0(msg, "  Additionally 'parent_folder' is NULL\n\nHINT: it's helpful to have in your ~/.Rprofile an options setting such as:\n\n    options(rsu.homeDir = '/path/to/rsutils/') ")
    stop(msg)
  }

  if (isTRUE(git_pull)) {
    folder %>% shellClean %>% sprintf(fmt="cd %s && git pull;") %>% system()
  }

  # sourceEntireFolder(folder, verbose=verbose)
  rsugeneral::sourceEntireFolder(folder, verbose=verbose)
}
