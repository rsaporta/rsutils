load_rsutils <- function(verbose=TRUE) {
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
    , "rsuorchard"
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


    for (pkg in pkgs) {
      if (verbose)
        message(sprintf("---------- ========= [    LOADING  % 16s    ] ========= ----------", pkg))
      library(pkg, character.only=TRUE)
    }
}

