﻿$path = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$($path);$($Env:ANDROID_HOME)\tools;$($Env:ANDROID_HOME)\platform-tools", "Machine")

