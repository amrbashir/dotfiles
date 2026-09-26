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
using System.Collections.Generic;
using System.Runtime.InteropServices;

public struct POINT {
    public int X;
    public int Y;
}

public struct RECT {
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}

public class __Win32 {
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

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
    public static extern IntPtr GetAncestor(IntPtr hwnd, uint gaFlags);

    [DllImport("user32.dll")]
    public static extern IntPtr GetParent(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool EnumChildWindows(IntPtr hWndParent, EnumWindowsProc lpEnumFunc, IntPtr lParam);

    public static List<IntPtr> GetDirectChildren(IntPtr parent) {
        var children = new List<IntPtr>();
        EnumChildWindows(parent, (hWnd, lParam) => {
            if (GetParent(hWnd) == parent) children.Add(hWnd);
            return true;
        }, IntPtr.Zero);
        return children;
    }
}
"@

$VK_LBUTTON = 0x01

# 1. Wait for any currently held left mouse button to be released, then wait for the next click
Write-Output "Waiting for left mouse button click..."
while (([__Win32]::GetAsyncKeyState($VK_LBUTTON) -band 0x8000) -ne 0) { Start-Sleep -Milliseconds 10 }
while (([__Win32]::GetAsyncKeyState($VK_LBUTTON) -band 0x8000) -eq 0) { Start-Sleep -Milliseconds 10 }
Write-Output "Left mouse button clicked."

# 2. Get the top-level window under the cursor.
#    WindowFromPoint skips disabled/transparent children (e.g. Electron's "Intermediate D3D Window"),
#    so resolve the root and inspect its children directly.
$GA_ROOT = 2

$screenPoint = New-Object POINT
[__Win32]::GetCursorPos([ref]$screenPoint) | Out-Null
$windowUnderCursor = [__Win32]::WindowFromPoint($screenPoint)
if ($windowUnderCursor -eq [IntPtr]::Zero) {
    throw "No window found under the cursor."
}
$rootWindowHandle = [__Win32]::GetAncestor($windowUnderCursor, $GA_ROOT)

# 3. Find the visible direct children that cover the cursor. Several can overlap
#    (e.g. Electron's render widget over the D3D window), so consider all of them.
$targetWindowHandles = [__Win32]::GetDirectChildren($rootWindowHandle) | Where-Object {
    $rect = New-Object RECT
    [__Win32]::IsWindowVisible($_) -and [__Win32]::GetWindowRect($_, [ref]$rect) -and
    $screenPoint.X -ge $rect.Left -and $screenPoint.X -lt $rect.Right -and
    $screenPoint.Y -ge $rect.Top -and $screenPoint.Y -lt $rect.Bottom
}
if (-not $targetWindowHandles) {
    throw "No child window under the cursor. Click inside the misplaced content, not the title bar."
}

# 4. Reset the position of each child to its parent's client origin without changing its size or Z-order
$SWP_NOZORDER = 0x0004
$SWP_NOSIZE = 0x0001
$SWP_NOACTIVATE = 0x0010
foreach ($targetWindowHandle in $targetWindowHandles) {
    $rect = New-Object RECT
    [__Win32]::GetWindowRect($targetWindowHandle, [ref]$rect) | Out-Null
    $origin = New-Object POINT
    $origin.X = $rect.Left
    $origin.Y = $rect.Top
    [__Win32]::ScreenToClient($rootWindowHandle, [ref]$origin) | Out-Null
    if ($origin.X -eq 0 -and $origin.Y -eq 0) { continue }

    Write-Output "Resetting child window $targetWindowHandle from ($($origin.X), $($origin.Y)) to (0, 0)..."
    [__Win32]::SetWindowPos($targetWindowHandle, [IntPtr]::Zero, 0, 0, 0, 0, $SWP_NOSIZE -bor $SWP_NOZORDER -bor $SWP_NOACTIVATE) | Out-Null
}
Write-Output "Position reset successfully."
