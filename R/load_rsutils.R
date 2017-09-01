load_rsutils <- function(verbose=TRUE, rsutils_load=TRUE, run_creates=FALSE, quietly=TRUE) {

## usage:  replace   
##     library(rsutils)
## with
##     rsutils::load_rsutils    

    ## THESE PACKAGES GET USED SO OFTEN, MAKE SURE TO LOAD THEM
    try( require(colorout,   quietly=quietly) )
    try( library(data.table, quietly=quietly) ) 
    try( library(magrittr,   quietly=quietly) )
    

    if (exists(".rsu_pkgs_strings", mode="function")) {
        pkgs <- .rsu_pkgs_strings()
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
            )
    }

    if (!isTRUE(rsutils_load))
        pkgs <- setdiff(pkgs, "rsutils")

    ## cross reference against what is installed
    installed_packages <- unlist(dir(.libPaths()), use.names=FALSE)
    pkgs <- intersect(pkgs, installed.packages())

    ## LOAD PACKAGES
    for (pkg in pkgs) {
      if (verbose)
        message(sprintf("---------- ========= [    LOADING  % 16s    ] ========= ----------", pkg))
      try(library(pkg, warn.conflicts=FALSE, character.only=TRUE, quietly=quietly))
    }

    ## UPDATE 2017-06-07, this shouldnt be needed anymore. I belive these run onLoad with each package
    ##                    Converting to an optional argument
    if (run_creates) {
        ## SOME FUNCTIONS NEED CREATING
        if (!exists("src.p", mode="function"))
            try({  eval( rsuworkspace::.create_dir.p_functions(), envir=globalenv() )  })
        if (!(exists("dollar", mode="function") && exists("weeks", mode="function") && exists("days", mode="function")))
            try({  eval(  rsuplotting::.create_axis_functions(),  envir=globalenv() )  })
    }

    return(invisible(TRUE))
}
