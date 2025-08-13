#' Check (and create if necessary) designated directory
#'
#' `checksavedir()` checks for the existence of a directory
#' where output files from hsv functions are saved.
#' If not, it creates a new directory.
#'
#' @param d A string. The name of the directory.
#'
#' @keywords utilities

checksavedir <- function(

	d

) {

d <- sub("[/\\]+$", "", d)
if (!dir.exists(d)) {
	dir.create(d, recursive = TRUE)
}

invisible(d)
}
