% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hsvStackAvi.R
\name{hsvStackAvi}
\alias{hsvStackAvi}
\title{Synthesizer of juxtaposed vedio from multiple avi files}
\usage{
hsvStackAvi(
  infiles,
  outfile = "output.avi",
  keepfiles = TRUE,
  crf = 20,
  horizontal = TRUE,
  addfilt = "",
  framerate = 50
)
}
\arguments{
\item{infiles}{Strings. The names of the avi files you want to merge.}

\item{outfile}{A string. The name of the output avi file.}

\item{keepfiles}{A logical. Whether to keep the input files
after the stacking.}

\item{crf}{An integer. The constant rate factor (crf),
i.e., a value to determine the quality of the converted video
in FFmpeg (ranging from 0 to 51).
Smaller value indicate high quality video.
The default value for \code{ffmpeg} command is 23,
meaning that the default for this function is quality-oriented,
in exchange for larger file size.}

\item{horizontal}{A logical. Whether to stack the videos horizontally.
If set FALSE, videos are vertically stacked.}

\item{addfilt}{A string. Additional filter setting passed to
\code{-filter_complex} option of \code{ffmpeg}.}

\item{framerate}{An integer. The frame rate of the output avi file.}
}
\value{
A string. The names of the created avi file.
}
\description{
Stacks input avi files horizontally or vertically to create
a new, merged vedio with a juxtaposed view.
}
\details{
This function creates a stacked view from multiple input avi videos.
It is best used for the purpose to get a overview of the videos
recorded simultaneously with multiple cameras.
The input files should naturally have the same lengths.
The direction of stacking can be either horizontal (default)
or vertical.
Also, some additional conversion settings can be done
through optional arguments.
}
\examples{
\dontrun{
hsvStackAvi(c("input1.avi", "input2.avi"))
}

}
\keyword{utilities}
