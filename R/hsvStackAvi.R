#' Synthesizer of juxtaposed vedio from multiple avi files 
#'
#' Stacks input avi files horizontally or vertically to create
#' a new, merged vedio with a juxtaposed view.
#'
#' This function creates a stacked view from multiple input avi videos.
#' It is best used for the purpose to get a overview of the videos
#' recorded simultaneously with multiple cameras.
#' The input files should naturally have the same lengths.
#' The direction of stacking can be either horizontal (default)
#' or vertical.
#' Also, some additional conversion settings can be done
#' through optional arguments.
#'
#' @param infiles Strings. The names of the avi files you want to merge.
#' @param outfile A string. The name of the output avi file.
#' @param keepfiles A logical. Whether to keep the input files
#'   after the stacking.
#' @param crf An integer. The constant rate factor (crf),
#'   i.e., a value to determine the quality of the converted video
#'   in FFmpeg (ranging from 0 to 51).
#'   Smaller value indicate high quality video.
#'   The default value for `ffmpeg` command is 23,
#'   meaning that the default for this function is quality-oriented,
#'   in exchange for larger file size.
#' @param horizontal A logical. Whether to stack the videos horizontally.
#'   If set FALSE, videos are vertically stacked.
#' @param addfilt A string. Additional filter setting passed to
#'   `-filter_complex` option of `ffmpeg`.
#' @param framerate An integer. The frame rate of the output avi file.
#'
#' @return A string. The names of the created avi file.
#'
#' @examples
#' \dontrun{
#' hsvStackAvi(c("input1.avi", "input2.avi"))
#' }
#'
#' @keywords utilities
#'
#' @export

hsvStackAvi <- function(

	infiles,
	outfile = "output.avi",
	keepfiles = TRUE,
	crf = 20,
	horizontal = TRUE,
	addfilt = "",
	framerate = 50

) {

filter <- ifelse(horizontal, 'hstack', 'vstack')
if (length(infiles) > 2) {
	filter <- paste(paste("[", 0:(length(infiles) - 1), ":v]", sep = "", collapse = ""),
		filter, "=inputs=", length(infiles), "[v]", sep = "")
}
if (addfilt != "") {
	filter <- paste(filter, ",", addfilt)
}

if (length(infiles) < 2) {
	warning("stop stacking for non-multiple infiles")
} else {
	cmd <- paste('ffmpeg -hide_banner -y ',
		paste(paste('-i "', infiles, '"', sep = ''), collapse = ' '),
		' -codec:v libx264 -pix_fmt yuv420p -crf ', crf,
		' -filter_complex "', filter, '"',
		ifelse(length(infiles) > 2, ' -map "[v]"', ''),
		' "', outfile, '"', sep = "")
	cat(getwd(), " > ", cmd, "\n", sep = "")
	flush.console()

	rslt <- system(cmd)
	cat("\n")
	flush.console()

	if (rslt != 0) {
		stop(paste("error in creating horizontal stack", outfile))
	}

	hsvChangeFrameRate(outfile, rate = framerate)
}

if (!keepfiles) {
	file.remove(infiles)
}

invisible(outfile)
}
