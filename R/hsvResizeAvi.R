#' Resize the video resolution
#'
#' [hsvResizeAvi()] changes the video resolution to
#' fit designated width or height.
#' If either width or height is provided,
#' the undesignated side will be automatically determined
#' to keep the original aspect ratio.
#' If both are provided, the aspect ratio changes
#' in the resulting video file(s).
#'
#' @param infiles Strings. The names of the avi files you want to resize.
#' @param w An integer. The width of the resized video.
#'   Default -2, meaning to match the height while keeping the aspect ratio.
#'   Note that odd resolution is not supported due to
#'   the limitation of video compression format.
#' @param h An integer. The height of the resized video.
#'   Default -2, meaning to match the width while keeping the aspect ratio.
#'   Note that odd resolution is not supported due to
#'   the limitation of video compression format.
#' @param crf An integer. The constant rate factor (crf),
#'   i.e., a value to determine the quality of the converted video
#'   in FFmpeg (ranging from 0 to 51).
#'   Smaller value indicate high quality video.
#'   The default value for original `ffmpeg` command is 23.
#'   Therefore, the default for this function is quality-oriented,
#'   in exchange for possible larger file size.
#' @param suffix A string. The suffix to the file names
#'   concatenated to the names of input avi files
#'   to make those for the outputs.
#' @param keepinfiles A logical. Whether to keep the input files
#'   after the conversion.
#' @param savedir A string. The path to the directory
#'   you want to save the output file(s).
#'
#' @return A string. The names of the created avi file.
#'
#' @examples
#' \dontrun{
#' hsvResizeAvi("video.avi", w = 320)
#' }
#'
#' @keywords utilities
#'
#' @export

hsvResizeAvi <- function(

	infiles,
	w = -2,
	h = -2,
	crf = 20,
	suffix = paste(ifelse(c(w, h) == -2, "", paste(c("w", "h"), c(w, h), sep = "")),
		collapse = ""),
	keepinfiles = TRUE,
	savedir = "."

) {

if (all(c(w, h) < 0)) {
	warning("No resize performed according to the missing both width and height")
	return(invisible(infiles))
}

checkinfiles(infiles)
savedir <- checksavedir(savedir)

outfiles <- sub("\\.avi$", sprintf("_%s.avi", suffix), basename(infiles), ignore.case = TRUE)
outfiles <- file.path(savedir, outfiles)

for (i in seq(along = infiles)) {
	cmd <- paste(
		'-i "', infiles[i],
		'" -vf scale=', paste(w, h, sep = ":"),
		' -codec:v libx264 -pix_fmt yuv420p -crf ', crf,
		' "', outfiles[i], '"', sep = "")
	hsvCallFFmpeg(cmd)
}

if (!keepinfiles) {
	file.remove(infiles)
}

invisible(outfiles)
}
