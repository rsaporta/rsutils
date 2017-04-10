.onLoad <- function(libname, pkgname) {
  try(require(colorout))
  cat("Running .onLoad() from rsutils --------------------------------- ======================================= ||\n")

  load_rsutils()
}

testing_utils <- function() {
  cat("yes, this file loaded. -- it came from '<path>/rsutils/R/onLoad.R'\n")
}