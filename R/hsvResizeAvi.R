#' Resize the video resolution
#'
#' [hsvResizeAvi()] changes the video resolution to
#' fit designated width or height.
#'
#' This function enlarges or shrinks input videos
#' to have designated width and/or height.
#' If either width or height is provided,
#' the undesignated side will be automatically determined
#' to keep the original aspect ratio.
#' If both are provided, the aspect ratio changes
#' in the resulting video file(s).
#'
#' The default values `-2` for `w` and `h` arguments
#' may seem rather strange to users.
#' Originally, FFmpeg software had size specification keyword `-1`
#' for automatic sizing while keeping the aspect ratio.
#' (Such use of `-1`, i.e., toggling exceptional behavior by
#' assigning essentially nonsense negative value,
#' would be somewhat common in programming, isn't it?)
#' However, as a result of calculation,
#' the automatically-applied width or height could become
#' an odd number.
#' Because some video formats do not support odd width or height,
#' this could be a cause of an error during compression.
#' Therefore, another option `-2` was introduced,
#' which automatically increments incidental odd width or height
#' by one to avoid such an error.
#'
#' Of course, directly assigning odd numbers to `w` and `h`
#' is not worthwhile, too.
#' In such cases, `hsvResizeAvi()` automatically add one(s)
#' to the targeted resolution of the videos.
#'
#' @param infiles Strings. The names of the avi files you want to resize.
#' @param w An integer. The width of the resized video.
#'   Default `-2`, meaning to match to the height
#'   while keeping the aspect ratio.
#'   Note that odd resolution is not supported due to
#'   the limitation of video compression format.
#' @param h An integer. The height of the resized video.
#'   Default `-2`, meaning to match to the width
#'   while keeping the aspect ratio.
#'   Odd value is not supported as in the case of the width.
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
#' @return Strings. The names of the created avi files.
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
	warning("No resize performed according to the missing width *and* height")
	return(invisible(infiles))
}

w <- w + ifelse(w > 0, w %% 2, 0)
h <- h + ifelse(h > 0, h %% 2, 0)

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
