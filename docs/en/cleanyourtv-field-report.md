# CleanYourTV on a TCL Android TV 9 — field report (November 2026)

**Independent module:** this report describes our **already working CleanYourTV launcher**. It does **not** require go2rtc, a Tuya camera, Home Assistant or Frigate. The future [Frigate Glance overlay](../05-cleanyourtv-glance.md) was **not installed or tested** on the reference TV.

**Verified device:** TCL BeyondTV2, Android TV 9, build `PPR1.180610.011 / AP06`. Network ADB worked; CleanYourTV package `com.gathin.tvhome` installed and launched. A session ended with an explicit **“CONFIGURATION VALIDÉE”** confirmation. No root or firmware modification was involved.

## What the user actually chose

- **Four dock apps:** SmartTube (`org.smarttube.stable`), IBO Pro (`com.ibopro.player`), Jellyfin (`org.jellyfin.androidtv`), OQEE/Free TV (`net.oqee.androidtv.store`).
- **Nature-calm** as a starting theme: nearly black background `#05070C`, landscape photography, random rotation every **5 minutes**, true color, **14 % dim**, frosted/glass dock positioned as low as possible.
- **Keep:** Chromecast/Google Cast, system updates, HDMI/CEC and TV playback.
- **Disable on this specific TCL:** `com.tcl.samba`, `com.tcl.assistant` and `com.tcl.bootadservice`. **These are not universal debloat recommendations**, and their disabled state does not prove all telemetry was eliminated.
- **Reject colored glow:** a colorful halo experiment was explicitly disliked. Prefer a simple, non-colored focus and restrained Apple TV-like appearance. Pulsing was abandoned.
- **Unconfirmed implementation details:** proposed focus zoom around **+16 %** and smaller radii (12 dp tiles / 18 dp dock) were not proven in the final APK. Glass opacity **40 %** appeared in one observed state; **30 %** was considered later. Wallpaper captions also varied between proposed configurations. No byte-perfect final exported JSON survives in the retrievable notes.

## Actual problems and how to avoid them

1. **Google/TCL Home still appears after installation.** On this reference device, the stock Home needed a targeted disable for CleanYourTV to become the effective launcher. This is risky: first inspect the actual HOME package, confirm CleanYourTV launches, back up the state and verify a restoration path. Do not copy a guessed package name from another model.
2. **ADB disconnected / “no devices/emulators found”.** Reconnect over TCP and verify `adb devices` after TV restart, before pushing or installing anything.
3. **`mCurrentFocus=null`** is not proof a launcher is missing. Compare with the actual TV screen and HOME intent behavior.
4. **Source backup files interfering with compilation.** Keep `.backup-*` copies away from compile directories.
5. **Theme tweaks may overwrite launcher settings.** Upstream [themes/README](https://github.com/Gathin23/cleanyourtv/blob/main/themes/README.md) documents precedence and reset behavior. Back up before pushing themes.
6. **Wallpapers:** [Wallhaven](https://wallhaven.cc/) was preferred for varied HD **horizontal** landscapes, but the images are not necessarily freely redistributable. No copyrighted image pack is bundled.

## Reuse safely

- [Sanitized four-app nature-calm example](../../examples/cleanyourtv/nature-calm-4-apps.example.json) — **illustrative**, not a copy of the real final config.
- [French ADB, backup and restoration procedure](../cleanyourtv/adb-et-restauration.md).
- [Full French field report](../12-cleanyourtv-field-report.md).
- [Upstream CleanYourTV](https://github.com/Gathin23/cleanyourtv) for supported device lists, the official `tools/disable.sh` / `tools/restore.sh` workflow, and exact theme functionality.

**Privacy:** The real TV IP, backups, wallpapers, customized APK and private UI settings are not included. The stock-firmware Tuya/go2rtc video work is covered separately in this repository.

