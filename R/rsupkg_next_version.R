## ---------------------------------------------------- ##
## ==================================================== ##
##                                                      ##
##     USE THIS                                         ##
##     TO EXECUTE                                       ##
##                                                      ##
##     But ** READ THE INSTRUCTIONS BELOW FIRST **      ##
##                                                      ##
##                                                      ##
## ==================================================== ##
## ---------------------------------------------------- ##

if (FALSE) 
{

    # |  &&& TODO BEFORE RUNNING: 
    # |  &&&   0. Make sure all packages are on Master:   check_git_status_of_rsutils_packages(f=TRUE)
    # |  &&&   1. change the  `stable_version_to_make`  number  
    # |  &&&   2. run once, it will be a test.  
    # |  &&&   3. change the  `.test_run`    and re-run
    # |  &&&   4. comment this out :) 


    ## PARAMS --------------------------------
    if (FALSE) {
      ## You can try this.... 
      stable_version_to_make <- "auto"  ## make sure it's quoted
      what_to_increment <- "x"           ## "x", "y", or "z"

      ## ... or this:
      stable_version_to_make <- "6.06.0"  ## make sure it's quoted
      what_to_increment <- "y"           ## "x", "y", or "z"
    }

    ## ... or this:
    what_to_increment <- "z"


    .test_run <- TRUE # FALSE
    # .test_run <- FALSE
    document <- FALSE ## Whether to update the ROxygen Documents -- note: for this to work, all functions must be marked as `#' @export` as necessary

    ## PARAMS --------------------------------
    ## ---------------------------------------



    ## LESS FREQUENTLY MODIFIED PACKAGES SHOULD NOT BE UPDATED AS OFTEN
    pkgs_not_to_update <- c("rsubitly", "rsucurl", "rsunotify", "rsuprophesize", "rsuscrubbers", "rsuorchard", "rsuvydia")

    #| ## To update the packages that we generally do not update, run this.
    #| pkgs_not_to_update %<>% setdiff(.rsu_pkgs_strings(), .) %>% setdiff("rsuorchard")

    .last_successful_pkg <- NULL
    parent_folder <- "~/Development/rsutils_packages/"
    pkgs <-  .rsu_pkgs_strings() %>% setdiff(pkgs_not_to_update)
    stopifnot(length(pkgs) > 0)

    ## FOR MID-RUN CRASH
    if (!is.null(.last_successful_pkg))
      pkgs <- pkgs[seq(from=which(pkgs == .last_successful_pkg) + 1, to = length(pkgs))]

    stopifnot(check_git_status_of_rsutils_packages(add_R_init=FALSE, fetch=FALSE, verbose=TRUE)[pkg %in% pkgs][, (up_to_date | pkg == "rsutils") & branch == "master" & no_untracked_files])

    ## TODO, 
    for (pkg in pkgs) {
      # rsupkg_next_version(pkg, stable_version_to_make=stable_version_to_make, next_unstable_version="auto", what_to_increment=what_to_increment, parent_folder=parent_folder, document=document, .test_run=.test_run, verbose_raw=FALSE)
      rsupkg_next_version(pkg, next_unstable_version="auto", what_to_increment="z", parent_folder=parent_folder, document=document, .test_run=.test_run, verbose_raw=FALSE)
      catheader(sprintf(fmt = "  ⬆️⬆️  %s  ⬆️⬆️ ", pkg), prel = 0L, endl = 4)
      Sys.sleep(1L * .test_run * interactive())
    }

    ## Output the remotes install commands
    if (!.test_run && exists("stable_version_to_make")) {
      pkgs %>% sprintf(fmt='"rsaporta/%s", ') %>% sprintf(fmt='remotes::install_github(%-30s ref="stable/V%s", dependencies=FALSE)', stable_version_to_make) %>% catnn("\n\n```", ., "```\n")
    }
}
## ---------------------------------------------------- ##



#' @export
rsu_get_current_version_of_pkg <- function(pkg, parent_folder="~/Development/rsutils_packages/", branch="master") {
  folder <- rsuaspath::as.path(parent_folder, pkg, expand=TRUE)
  confirm_git_branch_is_as_expected(branch_expected=branch, directory_to_check=folder, fail.if.not=TRUE)


  ## GRAB THE DESCRIPTION FILE
  file.description <- as.path(folder, "DESCRIPTION", expand=TRUE)
  stopifnot(file.exists(file.description))
  
  ## READ IN THE FILE
  raw <- readLines(file.description)

  ## find the line of text that contains the version info
  pat.vers <- "^Version:\\s*"
  ind.vers <- grepi(pat.vers, x=raw)
  stopifnot(length(ind.vers) > 0)
  stopifnot(ind.vers == 3)

  ## extract current version and compare against next version
  last_version <- raw[[ind.vers]] %>% removeText(pat=pat.vers)

  return(last_version)
}


#' @importFrom rsugeneral git_parse_status_text
#' @importFrom rsugeneral shellClean
#' @importFrom rsuaspath  as.path
#' @export
rsupkg_next_version <- function(
    pkg
  , stable_version_to_make = "auto"
  , next_unstable_version  = "auto"
  , what_to_increment      = c("y", "z", "x")
  , unstable_only          = !(what_to_increment %in% c("x", "y")) 
  , parent_folder          = paste0("~/Development/", ifelse(grepli("^rsu", pkg), "rsutils_packages/", "rpkgs/"))
  , branch_stable_root     = "stable"
  , branch_unstable        = "master"
  , branch_start_from      = "master"
  , time_format            = "%B %d, %Y"
  , document               = FALSE
  , .test_run              = TRUE
  , verbose_raw            = FALSE
) {

  ## needs shellClean from rsugeneral
  stopifnot(exists("shellClean", mode="function"))

  ## what_to_increment should be one of x.y.z
  what_to_increment <- match.arg(what_to_increment)
  force(unstable_only)

  if (missing(pkg))
    stop("you have to specify a pkg")

  catheader(pkg)
  if (unstable_only)
    message("Will only increment the Unstable version.")

  rsugeneral::is.character_of_length1(stable_version_to_make, fail.if.not = TRUE)
  rsugeneral::is.character_of_length1(next_unstable_version, fail.if.not = TRUE)
#|  if ((stable_version_to_make != "auto") && next_unstable_version == "auto")
#|    warning("REMINDER:  When only 'unstable' is set to AUTO (and not 'stable'), we will **NOT** bump the Unstable version")


  folder <- rsuaspath::as.path(parent_folder, pkg, expand=TRUE)
  confirm_git_branch_is_as_expected(branch_expected=branch_start_from, directory_to_check=folder, fail.if.not=TRUE)

  ## VALIDATE GIT BRANCH & STATUS BEFORE STARTING
  status <- rsugeneral::git_parse_status_text(folder=folder)
  if (!isTRUE(status$branch == branch_start_from))
    stop("branch is not '", branch_start_from, "'  (it is '", status$branch, "')")
  if (!isTRUE(status$status == "up-to-date"))
    stop("status is not up-to-date for branch '", status$branch, "' for pkg '", pkg, "'\n\n   HINT:   Are there uncommited changes?")


  ## ADD DOCUMENTS
  if (document && !.test_run) {
    devtools::document(folder)
    rsugeneral::git_add_A(folder=folder, verbose.cmd = TRUE)
    rsugeneral::git_commit("roxygen documents", folder=folder, verbose.cmd = TRUE)
  }


  ## GRAB THE DESCRIPTION FILE
  file.description <- as.path(folder, "DESCRIPTION", expand=TRUE)
  stopifnot(file.exists(file.description))
  
  ## READ IN THE FILE
  raw <- readLines(file.description)

  ## initialize empty lists
  stable_unstable <- if (!unstable_only) c("stable", "unstable") else c("unstable")
  cmd.git_commit <- emptylist(stable_unstable)
  versinfo       <- emptylist(stable_unstable)
  desc_subline   <- emptylist(stable_unstable)

  ## ------------------------------------------------------------------------ ##

  ## ------------------------------ GET INDECIES TO VERSION & DESCRIPTION SUBTEXT ------------------------------ ##
  ## find the line of text that contains the version info
  pat.vers <- "^Version:\\s*"
  ind.vers <- grepi(pat.vers, x=raw)
  stopifnot(length(ind.vers) > 0)
  stopifnot(ind.vers == 3)

  ## find the line of text that contains the stable/unstable details
  pat.desc_subline <- "(^\\s+)Unstable development version"
  ind.desc_subline <- grepi(pat.desc_subline, x=raw)
  stopifnot(length(ind.desc_subline) > 0)
  # stopifnot(ind.desc_subline %in% (6:8))
  ## ---------------------------------------------------------------------------------------------------------- ##



  ## --------------------------------------------- VERSION NUMBERS --------------------------------------------- ##
  ## extract current version and compare against next version
  last_version <- raw[[ind.vers]] %>% removeText(pat=pat.vers)

  ## UPDATE 2023-04-29
  ## If only incrementing "z", then that is just "unstable" version bump.
  if (!unstable_only) {
    if (stable_version_to_make == "auto") {
      last_version <- rsu_get_current_version_of_pkg(pkg = pkg, parent_folder = parent_folder, branch = branch_start_from)
      stable_version_to_make <- last_version %>% increment_version(what = what_to_increment, by = 1, y_must_be_even = TRUE)
    } else {
      stable_version_to_make %<>% .validate_and_clean_versionNumber(fail.if.not = TRUE)
    }
  
    if (next_unstable_version == "auto") {
      next_unstable_version <- stable_version_to_make %>% increment_version(what = "y", by = 1, y_must_be_odd = TRUE)
    } else {
      next_unstable_version %<>% .validate_and_clean_versionNumber(fail.if.not = TRUE)
    }
  } else {
    if (next_unstable_version == "auto") {
      last_version <- rsu_get_current_version_of_pkg(pkg = pkg, parent_folder = parent_folder, branch = branch_start_from)
      next_unstable_version <- last_version %>% increment_version(what = what_to_increment, by = 1, y_must_be_odd = TRUE)
    } else {
      next_unstable_version %<>% .validate_and_clean_versionNumber(fail.if.not = TRUE)
    }
  }
  ## ----------------------------------------------------------------------------------------------------------- ##


  ## ---------------------------- CONFIRM CORRECT INCREMENTATIONS  ----------------------------- ##
  if (! unstable_only) {
    ## CHECKS STABLE RELATIVE TO LAST **and** UNSTABLE RELATIVE TO STABLE
    y_is_even.stable   <- stable_version_to_make %>% splitVersionNumber() %>% {.[["y"]] %% 2 == 0}
    if (!y_is_even.stable)
      stop("stable version should have an even 'y' in version number  x.y.z")

    is_stable_increase_from_last <- compareVersion(stable_version_to_make, last_version) == 1
    if (!is_stable_increase_from_last) {
      stop("
         ---- Cannot proceed ------------------------------------------------
                            PACKAGE:  ", pkg, "
                    last_version is:  ", last_version, "
          stable_version_to_make is:  ", stable_version_to_make, "
          WRONG DIRECTION
         --------------------------------------------------------------------     ")
    }

    is_unstable_increase_from_stable <- compareVersion(next_unstable_version, stable_version_to_make) == 1
    if (!is_unstable_increase_from_stable) {
      stop("
         ---- Cannot proceed ------------------------------------------------
                            PACKAGE:  ", pkg, "
          stable_version_to_make is:  ", stable_version_to_make, "
           next_unstable_version is:  ", next_unstable_version, "
          WRONG DIRECTION
         --------------------------------------------------------------------     ")
    }

  } #// closes if !unstable_only

  ## CHECKS UNSTABLE RELATIVE TO LAST
  y_is_odd.unstable  <- next_unstable_version  %>% splitVersionNumber() %>% {.[["y"]] %% 2 == 1}
  if (!y_is_odd.unstable)
    stop("unstable version should have an odd 'y' in version number  x.y.z")

  is_unstable_increase_from_last <- compareVersion(next_unstable_version, last_version) == 1
  if (!is_unstable_increase_from_last) {
    stop("
       ---- Cannot proceed ------------------------------------------------
                          PACKAGE:  ", pkg, "
                  last_version is:  ", last_version, "
         next_unstable_version is:  ", next_unstable_version, "
        WRONG DIRECTION
       --------------------------------------------------------------------     ")
  }



  ## ------------------------------------------------------------------------------------------- ##

  ## ---------------------------- GIT FORMATS ----------------------------- ##
  fmt.git_pull <- "cd %s && git pull"
  fmt.git_branch <- "cd %s && git branch"
  fmt.git_ck_master <- "cd %s && git checkout master"

  if (!unstable_only) {
    cmd.git_commit[["stable"]] <- sprintf(fmt='
        cd %3$s;
        git fetch;
        git add "%4$s";
        git commit -m "Bumping to Stable version %2$s";
        git tag -a V%2$s -m "Stable Version %2$s";
        git push;
        git checkout -b %1$s/V%2$s master;
        git branch;
        git push --set-upstream origin %1$s/V%2$s;
        git status;
        git checkout master;
        git status;
    ', branch_stable_root, stable_version_to_make, shellClean(folder), shellClean(file.description))
    message("Will execute the following git command for the stable version")
    catnn(cmd.git_commit[["stable"]])
  }

  cmd.git_commit[["unstable"]] <- sprintf(fmt='
      cd %3$s; 
      git checkout %1$s
      git add "%4$s";
      git commit -m "Bumping to Unstable version %2$s";
      git push;
      git checkout %1$s
  ', branch_unstable, next_unstable_version, shellClean(folder), shellClean(file.description))
  message("Will execute the following git command for the next unstable version")
  catnn(cmd.git_commit[["unstable"]])
  ## ---------------------------- GIT FORMATS ----------------------------- ##


  ## ------------------------------------------------------------------------ ##
  ## TWO THINGS NEED TO HAPPEN
  ## (1) update the stable version, check it in, tag it, create new branch in branch_stable_root/
  ## (2) create the next unstable version in master

  versinfo[["stable"]]   <- sprintf("Version: %s", stable_version_to_make)
  versinfo[["unstable"]] <- sprintf("Version: %s", next_unstable_version)

  desc_subline[["stable"]]   <- sprintf("    Current stable version (committed on %s).",             timeStamp(frmt=time_format))
  desc_subline[["unstable"]] <- sprintf("    Unstable development version (first committed on %s).", timeStamp(frmt=time_format))


  ## MAKE STABLE VERSION
  ## ------------------------------------------------------------------------ ##
  browser(text = "in rsupkg_next_version right before for loop for iterating both stable and unstable", expr=rsugeneral::inDebugMode("pkg", "nextversion"))
  for (s_u in stable_unstable) {
      cls(3)
      message("          ---------------------------------------  [", s_u, "]  ---------------------------------------")
      raw[ind.vers]         <- versinfo[[s_u]]
      raw[ind.desc_subline] <- desc_subline[[s_u]]

      # cmd <- sprintf(fmt=cmd.git_commit[[s_u]], folder, file.description)

      if (!.test_run) {
        verboseMsg(verbose_raw, pasteC(raw, C="\n"), time=FALSE)
         ## WRITE THE FILE
         cat(raw, "\n", file=file.description, append=FALSE, sep="\n")
          ## GIT COMMIT, CHECKOUT NEW BRANCH, PUSH, ETC
          system(cmd.git_commit[[s_u]], intern=FALSE)
      } else {
        message("  ....... not writing to disk, but here is the raw output .......")
        cat(raw, sep="\n")
        message(cmd.git_commit[[s_u]])
        message("  ...............................................................\n")
      }
  }

  if (.test_run)
    message("\n\n------------- REMINDER: In order to write to disk, you **MUST** rerun with   .test_run = FALSE")
  return(TRUE)
}
