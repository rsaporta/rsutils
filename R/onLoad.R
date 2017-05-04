.onLoad <- function(libname, pkgname, verbose=getOption("verbose.rsutils_load", default=FALSE)) {
  try(require(colorout))

  if (verbose)
    cat("Running .onLoad() from rsutils --------------------------------- ======================================= ||\n")

  load_rsutils(rsutils_load=FALSE)
}

testing_utils <- function() {
  cat("yes, this file loaded. -- it came from '<path>/rsutils/R/onLoad.R'\n")
}