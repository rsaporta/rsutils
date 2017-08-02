check_git_status_of_rsutils_packages <- function(add_R_init=TRUE, vydia_too=FALSE, verbose=TRUE) {
  requireNamespace("rsuworkspace")

  main_folder <- "~/Development/rsutils_packages"

  pkg_folders <- extractSubfoldersFromFolder(folder=main_folder, pattern = "^rsu")


  if (add_R_init) {
    R_init.folder <- c("R_init" = as.path(main_folder, "../R_init/", expand=TRUE))
    if (file.exists(R_init.folder) && isdir(R_init.folder))
      pkg_folders  %<>% c(R_init.folder)
  }

  if (vydia_too) {
    vydia_parent_folder <- "~/Development/"
    vydia_folders <- extractSubfoldersFromFolder(folder=vydia_parent_folder, pattern = "^vydia_")

    ## Restrict to those that have a git repo
    has_repo <- vydia_folders %>% as.path(".git") %>% file.exists()
    pkg_folders  %<>% c(vydia_folders[has_repo])
  }

  rets <- emptylist(pkg_folders)
  for (pkg in names(pkg_folders)) {
    ## FETCH
    pkg_folders[[pkg]] %>% shellClean %>% sprintf(f="cd %s && git fetch")

    # cmd <- pkg_folders[[pkg]] %>% shellClean %>% sprintf(f="cd %s && git status")
    # ret <- system(cmd, TRUE) %>% pasteC(C="\n")
    # rets[[pkg]] <- ret
    rets[[pkg]] <- pkg_folders[[pkg]] %>% 
                    shellClean %>% 
                    sprintf(f="cd %s && git status") %>% 
                    system(TRUE) %>% 
                    pasteC(C="\n")
  }


  DT.ret <- data.table(
                  pkg=names(pkg_folders)
                ## , folder=pkg_folders
                , as.data.table(rsuworkspace::git_parse_status_text(txt=rets))
            )
  DT.ret[, on_master  := (branch == "master")]
  DT.ret[, up_to_date := (status == "up-to-date" & no_untracked_files & no_unstaged_changes)]
  setkey(DT.ret, status, pkg)

  if (verbose) {
    if (any(!DT.ret$up_to_date, na.rm=TRUE))
      message("\nThe following packages need to pushed or pulled (or both): ", sprintf("\n\t'%s'", DT.ret[!(up_to_date), pkg]), "\n")
    else
      message("The git status for all packages is up-to-date")
  }

  return(DT.ret)
}



if (FALSE) {

  check_git_status_of_rsutils_packages(vydia_too=TRUE)

  system("cd /Users/rsaporta/Development/rsutils_packages/rsuvydia/ && git status", TRUE) %>% pasteC(C="\n") %>% git_parse_status_text
  system("cd /Users/rsaporta/Development/rsutils_packages/rsutils/  && git status", TRUE) %>% pasteC(C="\n") %>% git_parse_status_text

}
