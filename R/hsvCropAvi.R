#' Crop a region of video area
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
#' @param infiles Strings. The names of the avi files you want to crop.
#' @param w An integer. The width of the cropping region in pixels.
#' @param h An integer. The height of the cropping region in pixels.
#' @param xoffset An integer. The number of pixels skipped
#'   toward x-axis before cropping region starts.
#'   This value equals to the left margin omitted
#'   from original videos.
#' @param yoffset An integer. The number of pixels skipped
#'   toward y-axis before cropping region starts.
#'   Note, as a tradition of image processing,
#'   the origin of an image is normally *top*-left corner.
#'   Therefore, this value equals to the top (instead of bottom)
#'   margin omitted from original videos.
#' @param suffix A string. The suffix to the file names
#'   concatenated to the names of input avi files
#'   to make those for the outputs.
#' @param keepinfiles A logical. Whether to keep the input files
#'   after the conversion.
#' @param savedir A string. The path to the directory
#'   you want to save the output file(s)
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

hsvCropAvi <- function(

	infiles,
	w,
	h,
	xoffset = 0,
	yoffset = 0,
	suffix = paste(w, h, sep = "x"),
	keepinfiles = TRUE,
	savedir = "."

) {

checkinfiles(infiles)
savedir <- checksavedir(savedir)

outfiles <- sub("\\.avi$", sprintf("_%s.avi", suffix), basename(infiles), ignore.case = TRUE)
outfiles <- file.path(savedir, outfiles)

for (i in seq(along = infiles)) {
	hd <- hsvGetAviHeader(infiles[i])
	if ((w > hd$Width) || (h > hd$Height)) {
		stop("Protruding cropping area designated, stopping further processing")
	}
	xoffset <- ifelse(xoffset < 0, 0, xoffset)
	xoffset <- min(xoffset, hd$Width - w - 1)
	yoffset <- ifelse(yoffset < 0, 0, yoffset)
	yoffset <- min(yoffset, hd$Height - h - 1)

	cmd <- paste(
		'-i "', infiles[i],
		'" -vf crop=', paste(w, h, xoffset, yoffset, sep = ":"),
		' "', outfiles[i], '"', sep = "")
	callffmpeg(cmd)
}

if (!keepinfiles) {
	file.remove(infiles)
}

invisible(outfiles)
}
