; Shared by every hover wallpaper. The wallpaper's own .ini sets Image in [Variables]:
;   Image - file in @Resources\Images\Wallpapers
; An icon loads its wallpaper skin on hover and unloads it when the mouse leaves,
; and Rainmeter fades the skin in and out as it does.

[Rainmeter]
Update=-1
OnRefreshAction=[!ZPos -2]

[Image]
Meter=Image
ImageName=#@#Images\Wallpapers\#Image#
W=#SCREENAREAWIDTH#
H=#SCREENAREAHEIGHT#
PreserveAspectRatio=2
