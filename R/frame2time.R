#' Convert frame number to timecode
#'
#' [frame2time()] converts index of video frame (frame number)
#' to timecode expression like hh:mm:ss.ms
#' based on the designated frame rate.
#' If the index exceeds the existing frame,
#' it returns the initial or final frame index instead.
#'
#' @param i An integer. The index of targeted video frame.
#' @param framerate An integer. The frame rate of the video.
#' @param totalframes An integer. The total number of frames
#'   in the video.
#'
#' @keywords utilities internal

frame2time <- function(

	i,
	framerate,
	totalframes

) {

if (i < 0) {
	i <- 0
	warning("Negative frame index designated, using the initial frame instead")
}
if (i > totalframes) {
	i <- totalframes
	warning("Frame index exceeded the total length, using the last frame instead")
}

s <- i / framerate
ms <- round((s - floor(s)) * 1000)
s <- floor(s)

m <- s %/% 60
s <- s %% 60

h <- m %/% 60
m <- m %% 60

return(sprintf("%02d:%02d:%02d.%03d", h, m, s, ms))
}
