# FTC Development Suite
This project was born out of the need to have an easy button that would setup all the tools necessary to start developing the FTC Android App. The app itself can be found here: http://github.com/ftctechnh/ftc_app
At the beginning of this season, the largest problem that teams seemed to be having with the new software was its complex setup process. A very specific set of tools had to be downloaded and installed to even get the application to build for the first time. Usually, this was just a matter of following the proper setup instructions and usually [fighting the IMLs included by the repository](https://github.com/ftctechnh/ftc_app/pull/12#issuecomment-153127094)

This "suite" is really just a Windows-specific installer built with [NSIS]([http://nsis.sourceforge.net/).  If time allows, I will attempt to repeat this effort for other operating systems, but if you are so inclined  and want to beat me to it, feel free.

[**Download Latest FTC Development Suite Release**](https://github.com/JacobAMason/FTCDevSuite/releases/latest)

### What does this set up for me?

 - [Java 8 (JDK and JRE 1.8.0)](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
 - [Android Studio 2.3.0](https://developer.android.com/studio/index.html)
 - Android SDK Tools which includes the following:
   - Platform Tools
   - Android API 19 (for the ZTE Speed)
   - Android API 23 (for the MotoG)
   - Build Tools 23.0.3
   - Google USB Driver
 - ftc_app source code(latest at compile<sup>[1](#latest-at-compile)</sup>)

### Which installer should I use?
**Full Installer**
The Full installer is a very large (almost 1GB) executable, but it ***requires no internet connection*** to work. This is the one you should get if you're going to be at a competition with little to no internet access or at a training event with low bandwidth. Download the Full installer beforehand and put it on a 2GB or higher *high speed* flash drive.
You should also ***copy the installer*** from the flash drive onto the computer before running it. *This will result in the installer running faster.*
Even though this installer is large, keep in mind that the official Android Studio Bundle is over 1.1GB because it includes parts of the Android SDK that *you'll never use*.

**Net Installer**
If you want to use this installer to guarantee that you've set up your personal computer correctly or you are at a venue with plenty of bandwidth to spare, the Net installer is the one to pick. The best thing about this version is that it will download the ***latest release of the FTC Application*** automatically.  It also gets the latest version of the Google USB Driver and the Android SDK Platform Tools.  None of those are super important to have on the cutting edge, but it certainly doesn't hurt.

### Contact
If you have have issues with the installer either [email me](mailto:jacob@jacobmason.net) or, preferably, [open an issue](https://github.com/JacobAMason/FTCDevSuite/issues/new).


<a name="latest-at-compile">1</a>: The version of ftc_app that installs when running the Net installer is the latest version on the beta branch of the official repository. However, the version of ftc_app in the Full installer is the latest version on the beta branch *at the time the installer was* ***first*** *compiled*. If you are getting your download from the releases page, the release notes will say what version of the ftc_app is included with the Full build.
