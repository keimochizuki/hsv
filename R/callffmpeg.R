#' Call FFmpeg with a given command
#'
#' [callffmpeg()] performs actual call for FFmpeg software
#' using [base::system()].
#' It also generates some console outputs,
#' asking the users to wait for a second,
#' or telling them about errors during system call.
#'
#' @param cmd A string. The command passed to FFmpeg.
#'
#' @keywords utilities internal

callffmpeg <- function(

	cmd

) {

f <- sub("^.*[ ]+([^ ]+)[ ]*$", "\\1", cmd)
cmd <- paste('ffmpeg -hide_banner -y', cmd)

cat("Exporting ", f, ", please wait\n", sep = "")
cat(getwd(), " > ", cmd, "\n", sep = "")
utils::flush.console()

rslt <- system(cmd)
cat("\n")
utils::flush.console()

if (rslt != 0) {
	stop(paste("Failed to export", f))
}

invisible()
}
