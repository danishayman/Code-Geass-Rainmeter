; Shared by every honeycomb icon with a hover wallpaper.
; The icon's own .ini sets these in [Variables]:
;   Icon      - image in @Resources\Images\Icons, without .png
;   Launch    - what a left-click runs, as a Rainmeter action, e.g. ["chrome.exe"]
;   Wallpaper - skin in GurenHoneycomb\Wallpapers shown while hovering

[Rainmeter]
Update=-1
Group=Honey

[Icon]
Meter=Image
ImageName=#@#Images\Icons\#Icon#.png
H=90
LeftMouseUpAction=#Launch#[!HideFadeGroup "Honey"]
MouseOverAction=[!ActivateConfig "GurenHoneycomb\Wallpapers\#Wallpaper#"][!HideGroup "Geass"]
MouseLeaveAction=[!DeactivateConfig "GurenHoneycomb\Wallpapers\#Wallpaper#"][!ShowFadeGroup "Geass"]
