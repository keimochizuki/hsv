#' Extractor of clipped vedios from avi files
#'
#' Extracts designated range of videos and create new avi files
#' from designated input sources.
#'
#' This function clips designated range in the input avi files,
#' without performing any other video conversion.
#' It can be used, for example, to cut off certain range of the
#' video file to where your further analyses are applied.
#'
#' Since no conversion is performed (with `-c copy` option in `ffmpeg`),
#' this function normally takes not so long.
#' However, as a drawback of it, clipped videos may not strictly start
#' from the first frame of the designated clipping range.
#' This is due to the limitation of FFmpeg itself.
#' The `copy` option mentioned above prevent any conversion
#' of the input video stream.
#' Therefore, clipping can be started from the nearest preceding keyframes
#' in the original files.
#' (Otherwise, video conversion would be necessary.)
#' If the input files are raw (typically very huge) avi files
#' with no video compression, this limitation does not matter
#' since all frames behave as keyframes in such a case.
#'
#' @param infiles Strings. The names of the avi files you want to clip.
#' @param from An integer. The index of the frame (frame number)
#'   in the input file from where the clipped video starts.
#' @param to An integer. The index of the frame (frame number)
#'   in the input file to where the video should be clipped.
#'
#' @return A string. The names of the created avi file.
#'
#' @examples
#' \dontrun{
#' hsvClipAvi("input.avi", from = 1000, to = 1999)
#' }
#'
#' @keywords utilities
#'
#' @export

hsvClipAvi <- function(

	infiles,
	from,
	to

) {

if (!all(grepl("\\.avi$", infiles, ignore.case = TRUE))) {
	stop("Non-avi file(s) designated, stopping further processing.")
}
if (!all(file.exists(infiles))) {
	stop("Non-existing file(s) designated, stopping further processing.")
}

outfiles <- sub("\\.avi$", sprintf("_%d-%d.avi", from, to), infiles, ignore.case = TRUE)

frame2time <- function(n, framerate, duration) {
	if (n < 0) {
		n <- 0
		warning("Negative frame index designated, clipping from the initial frame instead.")
	}
	if (n > duration) {
		n <- duration
		warning("Frame index exceeded the total length, clipping to the last frame instead.")
	}

	s <- n / framerate
	ms <- round((s - floor(s)) * 1000)
	s <- floor(s)

	m <- s %/% 60
	s <- s %% 60

	h <- m %/% 60
	m <- m %% 60

	return(sprintf("%02d:%02d:%02d.%03d", h, m, s, ms))
}

for (i in seq(along = infiles)) {
	info <- hsvGetAviHeader(infiles[i])
	fr <- info$Rate / info$Scale
	dr <- info$`Total Frames`

	cmd <- paste('ffmpeg -hide_banner -y -ss ', frame2time(from, fr, dr),
		' -to ', frame2time(to + 1, fr, dr), ' -i "', infiles[i],
		'" -c copy "', outfiles[i], '"', sep = "")
	cat(getwd(), " > ", cmd, "\n", sep = "")
	flush.console()

	rslt <- system(cmd)
	cat("\n")
	flush.console()

	if (rslt != 0) {
		stop(paste("Failed to export", outfiles[i]))
	}
}

invisible(outfiles)
}
