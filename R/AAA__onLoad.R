.onLoad <- function(libname, pkgname, verbose=getOption("verbose.rsutils_load", default=FALSE)) {
  try(require(colorout,   quietly=TRUE))
  try(require(data.table, quietly=TRUE))
  try(require(dplyr,      quietly=TRUE))
  try(require(magrittr,   quietly=TRUE))

  if (verbose)
    cat(sprintf("Running .onLoad() from %-16s --------------------------- ================================ ||\n", pkgname))

  load_rsutils(rsutils_load=FALSE)
}
