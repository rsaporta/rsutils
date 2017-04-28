load_rsutils <- function(verbose=TRUE, rsutils_load=TRUE) {

## usage:  replace   
##     library(rsutils)
## with
##     rsutils::load_rsutils    

    ## THESE PACKAGES GET USED SO OFTEN, MAKE SURE TO LOAD THEM
    library(data.table)
    library(magrittr)

    if (exists(".rsu_pkgs_strings", mode="function")) {
        pkgs <- setdiff(.rsu_pkgs_strings(), "rsutils3")
    } else  {
        pkgs <- 
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
            , "rsuplotting"
            , "rsuprophesize"
            , "rsuscrubbers"
            , "rsushiny"
            , "rsuvydia"
            , "rsuworkspace"
            , "rsuxls"
            , "rsutils"

            # ------------------------ #
            # , "rsuorchard"
            # , "rsutils2"
            # , "rsutils3"
            # ------------------------ #
            )
    }

    if (!isTRUE(rsutils_load))
        pkgs <- setdiff(pkgs, "rsutils")

    ## LOAD PACKAGES
    for (pkg in pkgs) {
      if (verbose)
        message(sprintf("---------- ========= [    LOADING  % 16s    ] ========= ----------", pkg))
      try(library(pkg, character.only=TRUE))
    }

    ## SOME FUNCTIONS NEED CREATING
    try({  eval( rsuworkspace::.create_dir.p_functions(), envir=globalenv() )  })
    try({  eval(  rsuplotting::.create_axis_functions(),  envir=globalenv() )  })


    return(invisible(0))
}

