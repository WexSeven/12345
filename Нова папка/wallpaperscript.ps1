# wallpaper.ps1
# This script changes the desktop wallpaper on Windows.

param (
    [string]$imagePath = "C:\Images\SchoolWallpaper.png"
)

# Check if the file exists
if (-not (Test-Path $imagePath -PathType Leaf)) {
    Write-Error "Error: The specified image file does not exist at '$imagePath'."
    exit 1
}

# Define the registry path for desktop wallpaper settings
$registryPath = "HKCU:\Control Panel\Desktop"

# Set the wallpaper style (0=Center, 2=Stretched, 6=Fit, 10=Fill, 0=Tile)
# We'll use 2 for Stretched as a common default, but you can change this.
Set-ItemProperty -LiteralPath $registryPath -Name WallpaperStyle -Value 2
Set-ItemProperty -LiteralPath $registryPath -Name TileWallpaper -Value 0 # 0 for no tile, 1 for tile

# Set the actual wallpaper path
Set-ItemProperty -LiteralPath $registryPath -Name Wallpaper -Value $imagePath

# Refresh the desktop to apply the changes without restarting Explorer
# This sends a WM_SETTINGCHANGE message to all top-level windows
$code = '[DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);'
$type = Add-Type -MemberDefinition $code -Name "WinAPI" -Namespace "Desktop" -PassThru
$type::SystemParametersInfo(20, 0, $imagePath, 3) # SPI_SETDESKWALLPAPER = 20, SPIF_UPDATEINIFILE = 1, SPIF_SENDCHANGE = 2
Write-Host "Wallpaper successfully changed to '$imagePath'."
