#' @export
#' @importFrom remotes install_local
.reinstall_local <- function(pkgs, parent_folder = "~/Development/rsutils_packages/", git_pull=FALSE, dependencies=FALSE) {
  if (!file.exists(parent_folder))
    stop("parent_folder \"", parent_folder, "\" does not exist")

  subfolders <- dir(parent_folder)

  wh.not <- !(pkgs %in% subfolders)
  if (any(wh.not)) {
    rsupkgs <- paste0("rsu", pkgs)
    wh.rsu <- (rsupkgs[wh.not] %in% subfolders)
    pkgs[wh.not][wh.rsu] <- rsupkgs[wh.not][wh.rsu]
  }

  lapply(pkgs, function(pkg) {
    try(remotes::install_local(file.path(parent_folder, pkg), dependencies=dependencies), silent=FALSE)
  })
}
