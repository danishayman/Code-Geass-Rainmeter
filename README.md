# Code Geass Rainmeter

A Code Geass desktop for [Rainmeter](https://www.rainmeter.net/). Click the Geass sigil to bring up a row of honeycomb app icons, and hover an icon to show that app's wallpaper.

![Preview](assets/preview.gif)

## Install

You need [Rainmeter](https://www.rainmeter.net/) 4.5 or later.

1. Download **CodeGeass.rmskin** from the [Releases page](https://github.com/danishayman/Code-Geass-Rainmeter/releases/latest).
2. Double-click it. Rainmeter's skin installer opens.
3. Leave **Apply included layout** ticked and click **Install**.

That's it: the sigil and icons appear in the middle of your screen. Your previous setup is saved as the `@Backup` layout in Rainmeter, so you can always go back.

## How to use

| Do this | To |
| --- | --- |
| Click the sigil | Show or hide the icons |
| Hover an icon | Show that app's wallpaper |
| Click an icon | Open the app |
| Scroll over the sigil | Change the volume |
| Right-click the sigil | Mute or unmute |
| Double right-click the sigil | Switch to the next sound output |
| Middle-click the sigil | Lock, sleep, restart or shut down |
| Ctrl+right-click the sigil | Open Rainmeter's menu |

The icons fade away after 10 seconds without use. Click the sigil to bring them back.

## Icons

The row has Claude, WhatsApp, VS Code, YouTube Music, Discord, Chrome, Steam, Epic Games, Xbox and Nuvio.

More icons come with it, including Telegram, Spotify, Brave, Office, Valorant, Minecraft, CS2 and GTA V. To add one, open Rainmeter's **Manage** window, find it under `GurenHoneycomb\Icons`, click **Load**, and drag it where you want.

## Customize

- **Change what an icon opens:** right-click it, choose **Edit skin**, and change the `Launch` line, for example `Launch=["chrome.exe"]` or `Launch=["https://www.youtube.com"]`. Save, then right-click the icon and choose **Refresh skin**.
- **Change a wallpaper:** replace its image in `Documents\Rainmeter\Skins\GurenHoneycomb\@Resources\Images\Wallpapers`, keeping the same file name.
- **Keep your changes:** in **Manage > Layouts**, type `CodeGeass` as the name and click **Save**.

## Troubleshooting

- **Clicking an icon does nothing.** The app isn't installed, or it's installed somewhere unusual. Change the icon's `Launch` line (see Customize).
- **The sigil or icons are in the wrong place.** In **Manage > Layouts**, pick `CodeGeass` and click **Load**.
- **I want my old setup back.** In **Manage > Layouts**, pick `@Backup` and click **Load**.

## Credits

- The honeycomb icon skins are based on APIUM's Honeycomb suite.
- [How to Customize Honeycomb Icons](https://www.youtube.com/watch?v=Z1RAFscuFAE&ab_channel=Mork) by Mork
- [How to Create Hover Effects](https://www.youtube.com/watch?v=4FyO0uf512U&ab_channel=RacTac) by RacTac
