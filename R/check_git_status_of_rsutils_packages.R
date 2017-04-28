check_git_status_of_rsutils_packages <- function(verbose=TRUE) {
  main_folder <- "~/Development/rsutils_packages"

  pkg_folders <- extractSubfoldersFromFolder(folder=main_folder, pattern = "^rsu")

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
                , as.data.table(git_parse_status_text(rets))
            )
  DT.ret[, on_master  := (branch == "master")]
  DT.ret[, up_to_date := (status == "up-to-date")]
  setkey(DT.ret, status, pkg)

  if (verbose) {
    if (any(!DT.ret$up_to_date))
      message("\nThe following packages need to pushed or pulled (or both): ", sprintf("\n\t'%s'", DT.ret[!(up_to_date), pkg]), "\n")
    else
      message("The git status for all packages is up-to-date")
  }

  return(DT.ret)
}
