splitVersionNumber <- function(versionNumber) {
  versionNumber %<>% .validate_and_clean_versionNumber(fail.if.not=TRUE)

  nms <- c("x", "y", "z")
  xyz <- versionNumber %>% 
          as.character %>% 
          strsplit(split="\\.") %>% 
          unlist(use.names=FALSE) %>% 
          c(0, 0) %>% 
          head(3) %>% 
          as.numeric() %>% 
          setNames(nm=nms)

  if (any(is.na(xyz)))
    stop("some parts of versionNumber ('", versionNumber, "') are NOT numeric.")

  return(xyz)
}

versionNumberFromXYZ <- function(full, x=full[["x"]], y=full[["y"]], z=full[["z"]], sep_xy=sep, sep_yz=sep, sep=".") {
  missing_full <- missing(full)
  missing_xyz <- missing(x) || missing(y) || missing(z)

  if (!missing_full && !missing_xyz)
    stop("Either use 'full'  or set 'x', 'y', 'z'.   No mixing and matching")
  if (missing_full && missing_xyz)
    stop("Must specify either 'full'  or 'x', 'y', 'z'.")
  if (!missing_full &&  sort(names(full)) != c("x", "y", "z") )
    stop("full must have names c('x', 'y', 'z')")

  paste0(x, sep_xy, y, sep_yz, z)
}

if (FALSE) {
  current_version <- "1.2.3"
  increment_version(current_version)
  increment_version(current_version, what="x")
  increment_version(current_version, what="y")
  increment_version(current_version, what="z")

  increment_version(current_version,           by=2)
  increment_version(current_version, what="x", by=2)
  increment_version(current_version, what="y", by=2)
  increment_version(current_version, what="z", by=2)
}

increment_version <- function(current_version, what=c("x", "y", "z"), by=1, y_must_be_even=FALSE, y_must_be_odd=FALSE) {
  current_version %<>% .validate_and_clean_versionNumber(fail.if.not=TRUE)

  if (y_must_be_odd && y_must_be_even)
    stop("Both y_must_be_odd & y_must_be_even cannot be set to TRUE")

  what <- match.arg(what)
  xyz <- splitVersionNumber(current_version)

  if (what == "x") {
    x <- xyz[["x"]] + by
    y <- 0
    z <- 0
  } else if (what == "y") {
    x <- xyz[["x"]]
    y <- xyz[["y"]] + by
    z <- 0
  } else if (what == "z") {
    x <- xyz[["x"]]
    y <- xyz[["y"]]
    z <- xyz[["z"]] + by
  } else {
    stop("internal error.  Wrong value for what")
  }

  y_is_even <- (y %% 2) == 0
  if (y_must_be_even && !y_is_even)
    y %<>% plus1
  if (y_must_be_odd && y_is_even)
    y %<>% plus1

  versionNumberFromXYZ(x=x, y=y, z=z)
}


.validate_and_clean_versionNumber <- function(versionNumber, fail.if.not=TRUE) {
  if (is.numeric(versionNumber) && versionNumber < 10 && versionNumber > 0)
    versionNumber %<>% as.character()
  
  is.character_of_length1(versionNumber, fail.if.not=fail.if.not)

  return(versionNumber)
}