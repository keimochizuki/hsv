#' Make example avi videos
#'
#' [hsvMakeExampleAvi()] creates a set of two
#' high-speed videos in avi format.
#' These files can be used for your test purpose
#' in writing script with hsv package.
#' This may be handy because you do not need to
#' worry about these test files.
#' There are no worries about accidental file crash,
#' leakage of your experimental results,
#' intrusion of privacy, or whatever.
#'
#' @param savedir A string. The path to the directory
#'   you want to save the output files.
#'
#' @return Strings. The names of the created avi files.
#'
#' @examples
#' \dontrun{
#' hsvMakeExampleAvi()
#' }
#'
#' @keywords utilities
#'
#' @export

hsvMakeExampleAvi <- function(

	savedir = "."

) {

savedir <- checksavedir(savedir)

outfiles <- file.path(savedir, sprintf("video%d.avi", 1:2))

set.seed(1)
n <- 1000

dat <- cbind(
	x = sin(seq(0, 10 * pi, length.out = n)),
	y = cos(seq(0, 8 * pi, length.out = n)),
	z = cos(seq(0, 2 * pi, length.out = n)))
lim <- range(dat)

rs <- c(-30, 30)
col <- c("lightsteelblue1", "thistle1")

for (r in 1:2) {
	cat("Drawing source plots, this may take a while ")
	utils::flush.console()

	plotpsp <- function() {
		return(graphics::persp(x = lim, y = lim, z = matrix(lim[1], 2, 2),
			zlim = lim, xlab = "x", ylab = "y", zlab = "z",
			theta = rs[r], col = col[r]))
	}

	infiles <- file.path(tempdir(), "tmp%04d.png")
	grDevices::png(infiles, width = 640, height = 480)
	graphics::par(mar = rep(0, 4))

	tmp <- grDevices::trans3d(dat[, "x"], dat[, "y"], dat[, "z"], plotpsp())
	at <- graphics::par("usr")[c(1, 3)] + 0.01
	pointspsp <- function(i) {
		graphics::points(tmp$x[i], tmp$y[i], pch = 16, cex = 1.5)
		graphics::text(at[1], at[2], sprintf("frame = %04d", i), adj = c(0, 0))
	}

	pointspsp(1)	
	for (f in 2:n) {
		plotpsp()
		pointspsp(f)
		if (f %% 100 == 0) {
			cat(".")
			utils::flush.console()
		}
	}
	grDevices::dev.off()
	cat("\n")
	utils::flush.console()

	callffmpeg(paste('-r 200 -i "', infiles, '" ',
		'-vcodec mjpeg -qscale 0 "', outfiles[r], '"', sep = ""))
}

invisible(outfiles)
}
