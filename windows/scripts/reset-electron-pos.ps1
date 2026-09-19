# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reset electron window pos
# @raycast.description Reset the position of the foreground electron window
# @raycast.mode silent

# Documentation:
# @raycast.author Amr
# @raycast.authorURL https://amrbashir.me

$ErrorActionPreference = "Stop"

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class __Win32 {
    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern IntPtr FindWindowEx(IntPtr parentHandle, IntPtr childAfter, string className, string windowTitle);
}
"@

# 1. Get the handle of the foreground window
$foregroundWindowHandle = [__Win32]::GetForegroundWindow()

# 2. Get the handle of the "Intermediate D3D Window" under the top-level ancestor
$d3dWindowHandle = [__Win32]::FindWindowEx($foregroundWindowHandle, [IntPtr]::Zero, "Intermediate D3D Window", $null)
if ($d3dWindowHandle -eq [IntPtr]::Zero) {
    throw "No 'Intermediate D3D Window' found under the clicked window's top-level ancestor."
}

# 3. Reset the position of the "Intermediate D3D Window" without changing its size or Z-order
$SWP_NOZORDER = 0x0004
$SWP_NOSIZE = 0x0001
[__Win32]::SetWindowPos($d3dWindowHandle, [IntPtr]::Zero, 0, 0, 0, 0, $SWP_NOSIZE -bor $SWP_NOZORDER) | Out-Null
