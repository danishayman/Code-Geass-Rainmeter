; Shared by every icon. When the skin loads or the PC wakes, the icon hides and then
; fades back in after a delay. Icons further from the middle of the screen wait longer,
; so the row fades in from the middle out to both ends after the sigil. The skin's
; [Rainmeter] section starts it with
;   OnRefreshAction=[!Hide][!CommandMeasure Intro "Execute 1"]

[IntroDelay]
Measure=Calc
; 625 ms, plus 1.5 ms per pixel between the icon's centre (50 = half its 100 px skin)
; and the middle of the screen.
Formula=Clamp(625 + Abs(#CURRENTCONFIGX# + 50 - #SCREENAREAWIDTH# / 2) * 1.5, 0, 4000)

[Intro]
Measure=Plugin
Plugin=ActionTimer
ActionList1=Wait [IntroDelay:0] | Show
Show=[!ShowFade]
DynamicVariables=1
