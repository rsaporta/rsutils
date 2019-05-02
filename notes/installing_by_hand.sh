sudo sh -c "export RSU_INSTALLING=TRUE && R --vanilla && unset RSU_INSTALLING"
{
  pkg <- "rsugeneral"

  stopifnot(as.logical(Sys.getenv("RSU_INSTALLING")))

  try(require(colorout))
  qn <- function() quit("no")
  options("repos" = c(CRAN="http://cran.Rstudio.com/", CMU="http://lib.stat.cmu.edu/R/CRAN/"))
  options(rsunotify.NO_OPTIONS_AT_STARTUP=TRUE)
  options(rsutils.installing=TRUE)
  cat("INSTALLING pkg = '", pkg, "' via devtools .... \n", sep ="")
  devtools::install_local(paste0("~/Development/rsutils_packages/", pkg))
}

