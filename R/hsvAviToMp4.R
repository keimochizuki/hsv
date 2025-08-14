#' Convert avi video into mp4 format
#'
#' [hsvAviToMp4()] converts designated avi video file
#' into mp4 format that can be played in various environment.
#'
#' Avi video format has diverse major and minor subtypes
#' in its specification.
#' Based on its technical complexity,
#' you will often meet a situation that some files
#' can be opened and played with a certain software,
#' but some others are not.
#' This can be due to their video codec, pixel resolution,
#' frame rate, color space used, stream composition, or
#' any other slight anomalies in video, audio and subtitle streams
#' or meta data fields.
#' Such problems can be sometimes overcome by converting
#' these files into mp4 format.
#' To the author's knowledge and experience, mp4 format is
#' more likely to be played in wider circumstance.
#' (Still, it shares the same problems with avi format
#' for some extent.)
#' Therefore, this package provides an easy way to perform
#' avi-to-mp4 conversion through FFmpeg.
#'
#' @param infiles Strings. The names of the avi files
#'   you want to convert into mp4.
#' @param keepinfiles A logical. Whether to keep the input files
#'   after the conversion.
#' @param savedir A string. The path to the directory
#'   you want to save the output file(s)
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
	keepinfiles = TRUE,
	savedir = "."

) {

checkinfiles(infiles)
savedir <- checksavedir(savedir)

outfiles <- sub("\\.avi$", "\\.mp4", basename(infiles), ignore.case = TRUE)
outfiles <- file.path(savedir, outfiles)

for (i in seq(along = infiles)) {
	callffmpeg(paste('-i "', infiles[i], '" "', outfiles[i], '"', sep = ""))
}

if (!keepinfiles) {
	file.remove(infiles)
}

invisible(outfiles)
}
