#' Extract video frames as still images
#'
#' [hsvCaptureFrame()] extracts designated frames of the provided
#' movie file as still images.
#'
#' When analyzing video data, you may want to take "photocopies" of
#' certain frames of the source video as still images.
#' Video player applications normally hold such functionality
#' called "snapshot" or "screen capture".
#' However, it is more handy to perform such conversion within
#' your script.
#'
#' [hsvCaptureFrame()] helps achieve this goal.
#' This function simply uses built-in format conversion utility of
#' original FFmpeg software.
#' Extracted image format is automatically set by the extension
#' of output files designated by `ext` argument.
#'
#' Unfortunately, after some while since this function was implemented,
#' the author recognized that the conversion process sometimes fails.
#' This failure is totally input-dependent.
#' For some video files, the output becomes complete blank images
#' with the same width and height to the source video.
#' Since this is the problem of FFmpeg per se, the author has no way
#' to personally deal with this phenomenon.
#' (It is really strange that `ffmpeg` fails to extract images from
#' the video source, with which she can perform clipping, cropping,
#' or any other video-based handling as usual.)
#' Currently, the valid and easy detour is to first convert the source
#' avi video to mpeg4 format with [hsvAviToMp4()],
#' and then use [hsvCaptureFrame()] to it.
#'
#' @param infiles Strings. The names of the video files you want to
#'   capture images from.
#' @param frames Integers. The index of the frames to extract.
#' @param ext A string. The extension of output image files.
#' @param suffix A string. The suffix for the names of image files
#'   concatenated to the names of input movie files.
#'   Should be a format string for frame numbers to enable multi-frame export.
#'   (e.g., "%05d" for zero-padded five-digit frame indices.)
#'   Otherwise, export of all image files will be done with
#'   the same filename, overwriting the previous image repeatedly.
#' @param keepinfiles A logical. Whether to keep the input files
#'   after the conversion.
#' @param savedir A string. The path to the directory
#'   you want to save the output file(s).
#'
#' @return A list of strings. The names of the created image files.
#'
#' @examples
#' \dontrun{
#' hsvCaptureFrame("video.avi", frames = seq(1, 1000, by = 50))
#' }
#'
#' @keywords utilities
#'
#' @export

hsvCaptureFrame <- function(

	infiles,
	frames,
	ext = "png",
	suffix = paste("%0", floor(log10(max(frames))) + 1, "d", sep = ""),
	keepinfiles = TRUE,
	savedir = "."

) {

checkinfiles(infiles, c("avi", "mp4"))
savedir <- checksavedir(savedir)

outfiles <- sub("\\.avi$|\\.mp4$", sprintf("_%s.%s", suffix, ext), basename(infiles), ignore.case = TRUE)
outfiles <- file.path(savedir, outfiles)
outfiles <- lapply(X = outfiles, FUN = function(z) {
	if (grepl("%0*[1-9]+d", z)) {
		return(sprintf(z, frames))
	} else {
		return(rep(z, length(frames)))
	}
})

for (i in seq(along = infiles)) {
	if (grepl("\\.avi$", infiles[i], ignore.case = TRUE)) {
		hd <- hsvGetAviHeader(infiles[i])
		fr <- hd$Stream_Rate / hd$Stream_Scale
		tf <- hd$Stream_Length
	} else if (grepl("\\.mp4$", infiles[i], ignore.case = TRUE)) {
		hd <- hsvGetMp4Header(infiles[i])
		fr <- eval(hd$r_frame_rate)
		tf <- hd$nb_frames
	} else {
		stop(paste("Header information not available for", infiles[i]))
	}

	cmd <- paste(
		'-ss ', sapply(X = frames, FUN = frame2time, framerate = fr, totalframes = tf),
		' -i "', infiles[i],
		'" -vframes 1 "', outfiles[[i]], '"', sep = "")
	sapply(X = cmd, FUN = hsvCallFFmpeg)
	print(cmd)
}

if (!keepinfiles) {
	file.remove(infiles)
}

invisible(outfiles)
}
