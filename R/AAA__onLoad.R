.onLoad <- function(libname, pkgname) {
  verbose <- getOption("verbose.rsutils_load"
                      , default = getOption("verbose.rsutils_load"
                         , default = TRUE))
  
  try(require(colorout,   quietly=TRUE))
  try(require(data.table, quietly=TRUE))
  try(require(dplyr,      quietly=TRUE))
  try(require(magrittr,   quietly=TRUE))

  if (verbose)
    packageStartupMessage(sprintf("Running .onLoad() from %-16s --------------------------- ================================ ||\n", pkgname))

  if (getOption("rsutils.load_on_startup", default=TRUE))
    load_rsutils(rsutils_load=FALSE)
}
