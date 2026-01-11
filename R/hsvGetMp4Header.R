#' Read out mp4 header
#'
#' [hsvGetMp4Header()] extracts header information of
#' the first video stream in an mp4 file.
#'
#' Unlike [hsvGetAviHeader()], this function reads header
#' information of a given mp4 file using 'ffprobe' utility.
#'
#' @param infile A string. The name of the avi file you want to
#'   read header information.
#' @param verbose A logical. Whether to print the extracted values
#'   on the console lines.
#'
#' @return A list. Extracted header information.
#'
#' @examples
#' \dontrun{
#' hsvGetMp4Header("video.mp4", verbose = TRUE)
#' }
#'
#' @keywords utilities
#'
#' @export

hsvGetMp4Header <- function(

	infile,
	verbose = FALSE

) {

checkinfiles(infile, "mp4")

cmd <- paste('ffprobe -hide_banner -show_streams "', infile, '"', sep = "")
val <- system(cmd, intern = TRUE)

val <- val[-c(1, length(val))]
val <- strsplit(val, "=")
v <- lapply(X = val, FUN = "[", 2)
names(v) <- sapply(X = val, FUN = "[", 1)

if (verbose) {
	print(data.frame(FIELD = names(v), VALUE = unlist(v)), row.names = FALSE)
}

invisible(v)
}
