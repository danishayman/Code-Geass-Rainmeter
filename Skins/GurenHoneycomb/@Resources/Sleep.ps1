# Puts the PC to sleep. Used by the sigil's power menu and the Power icon.
# The usual "rundll32 powrprof.dll,SetSuspendState" shortcut hibernates instead of
# sleeping when hibernation is turned on, so this asks Windows for sleep directly.
Add-Type -AssemblyName System.Windows.Forms
[void][System.Windows.Forms.Application]::SetSuspendState('Suspend', $false, $false)
