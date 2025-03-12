# yt-dlp Setup
A simple (public-domain) Windows batch script to automatically download or update `yt-dlp` and its `ffmpeg` dependencies for MPC-HC and similar use-cases.
## Usage
Download or clone this repository, and copy the included `yt-dlp` directory to the location on your system where you would like `yt-dlp` to reside. Then, run `yt-dlp_setup.bat` within the newly copied directory. It'll automatically detect your system (32 or 64-bit) and download the appropriate versions of `yt-dlp` and the recommended `ffmpeg` build (for full `yt-dlp` functionality).

When done, both `yt-dlp` and `ffmpeg` will reside in the `yt-dlp` directory alongside `yt-dlp_setup.bat`. You can also re-run `yt-dlp_setup.bat` at any time, and it will update both `yt-dlp` and `ffmpeg` as needed.

TIP: If you leave the downloaded zip archive containing `ffmpeg` in place, the batch script will check whether or not `ffmpeg` has been updated, and only download it again if so.
## License
This script is released into the public domain, matching [yt-dlp's license](https://github.com/yt-dlp/yt-dlp/blob/master/LICENSE).
## Dependencies:
All dependencies are GPL-licensed, and have been included for convenience.
- wget.exe (included or easily found online)
- 7za.exe (7-Zip standalone command-line version)