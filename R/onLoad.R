.onLoad <- function(libname, pkgname) {
  cat("Running .onLoad() from rsutils")

  load_rsutils()
}

testing_utils <- function() {
  cat("yes, this file loaded.")
}