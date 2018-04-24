.reinstall_local <- function(pkgs, parent_folder = "~/Development/rsutils_packages/", git_pull=FALSE) {
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
    try(devtools::install_local(file.path(parent_folder, pkg)), silent=FALSE)
  })
}
