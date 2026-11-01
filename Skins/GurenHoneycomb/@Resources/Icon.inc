; Shared by every honeycomb icon without a hover wallpaper.
; The icon's own .ini sets these in [Variables]:
;   Icon   - image in @Resources\Images\Icons, without .png
;   Launch - what a left-click runs, as a Rainmeter action, e.g. ["chrome.exe"]

[Rainmeter]
Update=-1
Group=Honey
SkinWidth=100
SkinHeight=100
OnRefreshAction=[!Hide][!CommandMeasure Intro "Execute 1"]
OnWakeAction=[!Hide][!CommandMeasure Intro "Execute 1"]

[Icon]
Meter=Image
ImageName=#@#Images\Icons\#Icon#.png
X=(5-#Pop#)
Y=(5-#Pop#)
H=(90+2*#Pop#)
DynamicVariables=1
; Brightens the icon while it flashes after a click (see IconFlash.inc).
ColorMatrix5=#Flash#;#Flash#;#Flash#;0;1
LeftMouseUpAction=#Launch#[!CommandMeasure Flash "Execute 1"]
MouseOverAction=[!CommandMeasure AutoHide "Stop 1" "GurenHoneycomb\Geass"][!CommandMeasure Pop "Stop 2"][!CommandMeasure Pop "Execute 1"]
MouseLeaveAction=[!CommandMeasure AutoHide "Stop 1" "GurenHoneycomb\Geass"][!CommandMeasure AutoHide "Execute 1" "GurenHoneycomb\Geass"][!CommandMeasure Pop "Stop 1"][!CommandMeasure Pop "Execute 2"]
@IncludeIntro=#@#IconIntro.inc
@IncludePop=#@#IconPop.inc
@IncludeFlash=#@#IconFlash.inc
