#' Extractor of clipped vedio from an avi file 
#'
#' Extracts designated range of video and create a new avi file
#' from designated input source avi.
#'
#' This function clips designated range in the input avi
#' into a new file, without performing any other video conversion.
#' It can be used, for example, to cut off certain range of the
#' video file to where your further analyses are applied.
#' Since no conversion is performed (with `-c copy` option in `ffmpeg`),
#' this function normally takes not so long.
#'
#' @param infile A string. The name of the avi file you want to clip.
#' @param outfile A string. The name of the output avi file.
#' @param from An integer. The index of the frame (frame number)
#'   in the input file from where the clipped video starts.
#' @param to An integer. The index of the frame (frame number)
#'   in the input file to where the video should be clipped.
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

	infile,
	outfile = "output.avi",
	from,
	to

) {

info <- system(paste('ffprobe -hide_banner -v error -i "', infile,
	'" -select_streams v:0 -show_entries stream=r_frame_rate,duration -of csv',
	sep = ""),
	intern = TRUE)
info <- strsplit(info, ",")[[1]][-1]
names(info) <- c("r_frame_rate", "duration")

framerate <- eval(parse(text = info["r_frame_rate"]))
duration <- as.numeric(info["duration"])

frame2time <- function(n) {
	s <- n / framerate
	if (s < 0) {
		s <- 0
	}
	if (s > duration) {
		s <- duration
	}
	ms <- round((s - floor(s)) * 1000)
	s <- floor(s)

	m <- s %/% 60
	s <- s %% 60

	h <- m %/% 60
	m <- m %% 60

	return(sprintf("%02d:%02d:%02d.%03d", h, m, s, ms))
}

cmd <- paste('ffmpeg -hide_banner -y -ss ', frame2time(from),
	' -to ', frame2time(to + 1), ' -i "', infile,
	'" -c copy "', outfile, '"', sep = "")
cat(getwd(), " > ", cmd, "\n", sep = "")
flush.console()

rslt <- system(cmd)
cat("\n")
flush.console()

if (rslt != 0) {
	stop(paste("error in exporting", outfile))
}

invisible(outfile)
}
