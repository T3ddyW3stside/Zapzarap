<#Have to be improved#>

param (
    [switch]$Light,
    [switch]$Medium,
    [switch]$High
)


Write-Host "****************************************************"
Write-Host "    Zapzerap PowerShell file collector              "
Write-Host "****************************************************"


# Temp dir
$PrefetchCopyDir= "C:\&USERPROFILE%\Desktop\tmp"
$tempEventLogDir = Join-Path -Path $env:TEMP -ChildPath "EventLogs"
$tempPrefetch = Join-Path -Path $PrefetchCopyDir -ChildPath "Prefetch"


$lightSourceFolders = @(
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations"), # JumpLists
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine"), # PowerShell History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Microsoft\Terminal Server Client\Cache") # RDP Bitmap Cache
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Google\Chrome\User Data\Default") # Google Chrom History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Microsoft\Edge\User Data\Default") # Edge Browser History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Mozilla\Firefox\Profiles") # FireFox Browser History  
)

$mediumSourceFolders = @(
    (Join-Path -Path $env:SystemRoot -ChildPath "\appcompat\pca"), 
    $tempEventLogDir, # temp  Event Logs dir
    $tempPrefetch, # Temp Prefetch dir
    (Join-Path -Path $env:SystemRoot -ChildPath "\System32\sru") 
)

$highSourceFolders = @(
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations"), # JumpLists
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine"), # PowerShell History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Microsoft\Terminal Server Client\Cache"), # RDP Bitmap Cache
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Google\Chrome\User Data\Default") # Google Chrom History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Microsoft\Edge\User Data\Default") # Edge Browser History
    (Join-Path -Path $env:USERPROFILE -ChildPath "\AppData\Local\Mozilla\Firefox\Profiles") # FireFox Browser History 
    (Join-Path -Path $env:SystemRoot -ChildPath "\appcompat\pca"), ##  List of.exe files
    $tempEventLogDir, # temp  Event Logs dir
    $tempPrefetch, # Temp Prefetch dir
    (Join-Path -Path $env:SystemRoot -ChildPath "\System32\sru") # list of executaed programs and duration 
)

# Copy Windows Event Logs in temp dir
if ($Medium) {
    if (-not (Test-Path -Path $tempEventLogDir -PathType Container)) {
        New-Item -Path $tempEventLogDir -ItemType Directory | Out-Null
    }
    
    Copy-Item -Path "C:\Windows\System32\winevt\Logs\*" -Destination $tempEventLogDir -Recurse -Force
    Write-Host "Event Logs copied to temporary directory: $tempEventLogDir"
}

if ($High) {
    if (-not (Test-Path -Path $tempPrefetch -PathType Container)) {
        New-Item -Path $tempPrefetch -ItemType Directory | Out-Null
    }
    
    Copy-Item -Path "C:\Windows\Prefetch" -Destination $PrefetchCopyDir -Recurse -Force
    Write-Host "Prefetch files copied to temporary directory: $tempPrefetch"
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

# remove temp dir
if ($Medium) {
    Remove-Item -Path $tempEventLogDir -Force -Recurse
    Write-Host "Temp Windows Event Logs directory removed: $tempEventLogDir"
}


