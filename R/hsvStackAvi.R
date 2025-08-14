#' Juxtapose multiple videos
#'
#' [hsvStackAvi()] concatenates input avi files horizontally or vertically
#' to create a new, merged vedio with a juxtaposed view.
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
#' @param horizontal A logical. Whether to stack the videos horizontally.
#'   If set FALSE, videos are vertically stacked.
#' @param addfilt A string. Additional filter setting passed to
#'   `-filter_complex` option of `ffmpeg`.
#' @param crf An integer. The constant rate factor (crf),
#'   i.e., a value to determine the quality of the converted video
#'   in FFmpeg (ranging from 0 to 51).
#'   Smaller value indicate high quality video.
#'   The default value for original `ffmpeg` command is 23.
#'   Therefore, the default for this function is quality-oriented,
#'   in exchange for possible larger file size.
#' @param framerate An integer. The frame rate of the output avi file.
#' @param outfile A string. The name of the output avi file.
#'   If provided, this parameter override `suffix` argument
#'   that is normally used to create output file names
#'   in many other hsv functions.
#' @param suffix A string. The suffix to the file names
#'   concatenated to the names of input avi files
#'   to make those for the outputs.
#'   Since this function creates one output from multiple inputs
#'   (unlike other hsv functions),
#'   only the name of the first input file is inherited
#'   with the designated suffix.
#' @param keepinfiles A logical. Whether to keep the input files
#'   after the stacking.
#' @param savedir A string. The path to the directory
#'   you want to save the output file.
#'
#' @return A string. The name of the created avi file.
#'
#' @examples
#' \dontrun{
#' hsvStackAvi(c("video1.avi", "video2.avi"))
#' }
#'
#' @keywords utilities
#'
#' @export

hsvStackAvi <- function(

	infiles,
	horizontal = TRUE,
	addfilt = "",
	crf = 20,
	framerate = 50,
	outfile = "",
	suffix = "stacked",
	keepinfiles = TRUE,
	savedir = "."

) {

checkinfiles(infiles)
savedir <- checksavedir(savedir)

if (outfile != "") {
	outfile <- sub("\\.avi$", "", basename(outfile), ignore.case = TRUE)
	outfile <- paste(outfile, ".avi", sep = "")
} else {
	outfile <- sub("\\.avi$", sprintf("_%s.avi", suffix), basename(infiles[1]), ignore.case = TRUE)
}
outfile <- file.path(savedir, outfile)

filter <- ifelse(horizontal, 'hstack', 'vstack')
if (length(infiles) > 2) {
	filter <- paste(paste("[", 0:(length(infiles) - 1), ":v]", sep = "", collapse = ""),
		filter, "=inputs=", length(infiles), "[v]", sep = "")
}
if (addfilt != "") {
	filter <- paste(filter, ",", addfilt)
}

if (length(infiles) < 2) {
	warning("Only a single input file designated, skipping further processing")
} else {
	cmd <- paste(
		paste(paste('-i "', infiles, '"', sep = ''), collapse = ' '),
		' -codec:v libx264 -pix_fmt yuv420p -crf ', crf,
		' -filter_complex "', filter, '"',
		ifelse(length(infiles) > 2, ' -map "[v]"', ''),
		' "', outfile, '"', sep = "")
	callffmpeg(cmd)
	hsvChangeAviFps(outfile, rate = framerate)
}

if (!keepinfiles) {
	file.remove(infiles)
}

invisible(outfile)
}
