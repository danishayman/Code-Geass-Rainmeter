; Shared by every honeycomb icon without a hover wallpaper.
; The icon's own .ini sets these in [Variables]:
;   Icon   - image in @Resources\Images\Icons, without .png
;   Launch - what a left-click runs, as a Rainmeter action, e.g. ["chrome.exe"]

[Rainmeter]
Update=-1
Group=Honey

[Icon]
Meter=Image
ImageName=#@#Images\Icons\#Icon#.png
H=90
LeftMouseUpAction=#Launch#[!HideFadeGroup "Honey"]
