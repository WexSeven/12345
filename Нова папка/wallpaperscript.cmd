PowerShell -Command "Set-ExecutionPolicy Unrestricted" >> "%TEMP%\StartupLog.txt" 2>&1
PowerShell C:\Images\wallpaperscript.ps1 >> "%TEMP%\StartupLog.txt" 2>&1