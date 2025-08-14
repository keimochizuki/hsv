#' Check compatibility of source videos
#'
#' [checkinfiles()] performs routine checks of input
#' video files for many hsv functions.
#' These include confirmation of existence of the files,
#' as well as checking their file extentions.
#'
#' @param f Strings. The names of the video files.
#'
#' @keywords utilities internal

checkinfiles <- function(

	f

) {

if (!all(file.exists(f))) {
	stop("Non-existing file(s) designated, stopping further processing")
}
if (!all(grepl("\\.avi$", f, ignore.case = TRUE))) {
	stop("Non-avi file(s) designated, stopping further processing")
}

invisible()
}
