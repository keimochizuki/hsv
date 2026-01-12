#' Read out avi header
#'
#' [hsvGetAviHeader()] extracts header information of
#' the first video stream in an avi file.
#'
#' An avi file starts with a header data with a predetermined
#' format, followed by the actual video data field.
#' A lot of useful meta information can be obtained from avi header.
#' In general, media player softwares utilizes this information
#' to play the video.
#' However, how actual playback is done in accordance with
#' the header information is highly variate among video player softwares.
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
#' hsvGetAviHeader("video.avi", verbose = TRUE)
#' }
#'
#' @keywords utilities
#'
#' @export

hsvGetAviHeader <- function(

	infile,
	verbose = FALSE

) {

checkinfiles(infile)

val <- matrix(c(
	"RIFF_ID",               "char", 4, NA,
	"File_Size",             "int",  1, 4,
	"File_Format",           "char", 4, NA,
	"List_ID_for_Header",    "char", 4, NA,
	"List_Length_of_Header", "int",  1, 4,
	"List_Header_ID",        "char", 4, NA,
	"Avi_Header_ID",         "char", 4, NA,
	"Avi_Header_Length",     "int",  1, 4,
	"usecs_Per_Frame",       "int",  1, 4,
	"Max_Byte_Rate",         "int",  1, 4,
	"Reserved1",             "int",  1, 4,
	"Avi_Flags",             "int",  1, 4,
	"Avi_Total_Frames",      "int",  1, 4,
	"Avi_Initial_Frame",     "int",  1, 4,
	"Number_of_Streams",     "int",  1, 4,
	"Avi_Buffer_Size",       "int",  1, 4,
	"Avi_Width",             "int",  1, 4,
	"Avi_Height",            "int",  1, 4,
	"Reserved2",             "int",  4, 4,
	"List_ID_for_Stream",    "char", 4, NA,
	"List_Length_of_Stream", "int",  1, 4,
	"List_Stream_ID",        "char", 4, NA,
	"Stream_Header_ID",      "char", 4, NA,
	"Stream_Header_Length",  "int",  1, 4,
	"Stream_Type",           "char", 4, NA,
	"Stream_Handler",        "int",  1, 4,
	"Stream_Flags",          "int",  1, 4,
	"Stream_Priority",       "int",  1, 4,
	"Stream_Initial_Frame",  "int",  1, 4,
	"Stream_Scale",          "int",  1, 4,
	"Stream_Rate",           "int",  1, 4,
	"Stream_Start",          "int",  1, 4,
	"Stream_Length",         "int",  1, 4,
	"Stream_Buffer_Size",    "int",  1, 4,
	"Stream_Quality",        "int",  1, 4,
	"Stream_Sample_Size",    "int",  1, 4,
	"Stream_Frame",          "int",  4, 2,
	"Stream_Format",         "char", 4, NA,
	"Stream_Length",         "int",  1, 4,
	"Stream_Size",           "int",  1, 4,
	"Stream_Width",          "int",  1, 4,
	"Stream_Height",         "int",  1, 4,
	"Stream_Planes",         "int",  1, 2,
	"Stream_Bit_Count",      "int",  1, 2,
	"Stream_Compression",    "int",  1, 4,
	"Stream_Image_Size",     "int",  1, 4,
	"Stream_Xpx_per_Meter",  "int",  1, 4,
	"Stream_Ypx_per_Meter",  "int",  1, 4,
	"Stream_Cols_Used",      "int",  1, 4,
	"Stream_Cols_Important", "int",  1, 4),
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
