#' @importFrom rsugeneral extractSubfoldersFromFolder
#' @importFrom rsugeneral pasteC
#' @importFrom rsugeneral now
#' @importFrom rsugeneral verboseMsg
#' @importFrom rsugeneral removeNA
#' @importFrom rsugeneral isdir
#' @importFrom rsugeneral is_param_auto
#' @importFrom rsugeneral emptylist
#' @importFrom rsugeneral git_parse_status_text
#' @importFrom rsuaspath  as.path
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @export
check_git_status_of_rsutils_packages <- function(add_R_init=TRUE, fetch="..auto..", verbose.fetch=fetch && verbose, verbose=TRUE) {

  stopifnot( requireNamespace("rsuworkspace") )
  stopifnot( requireNamespace("rsugeneral")   )
  stopifnot( requireNamespace("rsuaspath")    )
  stopifnot( requireNamespace("data.table")   )

  main_folder <- "~/Development/rsutils_packages"

  pkg_folders <- extractSubfoldersFromFolder(folder=main_folder, pattern = "^rsu")

  if (!length(pkg_folders))
    warning("\n================================================================\n**INTERNAL ERROR**\n\tpkg_folders returned no 'rsu' folders.\n\tmain_folder = \"", main_folder, "\"\n================================================================\n")

  if (!exists("as.path", mode = "function")) {
    as.path <- file.path
  }

  try({
    if (add_R_init) {
      R_init.folder <- c("R_init" = as.path(main_folder, "../R_init/", expand=TRUE))
      if (file.exists(R_init.folder) && isdir(R_init.folder))
        pkg_folders  %<>% c(R_init.folder)
    }
  })

  if (!exists("is_param_auto", mode = "function")) {
    fetch <- FALSE
  } else if (is_param_auto(fetch)) {
    fetch_again <- FALSE
    last_fetch <- getOption("rsu.git_last_fetch", default=.origin.utc)
    fetch_again <- as.numeric(now() - last_fetch) > (2 * 60 * 60)

    fetch <- fetch_again
  }

  # verboseMsg(verbose.fetch, "will check the following packages:\n\t", pasteC(relativePath(pkg_folders, main_folder), C="\n\t"), sep="", time=FALSE)

  rets <- emptylist(pkg_folders)
  for (pkg in names(pkg_folders)) {
    ## FETCH
    if (fetch) {
      verboseMsg(verbose.fetch, "FETCHING '", pkg, "'", sep="", level.verbose = 1L, minw=75)
      pkg_folders[[pkg]] %>% escapeShell %>% sprintf(f="cd %s && git fetch") %>% system()
    }

    # cmd <- pkg_folders[[pkg]] %>% escapeShell %>% sprintf(f="cd %s && git status")
    # ret <- system(cmd, TRUE) %>% pasteC(C="\n")
    # rets[[pkg]] <- ret
    rets[[pkg]] <- pkg_folders[[pkg]] %>% 
                    escapeShell %>% 
                    sprintf(f="cd %s && git status") %>% 
                    system(TRUE) %>% 
                    pasteC(C="\n")
  }

  if (fetch)
    options("rsu.git_last_fetch" = now())


  DT.ret <- data.table(
                  pkg=names(pkg_folders)
                ## , folder=pkg_folders
                , as.data.table(rsugeneral::git_parse_status_text(txt=rets))
            )
  up_to_dates <- c("up-to-date", "up to date")
  DT.ret[, on_master  := (branch == "master")]
  DT.ret[, up_to_date := (status %in% up_to_dates & no_untracked_files & no_unstaged_changes)]
  setkey(DT.ret, status, pkg)

  if (verbose) {
    if (any(!DT.ret$up_to_date, na.rm=TRUE))
      message("\nThe following packages need to pushed or pulled (or both): ", sprintf("\n\t'%s'", DT.ret[!(up_to_date), pkg]), "\n")
    else
      message("The git status for all packages is up-to-date")

    if (any(!DT.ret$on_master, na.rm=TRUE))
      message("\nThe following packages are not on 'master': ", DT.ret[!(on_master), sprintf("\n\t'%s' (branch: \"%s\")", pkg, branch)], "\n")
  }

  if (all(DT.ret[, removeNA(up_to_date, TRUE) & no_untracked_files], na.rm=TRUE))
    return(invisible(DT.ret))
  return(DT.ret)
}



if (FALSE) {

  check_git_status_of_rsutils_packages()
  check_git_status_of_rsutils_packages(fetch = FALSE)

  ## MANUALLY
  system("cd /Users/rsaporta/Development/rsutils_packages/rsutils/  && git status", TRUE) %>% pasteC(C="\n") %>% git_parse_status_text

}
