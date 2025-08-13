#' Frame-rate changer for avi files
#'
#' Change frame rate (and optionally real-time frame length)
#' of designated avi video files.
#'
#' *** Be careful that this function DIRECTLY perform BINARY EDITING
#' on designated original files! ***
#'
#' Frame rate setting of a video file determines how frequently
#' video screen is refreshed by the next one.
#' The rate is designated the number of screen refresh
#' per second, i.e., frames per second or fps.
#' There are several standard values of the frame rate
#' such as 24 (23.98) fps for movie films
#' and 30 (29.97) fps for Japanese television broadcasting.
#' Recent ultra-high-definition television often has
#' more higher frame rate such as 60 (59.94) fps.
#'
#' In a simplest case, you will suppose that the frame rate
#' of a video should naturally be the same as
#' the rate with which the video was captured.
#' For example, an ultra-high-definition program will be filmed
#' with 60 fps camera, so that it can be watched at 60 fps
#' playback speed.
#' However, the situation is often different in the case of
#' high-speed videos.
#' If you film a video with 200 fps, for instance,
#' you normally do not watch the video with the same frame rate.
#' Your display is not likely to support such high refresh rate.
#' In the first place, the reason you take high-speed recording is
#' that you want to make a detailed inspection on the subject
#' in the temporal domain.
#' In this case, you can select to watch the video with a lower frame rate,
#' resulting in a slow-motion view of the movement of the subject.
#'
#' Like this example, there are often times that the frame rate is
#' different between original filming rate and later playback rate,
#' especially in the case of high-speed videos.
#' (But it can happen in normal-speed videos, of course.)
#' For this purpose, I constructed a function that directly modify
#' the header information of avi files to change the frame rate setting.
#' Since the frame rate is determined by a division beween to parameters
#' RATE/SCALE, this function also receive corresponding two values.
#' This kind of parameter format (representing a quasi-real value by
#' division between two large integer values) is a kind of tradition in
#' computer science where real numbers are avoided.
#' If you simply want an integer frame rate,
#' just setting `rate` argument as that value is fine
#' because the `scale` is by default set as 1.
#' If you want a real value for the frame rate such as 29.97,
#' please use both `rate` and `scale` arguments,
#' since both parameters need to be designated in integer.
#'
#' Note that, as mentioned above, this function directly modify
#' the header information of avi files, instead of
#' converting the video with `ffmpeg` command.
#' This is due to the tricky behavior of FFmpeg
#' in changing frame rate of a video file.
#' If you convert a video to a lower frame rate (with `-fps` option),
#' FFmpeg automatically downsamples (i.e., intermittently deletes)
#' the original frames to fit the designated frame rate.
#' Conversely, if you convert a video to a higher frame rate,
#' FFmpeg interpolates lacking frames.
#' Neither is my intention.
#' What I want is that, without losing or adding any frames,
#' just to change the playback rate of the video.
#' In other words, no "conversion" of video data is actually
#' required here, except for just changing the apparent speed
#' of the inter-frame refresh.
#' This is why [hsvChangeFrameRate()] does not use `ffmpeg`
#' but directly modify the meta information
#' engraved in the header field.
#' Also, it takes only a blink of an eye regardless of
#' the massive file size of the input,
#' since the function merely modify a few bytes of information
#' at the very beginning of the file.
#'
#' Based on these reasons, however, users should pay attention when
#' using this function, because it directly modify the designated
#' files per se.
#' Although the function is designed not to touch any of the
#' actual video data field, there is a possibility that
#' it accidentally ruins the files by inappropriate binary editing.
#' Thus, the author personally does not recommend to
#' use it directly to your original avi files.
#'
#' In addition to setting the frame rate,
#' [hsvChangeFrameRate()] also take another argument named `usperframe`.
#' If provided, this value is used to set another meta data field
#' in the avi header.
#' As the name indicates, this value should be the real-time
#' length of each frame in microsecond.
#' Since this value does not seem to actually affect the playback rate
#' in most video player softwares,
#' you can leave this field untouched when you change the frame rate.
#' (In fact, changing mere refresh rate during playback
#' actually does not have anything to do with original real-time length
#' the frames correspond to.)
#' Or, you can use the functionality to correct this field of information
#' not properly set during original recording.
#' For example, in the author's recording system, the cameras set
#' this field as 33000 us although actual sampling rate is 200 fps.
#' In this case, I can set `usperframe` as 5000 (= 5 milliseconds)
#' to correct the field.
#'
#' @param infiles Strings. The names of the avi files
#'   you want to change the frame rate.
#' @param rate An integer. RATE parameter for avi header.
#'   This equals the actual frame rate of the video
#'   when SCALE parameter is 1 (default),
#'   since the frame rate is determined by RATE/SCALE.
#' @param scale An integer. SCALE parameter for avi header.
#'   This becomes a denominator for frame rate calculation.
#' @param usperframe An integer. Actual (real-time) length
#'   of a frame in millisecond optionally set in avi header.
#'
#' @examples
#' \dontrun{
#' hsvChangeFrameRate("input.avi", rate = 200, usperframe = 5000)
#' }
#'
#' @keywords utilities
#'
#' @export

hsvChangeFrameRate <- function(

	infiles,
	rate = NULL,
	scale = 1,
	usperframe = NULL

) {

if (!all(grepl("\\.avi$", infiles, ignore.case = TRUE))) {
	stop("Non-avi file(s) designated, stopping further processing")
}
if (!all(file.exists(infiles))) {
	stop("Non-existing file(s) designated, stopping further processing")
}

if (!is.null(rate)) {
	rate <- packBits(intToBits(round(rate)), "integer")
}
scale <- packBits(intToBits(round(scale)), "integer")
if (!is.null(usperframe)) {
	usperframe <- packBits(intToBits(round(usperframe)), "integer")
}

for (filename in infiles) {
	f <- file(filename, open = "r+b")

	if (!is.null(usperframe)) {
		seek(f, where = 32, rw = "w")
		writeBin(usperframe, f, endian = "little")
	}

	if (!is.null(rate)) {
		seek(f, where = 128, rw = "w")
		writeBin(scale, f, endian = "little")
		writeBin(rate, f, endian = "little")
	}

	close(f)
}

invisible()
}
