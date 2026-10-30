; Shared by every honeycomb icon with a hover wallpaper.
; The icon's own .ini sets these in [Variables]:
;   Icon      - image in @Resources\Images\Icons, without .png
;   Launch    - what a left-click runs, as a Rainmeter action, e.g. ["chrome.exe"]
;   Wallpaper - image in @Resources\Images\Wallpapers shown while hovering

[Rainmeter]
Update=-1
Group=Honey

[Icon]
Meter=Image
ImageName=#@#Images\Icons\#Icon#.png
H=90
LeftMouseUpAction=#Launch#[!HideFadeGroup "Honey"]
MouseOverAction=[!SetOption Image ImageName "#@#Images\Wallpapers\#Wallpaper#" "GurenHoneycomb\Wallpaper"][!UpdateMeter Image "GurenHoneycomb\Wallpaper"][!Redraw "GurenHoneycomb\Wallpaper"][!ShowFade "GurenHoneycomb\Wallpaper"][!HideFadeGroup "Geass"]
MouseLeaveAction=[!HideFade "GurenHoneycomb\Wallpaper"][!ShowFadeGroup "Geass"]
