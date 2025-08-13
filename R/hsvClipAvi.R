#' Clip a portion of video range
#'
#' `hsvClipAvi()` extracts designated time range of videos
#' and create new avi files
#' from designated video sources.
#'
#' This function clips designated range in the input avi files,
#' without performing any other video conversion.
#' Such video clipping is often referred to in many different ways
#' like cutting, splitting, splicing, and trimming.
#' In certain occasions, all these words can be used
#' as practically the same meaning.
#' But in other situation, each can have different meaning.
#' To avoid confusion with cropping in spatial domain,
#' this process may be better referred to as "temporal trimming".
#'
#' No matter how it is called, anyway, `hsvClipAvi()` extracts
#' a limited time range from video files.
#' It can be used, for example, to cut off certain range of
#' the video data to which you want to perform further analyses.
#'
#' Since no conversion is performed (with `-c copy` option in `ffmpeg`),
#' this function normally takes not so long.
#' However, as a drawback of it, clipped videos may not strictly start
#' from the first frame of the designated clipping range.
#' This is due to the limitation of FFmpeg itself.
#' The `copy` option mentioned above prevent any conversion
#' of the input video stream.
#' Therefore, clipping can only be started from the nearest
#' preceding keyframes in the original files.
#' (Otherwise, video conversion would be necessary.)
#' If the input files are raw (typically very huge) avi files
#' with no video compression, this limitation does not matter
#' since all the frames are technically keyframes in such a case.
#'
#' @param infiles Strings. The names of the avi files you want to clip.
#' @param from An integer. The index of the frame (frame number)
#'   in the input file from where the clipped video starts.
#' @param to An integer. The index of the frame (frame number)
#'   in the input file to where the video should be clipped.
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

hsvClipAvi <- function(

	infiles,
	from,
	to,
	suffix = paste(from, to, sep = "-"),
	keepinfiles = TRUE,
	savedir = "."

) {

checkinfiles(infiles)
savedir <- checksavedir(savedir)

outfiles <- sub("\\.avi$", sprintf("_%s.avi", suffix), basename(infiles), ignore.case = TRUE)
outfiles <- file.path(savedir, outfiles)

for (i in seq(along = infiles)) {
	hd <- hsvGetAviHeader(infiles[i])
	fr <- hd$Rate / hd$Scale
	tf <- hd$`Total Frames`

	cmd <- paste(
		'-ss ', frame2time(from, fr, tf),
		' -to ', frame2time(to + 1, fr, tf),
		' -i "', infiles[i],
		'" -c copy "', outfiles[i], '"', sep = "")
	callffmpeg(cmd)
}

if (!keepinfiles) {
	file.remove(infiles)
}

invisible(outfiles)
}
