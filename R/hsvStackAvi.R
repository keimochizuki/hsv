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
#' @param padding Integers of length `length(infiles) - 1`.
#'   The sizes of paddings inserted between videos.
#' @param col A string. The color of the padding regions.
#'   This can be provided either as the name of the color or
#'   in hexadecimal form (like `#000000`).
#' @param crf An integer. The constant rate factor (crf),
#'   i.e., a value to determine the quality of the converted video
#'   in FFmpeg (ranging from 0 to 51).
#'   Smaller value indicate high quality video.
#'   The default value for original `ffmpeg` command is 23.
#'   Therefore, the default for this function is quality-oriented,
#'   in exchange for possible larger file size.
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
	padding = 0,
	col = "#000000",
	crf = 20,
	outfile = "",
	suffix = "stacked",
	keepinfiles = TRUE,
	savedir = "."

) {

if (length(infiles) < 2) {
	warning("Only a single input file designated, skipping further processing")
	return(invisible(infiles))
}

padding <- rep(padding, length(infiles) - 1)
if (sum(padding) %% 2) {
	i <- min(which(padding != 0))
	padding[i] <- padding[i] + 1
}
print(padding)

if (col %in% grDevices::colors()) {
	col <- grDevices::rgb(t(grDevices::col2rgb("red")), maxColorValue = 255)
}
col <- sub("^#", "", col)

checkinfiles(infiles)
savedir <- checksavedir(savedir)

if (outfile != "") {
	outfile <- sub("\\.avi$", "", basename(outfile), ignore.case = TRUE)
	outfile <- paste(outfile, ".avi", sep = "")
} else {
	outfile <- sub("\\.avi$", sprintf("_%s.avi", suffix), basename(infiles[1]), ignore.case = TRUE)
}
outfile <- file.path(savedir, outfile)

v_org <- sprintf("[%d:v]", 0:(length(infiles) - 1))
v_pad <- sprintf("[v%d]", 0:(length(infiles) - 1))
flt <- ""
if (any(padding > 0)) {
	flt <- ifelse(horizontal, "pad=iw+%d:ih:0:0:%s", "pad=iw:ih+%d:0:0:%s")
	flt <- sprintf(flt, padding, col)
	flt <- paste(paste(v_org, flt, v_pad, ";", sep = "")[c(padding != 0, FALSE)], collapse = "")
}
flt <- paste(flt, paste(ifelse(c(padding > 0, FALSE), v_pad, v_org), collapse = ""), sep = "")
flt <- paste(flt, ifelse(horizontal, "h", "v"), "stack=inputs=", length(infiles), "[v]", sep = "")

cmd <- paste(
	paste(paste('-i "', infiles, '"', sep = ''), collapse = ' '),
	' -codec:v libx264 -pix_fmt yuv420p -crf ', crf,
	' -filter_complex "', flt, '"',
	' -map "[v]"',
	' "', outfile, '"', sep = "")
hsvCallFFmpeg(cmd)

if (!keepinfiles) {
	file.remove(infiles)
}

invisible(outfile)
}
