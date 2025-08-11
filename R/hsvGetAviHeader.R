#' Checker of avi header information
#'
#' Extracts header information of the first video stream
#' in an avi file.
#'
#' An avi file starts with a header data with a predetermined
#' format, followed by the actual video data field.
#' A lot of useful meta information can be obtained from avi header.
#' In general, media player softwares utilizes this information
#' to play the video.
#' However, how actual playback relies on the header information is
#' highly variate among video player softwares.
#' Also, such softwares normally show *post-molded* video properties
#' to users, instead of the raw binary values.
#' Therefore, I wrote a naive extractor of header information
#' which would be useful in confirming video format and properties.
#'
#' @param infile A string. The name of the avi file you want to
#'   read header information.
#' @param verbose A logical. Whether to print the extracted values
#'   on the console lines.
#'
#' @return A list. Extracted header information.
#'
#' @examples
#' \dontrun{
#' hsvGetAviHeader("input.avi", verbose = TRUE)
#' }
#'
#' @keywords utilities
#'
#' @export

hsvGetAviHeader <- function(

	infile,
	verbose = FALSE

) {

if (!grepl("\\.avi$", infile, ignore.case = TRUE)) {
	stop("Non-avi file designated, stopping further processing.")
}
if (!file.exists(infile)) {
	stop("Non-existing file designated, stopping further processing.")
}

val <- matrix(c(
	"RIFF ID",          "char", 4, NA,
	"Size",             "int",  1, 4,
	"Format",           "char", 4, NA,
	"List ID",          "char", 4, NA,
	"Length",           "int",  1, 4,
	"Header ID",        "char", 4, NA,
	"AVI Header ID",    "char", 4, NA,
	"Length",           "int",  1, 4,
	"usecs Per Frame",  "int",  1, 4,
	"Max Byte Rate",    "int",  1, 4,
	"Reserved 1",       "int",  1, 4,
	"Flags",            "int",  1, 4,
	"Total Frames",     "int",  1, 4,
	"Initial Frame",    "int",  1, 4,
	"Streams",          "int",  1, 4,
	"Buffer Size",      "int",  1, 4,
	"Width",            "int",  1, 4,
	"Height",           "int",  1, 4,
	"Reserved",         "int",  4, 4,
	"List ID",          "char", 4, NA,
	"Length",           "int",  1, 4,
	"Stream List",      "char", 4, NA,
	"Stream Header",    "char", 4, NA,
	"Length",           "int",  1, 4,
	"Type",             "char", 4, NA,
	"Handler",          "int",  1, 4,
	"Flags",            "int",  1, 4,
	"Priority",         "int",  1, 4,
	"Initial Frames",   "int",  1, 4,
	"Scale",            "int",  1, 4,
	"Rate",             "int",  1, 4,
	"Start",            "int",  1, 4,
	"Length",           "int",  1, 4,
	"Buffer Size",      "int",  1, 4,
	"Quality",          "int",  1, 4,
	"Sample Size",      "int",  1, 4,
	"Frame",            "int",  4, 2,
	"Stream Format",    "char", 4, NA,
	"Length",           "int",  1, 4,
	"Size",             "int",  1, 4,
	"Width",            "int",  1, 4,
	"Height",           "int",  1, 4,
	"Planes",           "int",  1, 2,
	"Bit Count",        "int",  1, 2,
	"Compression",      "int",  1, 4,
	"Image Size",       "int",  1, 4,
	"X Pels Per Meter", "int",  1, 4,
	"Y Pels Per Meter", "int",  1, 4,
	"Colors Used",      "int",  1, 4,
	"Colors Important", "int",  1, 4),
	ncol = 4, byrow = TRUE)
colnames(val) <- c("name", "type", "n", "size")
val <- as.data.frame(val)
val$n <- as.integer(val$n)
val$size <- as.integer(val$size)

f <- file(infile, open = "rb")
on.exit(close(f))
reader <- function(type, n, size) {
	if (type == "char") {
		return(readChar(f, n))
	} else {
		return(readBin(f, what = "integer", n = n, size = size, endian = "little"))
	}
}
v <- mapply(FUN = reader, val$type, val$n, val$size, SIMPLIFY = FALSE)
names(v) <- val[, 1]

if (verbose) {
	z <- data.frame(entry = names(v), value = sapply(v, paste, collapse = " "))

	cat("The RIFF Header\n")
	print(z[1:3,])
	cat("\nThe Header List\n")
	print(z[4:6,])
	cat("\nThe AVI Header\n")
	print(z[7:8,])
	cat("\nAVI Main Header\n")
	print(z[9:19,])
	cat("\nThe Video Stream List\n")
	print(z[20:24,])
	cat("\nThe AVI Video Stream Header\n")
	print(z[25:39,])
	cat("\nThe AVI Video Stream Format\n")
	print(z[40:50,])
}

invisible(v)
}
