# hsv package

R package to edit avi video files with FFmpeg.
For quick starter, see [Quick starter](#quick-starter) section.



## General information

This is a documentation for **hsv** package
created by Kei Mochizuki.
It was created to edit avi video files,
especially those recorded with high-speed video system
in the author's laboratory[^nameorigin].
However, the package can also be exploited to deal with
normal avi files.

[^nameorigin]: This relation to "high-speed video" files lies
as an origin of the package name "hsv".
It is thus not related to Hue-Saturation-Lightness color space,
nor Herpes Simplex Virus.

The functions in this package work in a collaboration with **FFmpeg**,
which is a classical open-source and cross-platform
media converter software.
FFmpeg is a commandline CUI (Character User Interface) software
with enormous complicated options,
which must be beyond the control of beginners.
Thus, the author used R to prepare appropriate command
passed to FFmpeg by tidying up bothersome frame-to-time translation
and other error managements.
Naturally, installation of FFmpeg is necessary before
start using hsv pakcage.



## Author

Kei Mochizuki



## License

This library is free software;
you can redistribute it and/or modify it under the terms of
the GNU Lesser General Public License version 3
as published by the Free Software Foundation.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this library;
if not, see http://www.gnu.org/licenses/.



---
## Quick starter

Below is a quick guide to start using
(and also to update) hsv package on your computer.
Step 1 (installation of FFmpeg) and 2 are needed only at the very beginning
when you first start using this package.
Step 3 (installation of hsv package) is needed every time you update
the package, in addition to your first occasion.
During daily analyses, you normally start from step 4 to prepare
using the functions in hsv package.

The author personally use Unix-based operating system for every
daily use, and thus is not familiar with other systems.
However, by considering the de facto standard,
I assume Windows operating system for most users' environment
during the rest of this guide.


### 1. Install FFmpeg

**FFmpeg is mandatory for hsv package.**
If you do not have FFmpeg yet,
just follow the instruction in [Installing FFmpeg](#installing-ffmpeg) section
to get it.


### 2. Prepare GitHub access on R

If you have any experience in using R,
you may know that you can install many contributing packages
through R console's [Install package(s)...] menu.
However, that can be done only for packages which are
officially listed on R's website (CRAN, or Comprehensive R Archive Network).
Since hsv package is the author's personal product,
it is not available on CRAN,
and standard GUI (Graphical User Interface) installation is not supported.

The code of this package is published (as you are currently reading)
on GitHub website.
Fortunately, there is a functionality for R to install
miscellaneous packages from GitHub:
`install_github()` function in devtools package.
Therefore, in this step, you first prepare devtools package
for your R, and by using it,
you will be installing hsv package in the next step.

Please launch R console.
Because you are installing additional files in system directories,
it may be better to right-click the R icon and launch it with
[Run as administrator] option.
Then, install devtools package with normal procedure.
This can be done either from the [Install package(s)...]
from [Packages] tab in the menu bar,
or by typing

```r
install.packages("devtools")
```

on the console.
You may need to select a mirror server to use
during this process.
Since devtools depend on plenty of other packages,
installation of all those dependencies is performed
together automatically.
After this, you will be able to use devtools package
on your R console.
As mentioned above, this process is basically required
only for once.


### 3. Install hsv package

Now you are ready to install hsv package from
the author's GitHub.
Use `install_github()` function to do this on the R console.
This process may better be done as administrator, too,
but it depends on your usage.

```r
devtools::install_github("keimochizuki/hsv")
```

The function automatically fetch the content of hsv package
through the internet, and install it to
the same directory to other official packages.
Since (at least until now) no package is named "hsv" on CRAN,
there should not be a naming conflict.
It may take a few seconds before you see a typical message
like below.

```r
> devtools::install_github("keimochizuki/hsv")
WARNING: Rtools is required to build R packages, but is not currently installed.

Please download and install Rtools 4.4 from https://cran.r-project.org/bin/windows/Rtools/.
Downloading GitHub repo keimochizuki/hsv@HEAD
── R CMD build ──────────
WARNING: Rtools is required to build R packages, but is not currently installed.

Please download and install Rtools 4.4 from https://cran.r-project.org/bin/windows/Rtools/.
✓  checking for file 'C:\Users\username\AppData\Local\Temp\Rtmp...'
─  preparing 'hsv':
✓  checking DESCRIPTION meta-information
─  checking for LF line-endings in source and make files and shell scripts
─  checking for empty or unneeded directories
    Omitted 'LazyData' from DESCRIPTION
─  building 'hsv_0.1.0.tar.gz'

* installing *source* package 'hsv' ...
** using staged installation
** R
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (hsv)
```

The final line `DONE (hsv)` says that the package was
correctly installed.


### 4. Launch R and load the package

Start R, then use `library()` to load hsv package
like when you use ordinary packages.

```r
library("hsv")
```


### 5. Start your analyses

Now you are ready to use hsv functions
and start your own analyses.
To check that the package and FFmpeg are properly installed,
you can use `hsvCheckFFmpeg()` function as below.

```r
> hsvCheckFFmpeg()
[1] TRUE
```

You can see a list of functions in the package typing

```r
help(package = hsv)
```

as usual.
Help for each function is also available with `?` operator.

```r
?hsvChangeFrameRate
```



## Tips for reading FFmpeg output

When you call FFmpeg (either directly on the commandline or through hsv package),
a verbose output message is typically returned.
For example, when you use `hsvClipAvi()` function to clip your avi video,
you will see an output like below.

```console
D:/hsv/example > ffmpeg -hide_banner -y -ss 00:00:33.000 -to 00:01:06.000 -i "input.avi" -c copy "output.avi"
Input #0, avi, from 'input.avi':
  Duration: 00:16:03.86, start: 0.000000, bitrate: 74599 kb/s
  Stream #0:0: Video: rawvideo, pal8, 640x480, 74475 kb/s, 30.30 fps, 30.30 tbr, 30.30 tbn
Stream mapping:
  Stream #0:0 -> #0:0 (copy)
Output #0, avi, to 'output.avi':
  Metadata:
    ISFT            : Lavf61.9.107
  Stream #0:0: Video: rawvideo, pal8, 640x480, q=2-31, 74475 kb/s, 30.30 fps, 30.30 tbr, 30.30 tbn
Press [q] to stop, [?] for help
[out#0/avi @ 00000148e1bd6dc0] video:300000KiB audio:0KiB subtitle:0KiB other streams:0KiB global headers:1KiB muxing overhead: 0.009997%
frame= 1000 fps=0.0 q=-1.0 Lsize=  300030KiB time=00:00:33.00 bitrate=74480.2kbits/s speed= 388x    
```

Since this message may look a bit coercive to beginners,
I'm going to provide a short tips to gain a flavor of it.


### Command echo

Output message from FFmpeg is composed of several parts.
The first line is an echo of the actual command
that R sent to FFmpeg.

```console
D:/hsv/example > ffmpeg -hide_banner -y -ss 00:00:33.000 -to 00:01:06.000 -i "input.avi" -c copy "output.avi"
```

In this example, I tried to clip frames from 1000 to 1999,
resulting in a clipped avi file with 1000-frame length.
Since clipping range should be designated in hh:mm:ss.ms format
rather than frame numbers,
R calculated time points corresponding to 1000th and 1999th frame,
i.e., 00:00:33.000 and 00:01:06.000,
and then called FFmpeg.
This is in accord with the frame rate of the original video input,
30.30 frames/s, shown in the next part of the message
(1000 frames divided by 30.30 frame/s equals 33 seconds).


### Properties of input file(s)

The next part of lines shows the properties of input.

```console
Input #0, avi, from 'input.avi':
  Duration: 00:16:03.86, start: 0.000000, bitrate: 74599 kb/s
  Stream #0:0: Video: rawvideo, pal8, 640x480, 74475 kb/s, 30.30 fps, 30.30 tbr, 30.30 tbn
```

These lines present an overall properties of the input video
such as duration, pixel resolution, bit rate and frame rate.
For instance, you can see that the frame rate (fps, frames per second)
of the input video in this example was 30.30 as mentioned above.


### Stream mapping

The next part is a little complicated for beginners,
but not that important in the current literature.

```console
Stream mapping:
  Stream #0:0 -> #0:0 (copy)
```

These lines show the mapping of "streams" from input files to the output.
Here a "stream" refers to an element that comprises a whole media file.
For example, a standard movie clip is normally composed of
one video stream and one audio stream.
But there are movies that have selectable multiple audio streams.
(Imagine a multilingual broadcasting program, for instance.)
Since FFmpeg is a high-spec multimedia editor,
it can take multiple input files and merge arbitrary combination
of their streams into an output file.
The mapping between these input and output streams is shown in this field.

Having said that, however, `hsvClipAvi()` function basically just takes over
the stream(s) of the input to the output.
Therefore, users normally need not to pay attention to this part of information
when using hsv package.


### Properties of output file

With a similar convention to the input,
the properties of output file come next block of lines.

```console
Output #0, avi, to 'output.avi':
  Metadata:
    ISFT            : Lavf61.9.107
  Stream #0:0: Video: rawvideo, pal8, 640x480, q=2-31, 74475 kb/s, 30.30 fps, 30.30 tbr, 30.30 tbn
```

Since `hsvClipAvi()` function does not perform any conversion of data
except for temporal clipping,
you can see that this field is almost equivalent to that of the input.


### Conversion progress

Finally, there comes a group of lines telling you
the progress of media conversion process.

```console
Press [q] to stop, [?] for help
[out#0/avi @ 00000148e1bd6dc0] video:300000KiB audio:0KiB subtitle:0KiB other streams:0KiB global headers:1KiB muxing overhead: 0.009997%
frame= 1000 fps=0.0 q=-1.0 Lsize=  300030KiB time=00:00:33.00 bitrate=74480.2kbits/s speed= 388x    
```

When you use FFmpeg on standard commandline,
these row are printed one by one as conversion progresses.
When using FFmpeg through R, however,
they will appear altogether since output strings are buffered
until the command is finished.

As previously noted, `hsvClipAvi()` perform only clipping of the input
with no conversion.
Therefore, this conversion process will end very soon,
with only a few rows.
Conversely, when you use `hsvStackAvi()` function,
it takes charge of inevitable video conversion for horizontal/vertical stacking.
In that case, this part of FFmpeg's output will last for some while,
with multiple lines like below.

```console
[out#0/avi @ 000001f0bfd6ce40] video:1777KiB audio:0KiB subtitle:0KiB other streams:0KiB global headers:0KiB muxing overhead: 0.895478%
frame=  433 fps=0.0 q=-1.0 Lsize=    1793KiB time=00:00:14.22 bitrate=1032.8kbits/s speed=18.8x    
[libx264 @ 000001f0bfceccc0] frame I:2     Avg QP:19.31  size: 61714
[libx264 @ 000001f0bfceccc0] frame P:109   Avg QP:20.78  size: 10883
[libx264 @ 000001f0bfceccc0] frame B:322   Avg QP:25.46  size:  1585
[libx264 @ 000001f0bfceccc0] consecutive B-frames:  0.7%  0.5%  0.0% 98.8%
[libx264 @ 000001f0bfceccc0] mb I  I16..4: 12.5% 44.8% 42.7%
[libx264 @ 000001f0bfceccc0] mb P  I16..4:  0.3%  0.7%  0.3%  P16..4: 36.3% 14.4% 11.7%  0.0%  0.0%    skip:36.3%
[libx264 @ 000001f0bfceccc0] mb B  I16..4:  0.0%  0.0%  0.0%  B16..8: 29.2%  1.6%  0.4%  direct: 0.6%  skip:68.1%  L0:42.7% L1:50.8% BI: 6.5%
[libx264 @ 000001f0bfceccc0] 8x8 transform intra:49.6% inter:76.2%
[libx264 @ 000001f0bfceccc0] coded y,uvDC,uvAC intra: 70.1% 0.0% 0.0% inter: 10.4% 0.0% 0.0%
[libx264 @ 000001f0bfceccc0] i16 v,h,dc,p: 52% 39%  1%  8%
[libx264 @ 000001f0bfceccc0] i8 v,h,dc,ddl,ddr,vr,hd,vl,hu: 22% 25% 21%  4%  5%  6%  5%  6%  6%
[libx264 @ 000001f0bfceccc0] i4 v,h,dc,ddl,ddr,vr,hd,vl,hu: 29% 27%  7%  4%  7%  7%  7%  6%  6%
[libx264 @ 000001f0bfceccc0] i8c dc,h,v,p: 100%  0%  0%  0%
[libx264 @ 000001f0bfceccc0] Weighted P-Frames: Y:42.2% UV:0.0%
[libx264 @ 000001f0bfceccc0] ref P L0: 41.0% 25.4% 17.8% 12.3%  3.5%
[libx264 @ 000001f0bfceccc0] ref B L0: 69.9% 25.9%  4.2%
[libx264 @ 000001f0bfceccc0] ref B L1: 79.6% 20.4%
[libx264 @ 000001f0bfceccc0] kb/s:1018.92
```



---
## Example usage

After some while since I first created hsv package,
I gradually came to realize that practical utilization
of this package is still demanding for R novices.
Therefore, I decided to arrange a simple example usage
of hsv package.
Quickly going through these examples will get you to
the very railhead of your career in video-based analyses
using R and FFmpeg.


### Time clipping of a video

The most basic use of hsv package will be temporally
clipping an avi file, which was the initial motive
of creating this package.
Time clipping can be simply done by passing
the name of the video file to `hsvClipAvi()` function.
The clipping range should be provided to `from` and `to` arguments
by the indices of video frames (frame number).
For examle, you can clip the video file `input.avi`
from 500th to 999th frame as below.

```r
hsvClipAvi("input.avi", from = 500, to = 999)
```

The clipped file will be saved to the current working
directory by default.


### Clipping two videos with identical clipping range

Next, consider the case when you have two or more avi files
you want to clip with the same clipping range
(i.e., from the same starting frame number to
the same final frame number).
For example, imagine you have multiple video files that were
simultaneously recorded with a good (say, frame-perfect) synchrony.
When clipping these videos, you will want to use exactly
the same clipping range so that not to violate their synchrony.
This can be done by passing the names of all such videos
at once to `hsvClipAvi()` function, instead of calling it
multiple times.

```r
hsvClipAvi(c("input1.avi", "input2.avi"), 500, 999)
```

This will prevent accidental clipping mistakes
among a set of multiple video sources,
using different clipping ranges.


### Horizontal stacking of two videos

In a similar situation, you may want to stack
multiple video streams, so that you can simultaneously
watch a set of related videos at a glance.
This can be achieved by `hsvStackAvi()` function as follows.

```r
hsvStackAvi(c("input1.avi", "input2.avi"))
```

By switching the `horizontal` argument,
you can perform either horizontal (by default) or
vertical stacking.


### Combination of clipping and stacking

By combining the two examples above,
you can cut out required range of videos from multiple sources,
and then stack them into one "overview" video file.

```r
tmp <- hsvClipAvi(c("input1.avi", "input2.avi"), 500, 999)
hsvStackAvi(tmp, keepinfiles = FALSE)
```

The names of exported video files are inbisibly returned
by these function.
Thus you can sequentially use these functions without
taking care of the names of temporary files.
Also, in this example, the second `hsvStackAvi()` function removes
the input files after the conversion is done,
because of the negated `keepinfiles` argument.
This behavior may be beneficial in some occasion
by preventing you from being messed up
with tons of temporary files created on your disc.
`hsvClipAvi()` function (at the first line)
also has the same option,
but it is not used in this example.
No one wants to remove original input files, for sure.


### Area cropping of a video

As of version 0.2.0,
cropping of video region became available
with `hsvCropAvi()` function.
Imagine you have 640x480 video source.
The following code crops the top-left quarter of your video.

```r
hsvCropAvi("input.avi", w = 320, h = 240)
```

As written in the help document,
the vertical coordinate of an image starts from the top.
This is why the cropped region becomes **top**-left,
instead of bottom-left.


### Changing the location of cropping region

However, it should be rare that the targeted object
in your video stays at the top-left region
of the field of view.
You can control the location of cropping region
by additional arguments.

```r
hsvCropAvi("input.avi", 320, 240, xoffset = 160, yoffset = 240)
```

Two offsets determine the left (`xoffset`) and top (`yoffset`)
margins to the cropped area.
Therefore, given the size of the video source is 640x480,
this example crops the left-right center and lower half
of the video.


### Reading avi header

A lot of meta data are engraved in the header field
of an avi file.
These information can be obtained using `hsvGetAviHeader()` function.
This is useful especially when you are suspicious of
the legitimacy of the video recording.

```r
hsvGetAviHeader("input.avi", verbose = TRUE)
```

By activating `verbose` argument,
header information will be printed onto the console
in addition to the invisible return value from the function.


### Converting avi file to mp4 format

When you use videos on your presentation,
there are times that mpeg4 compression is more handy
than raw avi format.
Such conversions can be easily done by `hsvAviToMp4()` function.

```r
hsvAviToMp4("input.avi")
```

This often reduces the possibility of playback troubles
related to video codec, type of compression,
playback rate, and so on.


### Further expertise

For further understanding, I strongly recommend to read through
this README and check online helps of hsv package
to begin with.
**Take advantage of the already-existing documentation**,
before complaining about your inexperience in R language
or unfamiliarity to FFmpeg software.
The documentation exists there to help you.
That's why I have spent considerable time to
prepare documentation, which I myself personally
do not need as the author.
Please do not try to make a fool of the effort
I paid to help you.



---
## Installing FFmpeg

FFmpeg takes charge of the actual video editing
behind hsv package.
Thus, installation of FFmpeg is necessary.
If you do not have FFmpeg ready on your computer,
follow the quick guide below to install it.
If you have already had any chance to use FFmpeg before
and still have it,
please skip this process.

Since FFmpeg has originated from Unix operating system,
it does not come with Windows-like installer.
Users need to locate the software appropriately and
perform required settings by themselves.
Although these processes are not that difficult,
they can seem to be bothersome to beginners.
If you feel any difficulty, you can also try searching for the internet,
and you will find several web sites that introduce
how to install FFmpeg in detail.


### 1. Download FFmpeg

FFmpeg is an open-source free software.
You can freely download any version of FFmpeg
suitable for your environment
from the official website https://www.ffmpeg.org/.

Rather than the source code for developers and contributers,
normal users should download executable files for their own platform.
If you use Windows,
click the blue Windows icon on the left column of
the Download page https://www.ffmpeg.org/download.html
of the official website.
There can be multiple builds of FFmpeg displayed below the icon.
Essentially, either will do.

If you chose the build by Gyan Doshi, for example,
you will then face multiple options for download.
I recommend latest, full master branch build,
but it will not bring big differences.


### 2. Unzip and locate FFmpeg executables

Unzip the downloaded file to get executables.
If you chose gyan.dev build mentioned above,
then the file will come with `.7z` compression.
On modern Windows, `.7z` files can be unzipped by
just choosing [Extract All...] from the right click menu.
The extracted (root) directory of FFmpeg normally contains
`README.txt` and `LICENSE` files,
together with `bin` and `doc` directories
(and maybe other additional files and/or directories).
Inside `bin` directory are the main FFmpeg executables
such as `ffmpeg.exe` and `ffprobe.exe`.

The parent folder of `bin` and `doc` may have come
with really long, complicated name
for unique identification of the build.
I recommend renaming this folder as a simple name like `FFmpeg`.
You then need to move this folder to a location
which is suitable for executable applications.
If you do not have particular reasons,
put it simply under the main drive,
or somewhere standard on your operating system.
If you choose the former method,
resulting folder tree will look like below.

```console
C:/
├── FFmpeg/
│     ├── bin/
│     │     ├── ffmpeg.exe
│     │     ├── ffplay.exe
│     │     └── ffprobe.exe
│     ├── doc/
│     ├── LICENSE
│     └── README.txt
├── Program Files/
├── Users/
└── Windows/
```


### 3. Modify environment variable

You now have `ffmpeg.exe` (and other related executables) on your computer.
However, you still cannot use this command on the terminal,
since the system does not know its location yet.

```console
C:\Users\username> ffmpeg -version
'ffmpeg' is not recognized as an internal or external command,
operable program or batch file.
```

Therefore, you need to ask the system to search
the `FFmpeg/bin` directory for executables.
This can be done by adding the path to this directory
in the system's **environment variable**.

On Windows, open up [System] \> [About] window from the start menu.
Somewhere in the window, you will find [Advanced system settings] button.
By pushing it, a new [System Properties] dialog will appear
with its [Advanced] tab open.
At the right bottom corner of this window,
there is a button that reads [Environment Variables...].
By clicking it, you will finally see a list of environment variables
for your private account (top panel) and for all users (bottom panel).
Go [Edit...] the variables in either panel,
and append the path to the FFmpeg's `bin` directory
to the values of `Path` variable.
Close all the windows when these procedures were finished.


### 4. Test `ffmpeg` command

As you have added the path of `bin` directory that contains `ffmpeg.exe`,
the command should now be available on the terminal.
Congratulations!
You have finished installing FFmpeg.

Try `ffmpeg -version` on your terminal and
you will see version information and tons of configuration parameters
listed like below.

```console
C:\Users\username> ffmpeg -version
ffmpeg version 2025-02-26-git-99e2af4e78-full_build-www.gyan.dev
Copyright (c) 2000-2025 the FFmpeg developers built with gcc 14.2.0
(Rev1, Built by MSYS2 project)
configuration: --enable-gpl --enable-version3 ...
```



---
## Additional recommended softwares

Below is a list of other softwares
which can be handy in analyzing video files.
These softwares are not necessary,
but are the author's personal recommendation
that I usually use for my own purpose.


### Media Player Classic

Famous and classic open-source media player for Windows system.
Although often misunderstood by its name,
Media Player Classic (MPC) is completely independent
and different from Windows Media Player,
the default useless media player on Windows.

MPC was first created in 2003,
at the time of Windows XP.
It soon became popular by its support of many video codecs
and light operation.
After a long suspention of development,
MPC has now branched into two different versions that are still alive:
Home Cinema (MPC-HC) and Black Edition (MPC-BE).

Home Cinema version started after the stall of
the original MPC around 2007.
Unfortunately, MPC-HC also became inactive and outdated in the 2010s,
and officially discontinued in 2017.
Encouraged by many lament voices from the users,
its update was then resumed by one of the original developers.

Meanwhile, another developer started improving
the MPC-HC and released it as Black Edition version.
MPC-BE contains many additional functionalities
absent in the original MPC and MPC-HC.
Currently it seems to be under a passionate development.

- GitHub for MPC-HC: https://github.com/clsid2/mpc-hc/
- Download site for MPC-HC: https://www.gigafree.net/media/MediaPlayer/mediaplayerclassic.html
- Official website for MPC-BE: https://sourceforge.net/projects/mpcbe/


### Keyframe MP

Powerful media player that allows frame-by-frame
forward and backward move.
This is what many media player softwares actually cannot achieve.
Keyframe MP can be obtained freely as a demo and evaluation purpose.
You can consider purchasing the PRO license for contined use, though.

- Official website: https://zurbrigg.com/keyframe-mp

