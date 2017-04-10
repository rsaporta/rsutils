load_rsutils <- function(verbose=TRUE) {

## usage:  replace   
##     library(rsutils)
## with
##     rsutils::load_rsutils    

       pkgs = 
    c("rsugeneral"
    , "rsuaspath"
    , "rsuaws"
    , "rsubitly"
    , "rsuconsoleutils"
    , "rsucurl"
    , "rsudb"
    , "rsudict"
    , "rsujesus"
    , "rsunotify"
    # , "rsuorchard"
    , "rsuplotting"
    , "rsuprophesize"
    , "rsuscrubbers"
    , "rsushiny"
    , "rsuvydia"
    , "rsuworkspace"
    , "rsuxls"
    , "rsutils"
    # , "rsutils2"
    # , "rsutils3"
    )


    ## LOAD PACKAGES
    for (pkg in pkgs) {
      if (verbose)
        message(sprintf("---------- ========= [    LOADING  % 16s    ] ========= ----------", pkg))
      library(pkg, character.only=TRUE)
    }

    ## SOME FUNCTIONS NEED CREATING
    try(rsuworkspace::.create_dir.p_functions())
    try(rsuplotting::.create_axis_functions())


    return(invisible(0))
}

