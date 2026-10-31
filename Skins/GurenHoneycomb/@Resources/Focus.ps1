# Brings an app's window back if the app is already running, otherwise starts it.
# For icons whose app ignores a second launch while it's minimized, such as Discord.
# usage: Focus.ps1 -Process Discord -Launch "shell:AppsFolder\com.squirrel.Discord.Discord"
param(
    [Parameter(Mandatory)] [string]$Process,
    [Parameter(Mandatory)] [string]$Launch
)

$window = Get-Process -Name $Process -ErrorAction SilentlyContinue |
    Where-Object MainWindowHandle -ne 0 | Select-Object -First 1
if (-not $window) {
    Start-Process $Launch
    exit
}

Add-Type -Namespace GurenHoneycomb -Name Window -MemberDefinition @'
[DllImport("user32.dll")] public static extern bool IsIconic(IntPtr hWnd);
[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
'@
$handle = $window.MainWindowHandle
if ([GurenHoneycomb.Window]::IsIconic($handle)) {
    [void][GurenHoneycomb.Window]::ShowWindowAsync($handle, 9)  # SW_RESTORE
}
[void][GurenHoneycomb.Window]::SetForegroundWindow($handle)
