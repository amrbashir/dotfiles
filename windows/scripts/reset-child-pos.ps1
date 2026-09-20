# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reset Child Window Position
# @raycast.description Click on a child window to reset its position
# @raycast.mode compact

# Documentation:
# @raycast.author Amr
# @raycast.authorURL https://amrbashir.me

$ErrorActionPreference = "Stop"

Add-Type @"
using System;
using System.Runtime.InteropServices;

public struct POINT {
    public int X;
    public int Y;
}

public class __Win32 {
    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

    [DllImport("user32.dll")]
    public static extern IntPtr WindowFromPoint(POINT p);

    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    [DllImport("user32.dll")]
    public static extern bool ScreenToClient(IntPtr hWnd, ref POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern IntPtr RealChildWindowFromPoint(IntPtr hwndParent, POINT ptParentClientCoords);
}
"@

$VK_LBUTTON = 0x01

# 1. Wait for any currently held left mouse button to be released, then wait for the next click
Write-Output "Waiting for left mouse button click..."
while (([__Win32]::GetAsyncKeyState($VK_LBUTTON) -band 0x8000) -ne 0) { Start-Sleep -Milliseconds 10 }
while (([__Win32]::GetAsyncKeyState($VK_LBUTTON) -band 0x8000) -eq 0) { Start-Sleep -Milliseconds 10 }
Write-Output "Left mouse button clicked."

# 2. Get the window under the cursor, then descend into nested children until the innermost one
$screenPoint = New-Object POINT
[__Win32]::GetCursorPos([ref]$screenPoint) | Out-Null
$targetWindowHandle = [__Win32]::WindowFromPoint($screenPoint)
if ($targetWindowHandle -eq [IntPtr]::Zero) {
    throw "No window found under the cursor."
}

while ($true) {
    $clientPoint = New-Object POINT
    $clientPoint.X = $screenPoint.X
    $clientPoint.Y = $screenPoint.Y
    [__Win32]::ScreenToClient($targetWindowHandle, [ref]$clientPoint) | Out-Null

    $childWindowHandle = [__Win32]::RealChildWindowFromPoint($targetWindowHandle, $clientPoint)
    if ($childWindowHandle -eq [IntPtr]::Zero -or $childWindowHandle -eq $targetWindowHandle) {
        Write-Output "Reached the innermost child window."
        break
    }
    $targetWindowHandle = $childWindowHandle
}

# 3. Reset the position of the clicked window without changing its size or Z-order
Write-Output "Resetting the position of the innermost child window..."
$SWP_NOZORDER = 0x0004
$SWP_NOSIZE = 0x0001
[__Win32]::SetWindowPos($targetWindowHandle, [IntPtr]::Zero, 0, 0, 0, 0, $SWP_NOSIZE -bor $SWP_NOZORDER) | Out-Null
Write-Output "Position reset successfully."
