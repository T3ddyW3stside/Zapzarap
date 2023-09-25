

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
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_light"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_light1"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_light2")
)
$mediumSourceFolders = @(
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_medium"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_medium1"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_medium2"),
    (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Source\src_medium3")
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
    ZipFolders $lightSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\dest")
}

if ($Medium) {
    ZipFolders $mediumSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\dest")
}

if ($High) {
    ZipFolders $highSourceFolders (Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\dest")
}
