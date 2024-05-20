$downloadsPath = [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads')
$extensionsToKeep = @('.exe', '.log', '.csv')

if (Test-Path $downloadsPath) {
    Get-ChildItem -Path $downloadsPath -Recurse -Force | ForEach-Object {
        if ($_.PSIsContainer -or $extensionsToKeep -notcontains $_.Extension) {
            Remove-Item -Path $_.FullName -Recurse -Force
        }
    }
    Write-Host "Downloads folder has been cleared, keeping .exe, .log, and .csv files."
} else {
    Write-Host "Downloads folder does not exist."
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class RecycleBin {
    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    public static extern uint SHEmptyRecycleBin(IntPtr hwnd, string pszRootPath, uint dwFlags);
}
"@

$SHERB_NOCONFIRMATION = 0x00000001
$SHERB_NOPROGRESSUI = 0x00000002
$SHERB_NOSOUND = 0x00000004

[RecycleBin]::SHEmptyRecycleBin([IntPtr]::Zero, $null, $SHERB_NOCONFIRMATION -bor $SHERB_NOPROGRESSUI -bor $SHERB_NOSOUND) | Out-Null
Write-Host "Recycle Bin has been emptied."