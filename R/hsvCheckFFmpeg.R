#' Check FFmpeg availability
#'
#' `hsvCheckFFmpeg()` checks whether `ffmpeg` command is
#' available on the system.
#'
#' Since video editing of hsv package is actually performed
#' by `ffmpeg.exe`, installation of FFmpeg is mandatory.
#' Users need to not only install FFmpeg executables
#' but also modify environment variables appropriately,
#' so that `ffmpeg` command can be correctly called
#' on the system's console.
#' This function checks the availability of `ffmpeg` command
#' by trying to ask version information to it.
#'
#' If `ffmpeg` is not available, this function emits an error,
#' halting any subsequent operations.
#' Please check your system again to confirm FFmpeg installation.
#' If you have any difficuties in installation process,
#' refer to the README.md page of hsv package
#' available on the GitHub repository of the author.
#'
#' @param verbose A logical. Whether to print the standard output
#'   strings on R.
#'
#' @return A logical. Whether `ffmpeg` can be correctly called
#'   on the system console.
#'   This value is actually always `TRUE`, since this function
#'   emit an error and stop the operation when `ffmepg` is
#'   not available (instead of returning `FALSE`).
#'
#' @examples
#' hsvCheckFFmpeg()
#'
#' @keywords utilities
#'
#' @export

hsvCheckFFmpeg <- function(

	verbose = FALSE

) {

rslt <- system("ffmpeg -version", ignore.stdout = !verbose)
if (rslt != 0) {
	stop(paste("Failed to call ffmpeg with an error code", rslt))
}

return(TRUE)
}
