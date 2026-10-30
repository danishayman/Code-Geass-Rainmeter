; Shared by every icon. While the mouse is over the icon it grows from 90 to 96 px
; around its centre (Pop goes from 0 to 3 in 30 ms steps), and it shrinks back when the
; mouse leaves. The skin is 100 x 100 px so there is room to grow up to 100 px.

[Variables]
Pop=0

[Pop]
Measure=Plugin
Plugin=ActionTimer
ActionList1=Repeat Grow,30,3
ActionList2=Repeat Shrink,30,3
Grow=[!SetVariable Pop "(Clamp(#Pop#+1,0,3))"][!UpdateMeasure Pop][!UpdateMeter Icon][!Redraw]
Shrink=[!SetVariable Pop "(Clamp(#Pop#-1,0,3))"][!UpdateMeasure Pop][!UpdateMeter Icon][!Redraw]
DynamicVariables=1
