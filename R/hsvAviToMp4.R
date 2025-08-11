#' Converter of avi video into mp4 format
#'
#' Converts designated avi video file into mp4 format
#' that can be played in various environment.
#'
#' Avi video format has really diverse major and minor subtypes
#' in its specification.
#' Times and times, you will meet a condition that some files
#' can be opened and played with a certain software,
#' but some others are not.
#' This can be due to their video codec, pixel resolution,
#' frame rate, color space used, stream composition, or
#' any other slight anomalies in video, audio and subtitle streams
#' or meta data fields.
#' Such problems can be sometimes overcome by converting
#' these files into mp4 format.
#' To the author's knowledge and experience, mp4 format is
#' more likely to be played in wider condition.
#' (Still, it shares the same problems with avi format
#' for some extent.)
#' Therefore, this package provides an easy way to perform
#' avi-to-mp4 conversion through FFmpeg.
#'
#' @param infiles Strings. The names of the avi files
#'   you want to convert into mp4.
#' @param keepfiles A logical. Whether to keep the input files
#'   after the conversion.
#'
#' @return Strings. The names of the created mp4 files.
#'
#' @examples
#' \dontrun{
#' hsvAviToMp4("input.avi")
#' }
#'
#' @keywords utilities
#'
#' @export

hsvAviToMp4 <- function(

	infiles,
	keepfiles = TRUE

) {

if (!all(grepl("\\.avi$", infiles, ignore.case = TRUE))) {
	stop("Non-avi file(s) designated, stopping further processing.")
}
if (!all(file.exists(infiles))) {
	stop("Non-existing file(s) designated, stopping further processing.")
}

outfiles <- sub("\\.avi$", "\\.mp4", infiles, ignore.case = TRUE)

for (i in seq(along = infiles)) {
	rslt <- system(paste('ffmpeg -hide_banner -y -i ',
		infiles[i], ' ', outfiles[i], sep = ""))
	cat("\n")
	flush.console()
}

if (!keepfiles) {
	file.remove(infiles)
}

invisible(outfiles)
}
