; Shared by every honeycomb icon with a hover wallpaper.
; The icon's own .ini sets these in [Variables]:
;   Icon       - image in @Resources\Images\Icons, without .png
;   Launch     - what a left-click runs, as a Rainmeter action, e.g. ["chrome.exe"]
;   Wallpaper  - skin in GurenHoneycomb\Wallpapers shown while hovering
;   Wallpapers - optional, for a skin with more than one wallpaper: how many it has.
;                Its folder then has <Wallpaper>.ini, <Wallpaper> 2.ini and so on, and
;                each hover shows one of them at random.

[Variables]
; Which wallpaper the next hover shows (1 is <Wallpaper>.ini). Set to a random one
; when the skin loads.
WallpaperN=1

[Rainmeter]
Update=-1
Group=Honey
SkinWidth=100
SkinHeight=100
OnRefreshAction=[!Hide][!CommandMeasure Intro "Execute 1"][!SetVariable WallpaperN "([WallpaperStart] + 1)"][!UpdateMeasure WallpaperFile]
OnWakeAction=[!Hide][!CommandMeasure Intro "Execute 1"]

[WallpaperCount]
; Wallpapers= from the icon's .ini, or 1 if it isn't set (an unset variable is left
; as the text "#Wallpapers#").
Measure=String
String=#Wallpapers#
RegExpSubstitute=1
Substitute="^\D.*$":"1"

[WallpaperStart]
; A random wallpaper for the first hover, counting from 0.
Measure=Calc
Formula=Random
LowBound=0
HighBound=([WallpaperCount] - 1)
DynamicVariables=1

[WallpaperStep]
; How far on the next hover's wallpaper is from this one: random, but never 0, so
; the same wallpaper doesn't show twice in a row. Rerolled after every hover.
Measure=Calc
Formula=Random
LowBound=1
HighBound=([WallpaperCount] > 1 ? [WallpaperCount] - 1 : 1)
UpdateRandom=1
DynamicVariables=1

[WallpaperFile]
; The wallpaper skin file for WallpaperN: <Wallpaper>.ini, then <Wallpaper> 2.ini...
Measure=String
String=#Wallpaper# #WallpaperN#.ini
RegExpSubstitute=1
Substitute=" 1\.ini$":".ini"
DynamicVariables=1

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
MouseOverAction=[!CommandMeasure AutoHide "Stop 1" "GurenHoneycomb\Geass"][!CommandMeasure Pop "Stop 2"][!CommandMeasure Pop "Execute 1"][!ActivateConfig "GurenHoneycomb\Wallpapers\#Wallpaper#" "[WallpaperFile]"][!SetVariable WallpaperN "(((#WallpaperN# - 1 + [WallpaperStep]) % [WallpaperCount]) + 1)"][!UpdateMeasure WallpaperStep][!UpdateMeasure WallpaperFile][!HideGroup "Geass"]
MouseLeaveAction=[!CommandMeasure AutoHide "Stop 1" "GurenHoneycomb\Geass"][!CommandMeasure AutoHide "Execute 1" "GurenHoneycomb\Geass"][!CommandMeasure Pop "Stop 1"][!CommandMeasure Pop "Execute 2"][!DeactivateConfig "GurenHoneycomb\Wallpapers\#Wallpaper#"][!ShowFadeGroup "Geass"]
@IncludeIntro=#@#IconIntro.inc
@IncludePop=#@#IconPop.inc
@IncludeFlash=#@#IconFlash.inc
