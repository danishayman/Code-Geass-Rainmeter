# Code Geass Rainmeter

A Code Geass desktop for [Rainmeter](https://www.rainmeter.net/). Click the Geass sigil to bring up a row of honeycomb app icons, and hover an icon to show that app's wallpaper.

![Preview](assets/preview.gif)

## Install

1. Install [Rainmeter](https://www.rainmeter.net/) (tested with 4.5).
2. Download this repository (**Code > Download ZIP**) and extract it.
3. Double-click `install.bat`.

The installer:

- backs up any earlier copy of these skins and layouts to `%APPDATA%\Rainmeter\Backups`
- copies the skins and the `CodeGeass` layout into Rainmeter's folders
- checks what each icon opens, points it at the app if it's installed somewhere else on your PC, and lists any apps it can't find
- restarts Rainmeter and loads the layout

To only copy the files without restarting Rainmeter, run `install.bat -NoLoad` from a terminal in the extracted folder.

### Manual install

1. Copy `Skins\GurenHoneycomb` into your Rainmeter skins folder. That's usually `Documents\Rainmeter\Skins`, or `OneDrive\Documents\Rainmeter\Skins` if your Documents folder syncs with OneDrive.
2. Copy `Layouts\CodeGeass` into `%APPDATA%\Rainmeter\Layouts`.
3. In Rainmeter's **Manage** window, open the **Layouts** tab, pick `CodeGeass` and click **Load**.

## Using it

- When Rainmeter starts or your PC wakes, the sigil fades in with its glow, then the glow dims away as the icons fade in from the middle out to both ends.
- Click the sigil to hide or show the icons.
- Middle-click the sigil to refresh Rainmeter, which reloads every skin and replays the intro.
- Hover an icon and it grows slightly and brings up its wallpaper. Click it to open the app.
- Scroll the mouse wheel over the sigil to change the system volume. While you scroll, the glow's brightness shows the level: dim when quiet, full at 100%.

The layout works out every position from your screen size, so the sigil and icons sit in the middle of any screen.

## Icons

The layout shows this row, left to right: Folder (opens Documents), Telegram, VS Code, YouTube (opens the YouTube Music app), Discord, Chrome, Steam, Epic Games, Riot Client, Xbox.

More icons are ready to load from the **Skins** tab under `GurenHoneycomb\Icons`:

| Group | Icons |
| --- | --- |
| Apps | Brave, WhatsApp, Office (opens Word), Excel, PowerPoint, Notepad, Visual Studio, Spotify, Rainmeter (opens Manage), Settings |
| Games | Valorant, Legends of Runeterra, Minecraft, CS2, GTA V, Skyrim, osu!, Game (a blank game icon that opens your Steam library) |
| Power | Double-click to sleep, middle double-click to shut down, right double-click to restart |

## Customizing

```
GurenHoneycomb
├── @Resources
│   ├── Icon.inc            shared by icons without a hover wallpaper
│   ├── IconWallpaper.inc   shared by icons with a hover wallpaper
│   ├── IconIntro.inc       the startup fade-in shared by every icon
│   ├── IconPop.inc         the hover pop shared by every icon
│   ├── Wallpaper.inc       shared by every hover wallpaper
│   ├── Images
│   │   ├── Icons           one .png per icon
│   │   └── Wallpapers      hover wallpaper images
│   └── Source              .psd and .xcf files for making new icons
├── Geass                   the sigil
├── Glow                    the glow behind the sigil when you hover it
├── Icons                   one folder per icon
└── Wallpapers              one full-screen hover wallpaper per icon
```

### Change what an icon opens

Right-click the icon and choose **Edit skin**. Every icon is a few lines like this:

```ini
[Variables]
Icon=steam
Launch=["steam://open/main"]
StartMenuName=Steam
Wallpaper=Steam
@Include=#@#IconWallpaper.inc
```

| Line | Meaning |
| --- | --- |
| `Icon` | Image in `@Resources\Images\Icons`, without `.png` |
| `Launch` | What a click runs: a program (`["chrome.exe"]`), a full path, a link (`["https://www.youtube.com"]`, `["steam://rungameid/730"]`), a Start Menu app (`["shell:AppsFolder\<AppID>"]`) or a Rainmeter bang (`[!Manage]`) |
| `StartMenuName` | Optional. The app's name in the Start Menu. The installer uses it to find the app when `Launch` doesn't work on that PC. |
| `Wallpaper` | Optional. The wallpaper skin in `GurenHoneycomb\Wallpapers` shown while hovering. Icons with a wallpaper include `IconWallpaper.inc`, and icons without one include `Icon.inc`. |

Save the file, then right-click the icon and choose **Refresh skin**.

To find a Start Menu app's AppID, run this in PowerShell (swap in your app's name):

```powershell
Get-StartApps | Where-Object Name -like '*spotify*'
```

### Add an icon

1. Copy an icon's folder in `GurenHoneycomb\Icons` (for example `Steam` to `MyApp`) and rename the `.ini` inside to `MyApp.ini`.
2. Put a square `.png` in `@Resources\Images\Icons`. `@Resources\Source\template.psd` is the honeycomb template.
3. Edit `Icon` and `Launch` in `MyApp.ini`. If it has no wallpaper, remove the `Wallpaper` line and include `Icon.inc` instead.
4. For a wallpaper, copy a folder in `GurenHoneycomb\Wallpapers` the same way, put the image in `@Resources\Images\Wallpapers`, set `Image` to its file name, and set the icon's `Wallpaper` to the new folder's name.
5. In Rainmeter's **Manage** window, click **Refresh all** and load `Icons\MyApp`.
6. To keep it centered like the others, click **Edit settings** and give its section a position worked out the same way. For example, this puts it just after Xbox:

   ```ini
   WindowX=(#SCREENAREAWIDTH#/2+500)
   WindowY=(#SCREENAREAHEIGHT#/2+155)
   ```

   Save the file and click **Refresh all**.

### Change a wallpaper

Each wallpaper is a short skin in `GurenHoneycomb\Wallpapers`:

```ini
[Variables]
Image=steam.jpg
@Include=#@#Wallpaper.inc
```

Replace the image in `@Resources\Images\Wallpapers`, keeping its name, or add a new image and change `Image`. Wallpapers are scaled to fill the screen. Rainmeter loads the wallpaper skin when you hover an icon and unloads it when you move away, fading it in and out as it does.

### Change the startup intro

- **Sigil:** the `[Intro]` section of `Geass\Geass.ini`. `Repeat FadeIn,40,25` fades the sigil and its glow in together, in 25 steps of 40 milliseconds. `Repeat GlowDim,40,10` then dims the glow away in 10 steps.
- **Icons:** `@Resources\IconIntro.inc`. Each icon waits `625` milliseconds plus `1.5` milliseconds for every pixel between its center and the middle of the screen. With 100 pixels between icons, each pair fades in 150 milliseconds after the pair inside it.

### Change the hover pop

`@Resources\IconPop.inc` grows a hovered icon by 2 pixels per step. The `2` in `Repeat Grow,15,2`, `Repeat Shrink,15,2` and both `Clamp(...,0,2)` is the number of steps, so 2 takes the icon from 90 to 94 pixels. The `15` is how many milliseconds each step takes. Keep it at 5 or less, since each icon skin only has 5 pixels of room around the icon.

### Change the volume step

Each scroll-wheel notch over the sigil changes the volume by `VolumeStep` percent, set in `[Variables]` in `Geass\Geass.ini`. The default is 2, the same as Windows' volume keys.

### Keep your changes

After moving or adding icons, save them into the layout: in **Manage > Layouts**, type `CodeGeass` as the name and click **Save**. Skins you drag or place with the X and Y boxes get fixed positions, while the rest stay centered on any screen.

## Troubleshooting

- **Clicking an icon does nothing.** The app isn't installed, or it's installed somewhere the icon doesn't know about. Run `install.bat` again to repoint the icons it can find, or edit the icon's `Launch` line.
- **No icons appear.** They fade in about a second after the sigil. If they still don't show, you probably hid them, so click the sigil.
- **The sigil or icons are in the wrong place.** Load `CodeGeass` again from **Manage > Layouts**. If you saved over it, run `install.bat` to get the original back.
- **I want my old setup back.** The installer's backups are in `%APPDATA%\Rainmeter\Backups`. Rainmeter's **Layouts** tab also has `@Backup`, which is your setup from before the last layout was loaded.

## Credits

- The honeycomb icon skins are based on APIUM's Honeycomb suite.
- [How to Customize Honeycomb Icons](https://www.youtube.com/watch?v=Z1RAFscuFAE&ab_channel=Mork) by Mork
- [How to Create Hover Effects](https://www.youtube.com/watch?v=4FyO0uf512U&ab_channel=RacTac) by RacTac
