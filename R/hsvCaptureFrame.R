#' Extract video frames as still images
#'
#' [hsvCaptureFrame()] extracts designated frames of the provided
#' movie file as still images.
#'
#' @param infiles Strings. The names of the avi files you want to screenshot.
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
		fr <- hd[[31]] / hd[[30]] # Rate / Scale
		tf <- hd[[33]] # Length in avi video stream header
	} else if (grepl("\\.mp4$", infiles[i], ignore.case = TRUE)) {
		hd <- hsvGetMp4Header(infiles[i])
		fr <- eval(parse(text = hd$r_frame_rate))
		tf <- as.integer(hd$nb_frames)
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
