## ---------------------------------------------------- ##
## TO EXECUTE
## ---------------------------------------------------- ##
if (FALSE) 
{
    .last_successful_pkg <- NULL
    parent_folder <- "~/Development/rsutils_packages/"
    pkgs <-  .rsu_pkgs_strings()

    ## FOR MID-RUN CRASH
    if (!is.null(.last_successful_pkg))
      pkgs <- pkgs[seq(from=which(pkgs == .last_successful_pkg) + 1, to = length(pkgs))]

    stopifnot(check_git_status_of_rsutils_packages(add_R_init=FALSE, verbose=TRUE)[, up_to_date & branch == "master"])

    stable_version_to_make <- 1.8
    .test_run <- TRUE

    ## TODO, 
    for (pkg in pkgs) {
      rsupkg_next_version(pkg, stable_version_to_make=stable_version_to_make, next_unstable_version="auto", parent_folder=parent_folder, .test_run=.test_run)
      catheader(pkg)
    }
}
## ---------------------------------------------------- ##



rsu_get_current_version_of_pkg <- function(pkg, parent_folder="~/Development/rsutils_packages/", branch="master") {
  folder <- rsuaspath::as.path(parent_folder, pkg, expand=TRUE)
  stopifnot(getGitBranch(from_where="system", dir=folder) == branch)


  ## GRAB THE DESCRIPTION FILE
  file.description <- as.path(folder, "DESCRIPTION", expand=TRUE)
  stopifnot(file.exists(file.description))
  
  ## READ IN THE FILE
  raw <- readLines(file.description)

  ## find the line of text that contains the version info
  pat.vers <- "^Version:\\s*"
  ind.vers <- grepi(pat.vers, x=raw)
  stopifnot(length(ind.vers) > 0)
  stopifnot(ind.vers == 4)

  ## extract current version and compare against next version
  last_version <- raw[[ind.vers]] %>% removeText(pat=pat.vers)

  return(last_version)
}



rsupkg_next_version <- function(pkg, stable_version_to_make="auto", next_unstable_version="auto", parent_folder="~/Development/rsutils_packages/", branch_stable_root="stable", branch_unstable="master", branch_start_from="master", time_format = "%B %d, %Y", .test_run=TRUE) {

  if (missing(pkg))
    stop("you have to specify a pkg")

  catheader(pkg)

  folder <- rsuaspath::as.path(parent_folder, pkg, expand=TRUE)
  stopifnot(getGitBranch(from_where="system", dir=folder) == branch_start_from)

  ## VALIDATE GIT BRANCH & STATUS BEFORE STARTING
  status <- git_parse_status_text(folder=folder)
  if (!isTRUE(status$branch == branch_start_from))
    stop("branch is not '", branch_start_from, "'  (it is '", status$branch, "')")
  if (!isTRUE(status$status == "up-to-date"))
    stop("status is not up-to-date for branch '", status$branch, "' for pkg '", pkg, "'")

  ## GRAB THE DESCRIPTION FILE
  file.description <- as.path(folder, "DESCRIPTION", expand=TRUE)
  stopifnot(file.exists(file.description))
  
  ## READ IN THE FILE
  raw <- readLines(file.description)

  ## initialize emptry lists
  stable_unstable <- c("stable", "unstable")
  cmd.git_commit <- emptylist(stable_unstable)
  versinfo       <- emptylist(stable_unstable)
  desc_subline   <- emptylist(stable_unstable)

  ## ------------------------------------------------------------------------ ##

  ## ------------------------------ GET INDECIES TO VERSION & DESCRIPTION SUBTEXT ------------------------------ ##
  ## find the line of text that contains the version info
  pat.vers <- "^Version:\\s*"
  ind.vers <- grepi(pat.vers, x=raw)
  stopifnot(length(ind.vers) > 0)
  stopifnot(ind.vers == 4)

  ## find the line of text that contains the stable/unstable details
  pat.desc_subline <- "(^\\s+)Unstable development version"
  ind.desc_subline <- grepi(pat.desc_subline, x=raw)
  stopifnot(length(ind.desc_subline) > 0)
  stopifnot(ind.desc_subline %in% (7:8))
  ## ---------------------------------------------------------------------------------------------------------- ##



  ## --------------------------------------------- VERSION NUMBERS --------------------------------------------- ##
  ## extract current version and compare against next version
  last_version <- raw[[ind.vers]] %>% removeText(pat=pat.vers)

  if (stable_version_to_make == "auto") {
    last_version <- rsu_get_current_version_of_pkg(pkg=pkg, parent_folder=parent_folder, branch=branch_start_from)
    stable_version_to_make <- increment_version(last_version, what="y", by=1, y_must_be_even=TRUE)
  } else {
    stable_version_to_make %<>% .validate_and_clean_versionNumber(fail.if.not=TRUE)
  }

  if (next_unstable_version == "auto") {
    next_unstable_version <- increment_version(stable_version_to_make, what="y", by=1, y_must_be_odd=TRUE)
  } else {
    next_unstable_version %<>% .validate_and_clean_versionNumber(fail.if.not=TRUE)
  }
  ## ----------------------------------------------------------------------------------------------------------- ##


  ## ---------------------------- CONFIRM CORRECT INCREMENTATIONS  ----------------------------- ##
  is_stable_increase_from_last <- compareVersion(stable_version_to_make, last_version) == 1
  stopifnot(is_stable_increase_from_last)

  is_next_increase_from_stable <- compareVersion(next_unstable_version, stable_version_to_make) == 1
  stopifnot(is_next_increase_from_stable)

  y_is_even.stable   <- stable_version_to_make %>% splitVersionNumber() %>% "[["("y") %>% "%%"(2) %>% "=="(0)
  y_is_odd.unstable  <- next_unstable_version  %>% splitVersionNumber() %>% "[["("y") %>% "%%"(2) %>% "=="(1)

  if (!y_is_even.stable)
    stop("stable version should have an even 'y' in version number  x.y.z")
  if (!y_is_odd.unstable)
    stop("unstable version should have an odd 'y' in version number  x.y.z")
  ## ------------------------------------------------------------------------------------------- ##



  ## ---------------------------- GIT FORMATS ----------------------------- ##
  fmt.git_pull <- "cd %s && git pull"
  fmt.git_branch <- "cd %s && git branch"
  fmt.git_ck_master <- "cd %s && git checkout master"

  cmd.git_commit[["stable"]] <- sprintf(fmt='
      cd %3$s; 
      git fetch;
      git add "%4$s";
      git commit -m "Bumping to Stable version %2$s";
      git tag -a V%2$s -m "Stable Version %2$s";
      git push;
      git checkout -b %1$s/V%2$s master;
      git branch;
      git push origin %1$s/V%2$s;
      git status;
      git checkout master;
      git status;
  ', branch_stable_root, stable_version_to_make, shellClean(folder), shellClean(file.description))
  catnn(cmd.git_commit[["stable"]])

  cmd.git_commit[["unstable"]] <- sprintf(fmt='
      cd %3$s; 
      git checkout %1$s
      git add "%4$s";
      git commit -m "Bumping to Unstable version %2$s";
      git push;
      git checkout %1$s
  ', branch_unstable, next_unstable_version, shellClean(folder), shellClean(file.description))
  catnn(cmd.git_commit[["unstable"]])
  ## ---------------------------- GIT FORMATS ----------------------------- ##


  ## ------------------------------------------------------------------------ ##
  ## TWO THINGS NEED TO HAPPEN
  ## (1) update the stable version, check it in, tag it, create new branch in branch_stable_root/
  ## (2) create the next unstable version in master

  versinfo[["stable"]]   <- sprintf("Version: %s", stable_version_to_make)
  versinfo[["unstable"]] <- sprintf("Version: %s", next_unstable_version)

  desc_subline[["stable"]]   <- sprintf("    Current stable version (committed on %s)",             timeStamp(frmt=time_format))
  desc_subline[["unstable"]] <- sprintf("    Unstable development version (first committed on %s)", timeStamp(frmt=time_format))


  ## MAKE STABLE VERSION
  ## ------------------------------------------------------------------------ ##
  browser(expr=rsugeneral::inDebugMode("pkg", "nextversion"))
  for (s_u in stable_unstable) {
      cls(3)
      message("          ---------------------------------------  [", s_u, "]  ---------------------------------------")
      raw[ind.vers]         <- versinfo[[s_u]]
      raw[ind.desc_subline] <- desc_subline[[s_u]]

      # cmd <- sprintf(fmt=cmd.git_commit[[s_u]], folder, file.description)

      if (!.test_run) {
#          ## WRITE THE FILE
#          cat(raw, "\n", file=file.description, append=FALSE, sep="\n")
          ## GIT COMMIT, CHECKOUT NEW BRANCH, PUSH, ETC
          system(cmd.git_commit[[s_u]], intern=FALSE)
      } else 
      {
        message("  ....... not writing to disk, but here is the raw output .......")
        cat(raw, sep="\n")
        message(cmd.git_commit[[s_u]])
        message("  ...............................................................\n")
      }
  }
  return(TRUE)
}

#   ## MAKE UNSTABLE VERSION
#   ## ------------------------------------------------------------------------ ##
#   raw[ind.vers]         <- versinfo[["unstable"]]
#   raw[ind.desc_subline] <- desc_subline[["unstable"]]
# 
#   if (!.test_run) {
#       ## WRITE THE FILE
#       cat(raw, "\n", file=file.description, append=FALSE, sep="\n")
# 
#       ## GIT COMMIT, CHECKOUT NEW BRANCH, PUSH, ETC
#       sprintf(fmt=cmd.git_commit[["unstable"]], folder, file.description) %>% system(intern=FALSE)
#   } else {
#     message("  ....... not writing to disk, but here is the raw output .......")
#     cat(raw, sep="\n")
#     message("  ...............................................................\n")
#   }
# 
# 
# 
# }
# 
# 
#   if (update_current) {
#       if (!.test_run) {
#           ## WRITE THE FILE
#           cat(raw, "\n", file=file.description, append=FALSE, sep="\n")
# 
#           ## GIT COMMIT, CHECKOUT NEW BRANCH, PUSH, ETC
#           sprintf(cmd.git_commit[["stable"]], folder, file.description) %>% system(intern=FALSE)
#       } else {
#         message("  ....... not writing to disk, but here is the raw output .......")
#         cat(raw, sep="\n")
#         message("  ...............................................................\n")
#       }
#   } else {
#       sprintf(fmt.git_ck_master, folder) %>% system(TRUE)
#   }
# 
#   ## ---------------------------------------------------------------------------- ##
#   ## CHANGE MASTER TO SUBSEQUENT VERSION ---------------------------------------- ##
#   ## ---------------------------------------------------------------------------- ##
# 
# 
#   ## CONFIRM THAT THE CURRENT BRANCH IS MASTER
#   stopifnot(fmt.git_branch %>% sprintf(folder) %>% system(TRUE) %>% grep(pat="^\\s*\\*", value=TRUE) %>% identical("* master"))
# 
#   stopifnot(ind.curr > ind.vers)
# 
# 
#   raw[ind.vers] <- sprintf("Version: %s", vers.next)
#   raw[ind.curr] <- desc.next
# 
#   if (update_next) {
#       if (!.test_run) {
#           ## WRITE THE FILE
#           cat(raw, "\n", file=file.description, append=FALSE, sep="\n")
# 
#           ## GIT COMMIT, CHECKOUT NEW BRANCH, PUSH, ETC
#           sprintf(cmd.git_commit[["unstable"]], folder, file.description) %>% system(intern=FALSE)
#       } else {
#         message("  ....... not writing to disk, but here is the raw output .......")
#         cat(raw, sep="\n")
#         message("  ...............................................................\n")
#       }
#   }
# }
# 
