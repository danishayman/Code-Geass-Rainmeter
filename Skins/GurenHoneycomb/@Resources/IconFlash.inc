; Shared by every icon. Clicking an icon launches its app straight away, then the icon
; flashes bright (Flash goes from 0.8 back to 0 in 25 ms steps) and the row fades away.

[Variables]
Flash=0

[Flash]
Measure=Plugin
Plugin=ActionTimer
ActionList1=Bright | Repeat Fade,25,6 | Done
Bright=[!SetVariable Flash 0.8][!UpdateMeasure Flash][!UpdateMeter Icon][!Redraw]
Fade=[!SetVariable Flash "(Clamp(#Flash#-0.14,0,1))"][!UpdateMeasure Flash][!UpdateMeter Icon][!Redraw]
Done=[!SetVariable Flash 0][!UpdateMeasure Flash][!UpdateMeter Icon][!Redraw][!HideFadeGroup "Honey"]
DynamicVariables=1
