#' Check output directory
#'
#' `checksavedir()` checks for the existence of a directory
#' where output files from hsv functions are saved.
#' If such a directory does not exist, new one is created.
#'
#' @param d A string. The name of the directory.
#'
#' @return A string. The name of the checked
#'   (or created) directory.
#'
#' @keywords utilities internal

checksavedir <- function(

	d

) {

d <- sub("[/\\]+$", "", d)
if (!dir.exists(d)) {
	dir.create(d, recursive = TRUE)
}

invisible(d)
}
