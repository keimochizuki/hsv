#' Crop a region of video area
#'
#' [hsvCropAvi()] extracts designated spatial region of videos
#' and create new avi files from input sources.
#'
#' This function crops designated area in the input avi files.
#' without performing any other video conversion.
#' Such process is sometimes referred to as trimming,
#' especially in image processing.
#' However, the same word also means temporal clipping
#' in the field of video editing.
#' To avoid confusion, therefore, this process should be
#' better referred to as "area cropping" or "spatial trimming".
#' This functionality is used, for example,
#' when the field of view of your video recording is too wider
#' in relation to the targeted object.
#'
#' The area of the cropped region is determined by
#' its width and height.
#' Also, the location of the region can be modified by
#' x (horizontal) and y (vertical) offsets.
#' Here caution should be exercised that,
#' as a tradition of image processing,
#' the origin of an image normally exists at the *top*-left corner.
#' Therefore, the `yoffset` parameter determines
#' the *top* margin (instead of bottom) to the cropped region.
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
#'   Since the y-axis starts from the upper end in image processing,
#'   this value equals to the top (instead of bottom)
#'   margin omitted from original videos.
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
#' hsvCropAvi("video.avi", w = 320, h = 240)
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
	crf = 20,
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
		' -codec:v libx264 -pix_fmt yuv420p -crf ', crf,
		' "', outfiles[i], '"', sep = "")
	callffmpeg(cmd)
}

if (!keepinfiles) {
	file.remove(infiles)
}

invisible(outfiles)
}
