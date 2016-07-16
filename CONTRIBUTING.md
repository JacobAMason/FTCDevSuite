# Contributing
Thanks for being willing to contribute to this project, whether through pointing out its problems or adding to the source. Your contribution is very much appreciated.

## Issues
Please make Issues as detailed as possible to facilitate quick responses. If you've done a little troubleshooting yourself, let us know. Additionally, if your installer completes, right click in the embedded log (the one that printed out a bunch of text in the last step of the installer), [create a Gist](https://gist.github.com/), and link the Gist to the new Issue. This will keep the issues easy to read.

## Pull Requests
I am happy to merge PRs given they consist of small commits with well-written commit messages. The PR itself should be detailed enough that I can read it and get a general idea for what the code will do without having to look at it.

## Development
To get started developing on this installer, you'll only need two things: a Windows computer and Git--you probably have both.  You also only have to do two things:

1) Clone the repository
```
git clone https://github.com/JacobAMason/FTCDevSuite.git
```
2) Open Command Prompt to the project directory (either Android-Studio or App-Inventor) and run 'build.bat'
```
C:\Users\Contributor\FTCDevSuite\Android-Studio> build.bat
```

## Versioning
We're using annual versioning because FIRST Tech Challenge operates annually, therefore, this method of versioning will make it easier to figure out if the installer on your flash drive is from this season or last season.
The version number will be in the format `YYYY.R.B` where `YYYY` is the year the FIRST Tech Challenge season begins, `R` is the release number, and `B` is the ftc_app branch name. The branch name is only applicable to Android Studio installers and will only be present is the branch is not `master`.

## Roadmap
I'm toying with the idea of including other tools in this installer as well, the first being Git. It's good to get in the habit of using Git early on, but if you're reading this, you probably already know that.  I'm also considering packaging in other very well-formed packages written by other teams. This would probably come in the form of an optional install component disabled by default. My primary concern, however, is to keep the size of the Full installer to a minimum. A time may soon come when these two installers  begin to diverge even more.
