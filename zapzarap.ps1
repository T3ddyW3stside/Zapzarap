# Ausführung .exe: C:\Windows\appcompat\pca
# Auflistung aller ausführung Aktionen C:\Windows\System32\sru
# Amcache: %SystemRoot%\AppCompat\Programs\
<#
param (
    [switch]$Light,
    [switch]$Medium,
    [switch]$High
)

Write-Host "****************************************************"
Write-Host "    Zapzerap PowerShell file collector              "
Write-Host "****************************************************"
Write-Host ""

# Src_Folder
$lightSourceFolders = @(
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations"), # JumpLists
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine"), # PowerShell History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Microsoft\Terminal Server Client\Cache"), # RDP Bitmap Cache
    (Join-Path -Path $env:USERPROFILE -ChildPath "AppData\Local\ConnectedDevicesPlatform") # Activity Cache
    
)

$mediumSourceFolders = @(
    (Join-Path -Path $env:SystemRoot -ChildPath "\appcompat\pca"), # execution .exe files
    (Join-Path -Path $env:SystemRoot -ChildPath "\System32\winevt\Logs"), # Windows Event Logs
    (Join-Path -Path $env:SystemRoot -ChildPath "\System32\sru") # execution and duration of .exe files execution
)
$highSourceFolders = @(
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_high"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_high1"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_high2"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_high3"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_high4")
)

# Zip_Files
function ZipFolders($sourceFolders, $destinationFolder) {
    foreach ($sourceFolder in $sourceFolders) {
        $sourceFolderName = (Get-Item $sourceFolder).Name
        $hostName = [System.Net.Dns]::GetHostName()
        $zipFileName = "$sourceFolderName-$hostName.zip"

        if (Test-Path -Path $sourceFolder -PathType Container) {
            Compress-Archive -Path $sourceFolder -DestinationPath (Join-Path -Path $destinationFolder -ChildPath $zipFileName) -Force
            Write-Host "The archive was successfully created: $zipFileName"
        } else {
            Write-Host "The specified source folder does not exist: $sourceFolder"
        }
    }
}

# Des_Folder
if ($Light) {
    ZipFolders $lightSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "\Desktop\dest")
}

if ($Medium) {
    ZipFolders $mediumSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "\Desktop\dest")
}

if ($High) {
    ZipFolders $highSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "\Desktop\dest")
}
#>

param (
    [switch]$Light,
    [switch]$Medium,
    [switch]$High
)


Write-Host "****************************************************"
Write-Host "    Zapzerap PowerShell file collector              "
Write-Host "****************************************************"


# Temporäres Verzeichnis für die Event Logs
$tempEventLogDir = Join-Path -Path $env:TEMP -ChildPath "EventLogs"

# Event Logs Quellverzeichnisse
$lightSourceFolders = @(
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations"), # JumpLists
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine"), # PowerShell History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Microsoft\Terminal Server Client\Cache") # RDP Bitmap Cache    
)

$mediumSourceFolders = @(
    (Join-Path -Path $env:SystemRoot -ChildPath "\appcompat\pca"), # Ausführung von .exe-Dateien
    $tempEventLogDir, # Temporäres Verzeichnis für Event Logs
    (Join-Path -Path $env:SystemRoot -ChildPath "\System32\sru") # Ausführung und Dauer der Ausführung von .exe-Dateien
)

$highSourceFolders = @(
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations"), # JumpLists
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine"), # PowerShell History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Microsoft\Terminal Server Client\Cache"), # RDP Bitmap Cache
    (Join-Path -Path $env:SystemRoot -ChildPath "\appcompat\pca"), # Ausführung von .exe-Dateien
    $tempEventLogDir, # Temporäres Verzeichnis für Event Logs
    (Join-Path -Path $env:SystemRoot -ChildPath "\System32\sru") # Ausführung und Dauer der Ausführung von .exe-Dateien
)

# Event Logs in temporäres Verzeichnis kopieren
if ($Medium) {
    if (-not (Test-Path -Path $tempEventLogDir -PathType Container)) {
        New-Item -Path $tempEventLogDir -ItemType Directory | Out-Null
    }
    
    Copy-Item -Path "C:\Windows\System32\winevt\Logs\*" -Destination $tempEventLogDir -Recurse -Force
    Write-Host "Event Logs copied to temporary directory: $tempEventLogDir"
}

# Zip_Files
function ZipFolders($sourceFolders, $destinationFolder) {
    foreach ($sourceFolder in $sourceFolders) {
        $sourceFolderName = (Get-Item $sourceFolder).Name
        $hostName = [System.Net.Dns]::GetHostName()
        $zipFileName = "$sourceFolderName-$hostName.zip"

        if (Test-Path -Path $sourceFolder -PathType Container) {
            Compress-Archive -Path $sourceFolder -DestinationPath (Join-Path -Path $destinationFolder -ChildPath $zipFileName) -Force
            Write-Host "The archive was successfully created: $zipFileName"
        } else {
            Write-Host "The specified source folder does not exist: $sourceFolder"
        }
    }
}

# Des_Folder
if ($Light) {
    ZipFolders $lightSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "\Desktop\dest")
}

if ($Medium) {
    ZipFolders $mediumSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "\Desktop\dest")
}

if ($High) {
    ZipFolders $highSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "\Desktop\dest")
}

# Temporäres Event Log-Verzeichnis entfernen
if ($Medium) {
    Remove-Item -Path $tempEventLogDir -Force -Recurse
    Write-Host "Temporary Event Logs directory removed: $tempEventLogDir"
}
