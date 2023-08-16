#' @importFrom rsugeneral is.integer_of_length1
#' @importFrom rsugeneral is.numeric_of_length1
#' @importFrom rsugeneral is.character_of_length1
#' @importFrom rsugeneral fmt_int0
#' @importFrom rsugeneral pasteR
#' @importFrom rsugeneral countLeadingZerosInString
#' @export
splitVersionNumber <- function(
  versionNumber,
  digs_x_min = 1L,
  digs_y_min = 2L,
  digs_z_min = 3L
) {
  versionNumber %<>% .validate_and_clean_versionNumber(fail.if.not=TRUE)

  is.integer_of_length1(digs_x_min, fail.if.not = TRUE, numeric_allowed = TRUE, NA_allowed = FALSE)
  is.integer_of_length1(digs_y_min, fail.if.not = TRUE, numeric_allowed = TRUE, NA_allowed = FALSE)
  is.integer_of_length1(digs_z_min, fail.if.not = TRUE, numeric_allowed = TRUE, NA_allowed = FALSE)

  nms <- c("x", "y", "z")
  splat_strings <- versionNumber %>% 
          as.character %>% 
          strsplit(split = "\\.") %>% 
          unlist(use.names = FALSE) %>% 
          c(0, 0) %>% 
          head(3)
  
  xyz <- splat_strings %>% 
          as.numeric() %>% 
          setNames(nm = nms)

  if (any(is.na(xyz)))
    stop("some parts of versionNumber ('", versionNumber, "') are NOT numeric.")

  attr(xyz, "digs_x") <- nchar(splat_strings)[[1L]] %>% min(digs_x_min)
  attr(xyz, "digs_y") <- nchar(splat_strings)[[2L]] %>% min(digs_y_min)
  attr(xyz, "digs_z") <- nchar(splat_strings)[[3L]] %>% min(digs_z_min)

  attr(xyz, "leading_zeros") <- 
    countLeadingZerosInString(splat_strings)

  return(xyz)
}

#' @export
versionNumberFromXYZ <- function(
    full = NULL
  , x = full[["x"]]
  , y = full[["y"]]
  , z = full[["z"]]
  , sep_xy = sep
  , sep_yz = sep
  , sep = "."
  , digs_x = attr(full, "digs_x") %>% min(1L)
  , digs_y = attr(full, "digs_y") %>% min(2L)
  , digs_z = attr(full, "digs_z") %>% min(3L)
  , zeros_to_pad_at_end = 0L
) {

  missing_full <- missing(full) || is.null(full)
  missing_xyz  <- missing(x) || missing(y) || missing(z)

  is.integer_of_length1(zeros_to_pad_at_end, min_value = 0, numeric_allowed = TRUE, null_ok = FALSE, fail.if.not = TRUE)
  is.integer_of_length1(digs_x,              min_value = 1, numeric_allowed = TRUE, null_ok = FALSE, fail.if.not = TRUE)
  is.integer_of_length1(digs_y,              min_value = 1, numeric_allowed = TRUE, null_ok = FALSE, fail.if.not = TRUE)
  is.integer_of_length1(digs_z,              min_value = 1, numeric_allowed = TRUE, null_ok = FALSE, fail.if.not = TRUE)

  if (!missing_full && !missing_xyz)
    stop("Either use 'full'  or set 'x', 'y', 'z'.   No mixing and matching")
  if (missing_full && missing_xyz)
    stop("Must specify either 'full'  or 'x', 'y', 'z'.")
  if (!missing_full &&  !identical(sort(names(full)), c("x", "y", "z")) )
    stop("full must have names c(\"x\", \"y\", \"z\"). It has names: ", capture.output(names(full)))

  ## format 0
  x <- sprintf(fmt_int0(digs_x), x)
  y <- sprintf(fmt_int0(digs_y), y)
  z <- sprintf(fmt_int0(digs_z), z)

  ret <- paste0(x, sep_xy, y, sep_yz, z)

  if (zeros_to_pad_at_end > 0) {
    ret <- paste0(ret, pasteR(x=0, n=zeros_to_pad_at_end))
  }
  return(ret)
}

#' @export
increment_version <- function(
  current_version, 
  what           = c("x", "y", "z"),
  by             = 1,
  y_must_be_even = FALSE,
  y_must_be_odd  = FALSE
) {
  current_version %<>% .validate_and_clean_versionNumber(fail.if.not=TRUE)

  if (y_must_be_odd && y_must_be_even)
    stop("Both y_must_be_odd & y_must_be_even cannot be set to TRUE")

if (FALSE) {
  c(Version = "9.01.9771019799")
}

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

  if (xyz[["z"]] > .Machine$integer.max) {
    warning("The \"z\" portion of the version number has too many digits, and will be cropped")
    divide_by <- 10 ^ (ceiling(log10(xyz[["z"]])) - floor(log10(.Machine$integer.max)) + 1L)
    xyz[["z"]] <- (xyz[["z"]] / divide_by) + by
  }


  y_is_even <- (y %% 2) == 0
  if (y_must_be_even && !y_is_even)
    y %<>% plus1
  if (y_must_be_odd && y_is_even)
    y %<>% plus1

  versionNumberFromXYZ(x = x, y = y, z = z)
}

## DONT EXPORT
.validate_and_clean_versionNumber <- function(versionNumber, fail.if.not=TRUE) {
  if (is.numeric(versionNumber) && versionNumber < 10 && versionNumber > 0)
    versionNumber %<>% as.character()
  
  is.character_of_length1(versionNumber, fail.if.not=fail.if.not)

  return(versionNumber)
}
