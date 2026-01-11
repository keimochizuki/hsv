#' Check compatibility of source videos
#'
#' [checkinfiles()] performs routine checks of input
#' video files for many hsv functions.
#' These include confirmation of existence of the files,
#' as well as checking their file extentions.
#'
#' @param f Strings. The names of the video files.
#' @param ext A string. A regular expression pattern for
#'   file extensions allowed.
#'
#' @keywords utilities internal

checkinfiles <- function(

	f,
	ext = "avi"

) {

if (!all(file.exists(f))) {
	stop("Non-existing file(s) designated, stopping further processing")
}

ext <- paste(paste("\\.", ext, "$", sep = ""), collapse = "|")
if (!all(grepl(ext, f, ignore.case = TRUE))) {
	stop("Incompatible file(s) designated, stopping further processing")
}

invisible()
}
