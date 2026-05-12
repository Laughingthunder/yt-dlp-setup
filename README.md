# yt-dlp Setup
A simple (public-domain) Windows batch script to automatically download or update `yt-dlp` alongside its `ffmpeg` and `deno` dependencies for MPC-HC and similar use-cases.
## Usage
Download or clone this repository, and copy the included `yt-dlp` directory to the location on your system where you would like `yt-dlp` to reside. Then, run `yt-dlp-setup.bat` within the newly copied directory. Copying the contents of the `yt-dlp` directory alongside `MPC-HC` and then running `yt-dlp-setup.bat` is also supported for portable copies of `MPC-HC`.

yt-dlp Setup will then automatically detect your system (32 or 64-bit) and download the appropriate versions of both `yt-dlp` and the recommended `ffmpeg` build (for full `yt-dlp` functionality). On 64-bit versions of Windows, the script also downloads and updates `deno`, for full YouTube support.

When done, both `yt-dlp`, and any downloaded components, will reside in the `yt-dlp` directory alongside `yt-dlp-setup.bat`. You can also re-run `yt-dlp-setup.bat` at any time, and it will update all downloaded components as needed.

## License
This script is released into the public domain, matching [yt-dlp's license](https://github.com/yt-dlp/yt-dlp/blob/master/LICENSE).
## Dependencies:
All dependencies are GPL-licensed, and have been included for convenience.
- wget.exe (included or easily found online)
- 7za.exe (7-Zip standalone command-line version)