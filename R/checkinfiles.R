#' Check existence and compatibility of video files
#'
#' `checkinfiles()` performs routine checks of input
#' video files to many functions in hsv package.
#' These include confirmation of existence of the files,
#' as well as checking their file extentions.
#'
#' @param f Strings. The names of the video files.
#'
#' @keywords utilities

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
