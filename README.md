# Tuya Camera → go2rtc → Home Assistant → Android TV

**Modular, evidence-based field notes**, built from a real Action/LSC solar camera. Pick only what you need: extracting video, fixing a black stream, displaying it in Home Assistant, or eventually showing a camera popup above other Android TV apps.

**[Lire en français](README.fr.md)** · [English quick start](docs/en/quickstart.md)

> **Status, 13 Nov 2026:** Stock firmware + go2rtc + FFmpeg timestamp repair + browser MSE preview are **tested**. Home Assistant camera display, the Tuya person-detection relay, a Frigate-compatible bridge, and the Android TV popup are **planned, not yet validated**. This distinction matters.

## Pick a module

| I want to… | Guide | Status |
|---|---|---|
| Connect a stock Tuya solar camera without flashing | [01 — Tuya camera](docs/01-camera-tuya.md) | Tested on one device |
| Run go2rtc under Docker and Dockge | [02 — Docker/Dockge](docs/02-docker-dockge.md) | Tested |
| Fix a black or lagging H.264 stream | [03 — FFmpeg fix](docs/03-ffmpeg-black-video.md) | Tested |
| Show the video in Home Assistant | [04 — Home Assistant](docs/04-home-assistant.md) | To test |
| Trigger an overlay in CleanYourTV / Frigate Glance | [05 — Android TV](docs/05-cleanyourtv-glance.md) | To develop/test |
| Investigate Anyka firmware / TCP 5002 / microSD | [06 — Experimental research](docs/06-anyka-local-research.md) | Partial |
| Understand battery sleep and firmware-update risks | [07 — Power and firmware](docs/07-power-and-firmware.md) | Partial |

**[Troubleshooting](docs/08-troubleshooting.md)** · **[Validation matrix](docs/09-validation-matrix.md)** · **[Security](docs/10-security.md)** · **[Upstream references](docs/11-references.md)**

## Tested setup and key finding

- **Camera:** LSC Smart Connect Solar Outdoor PTZ **SLF26322**, Action ref **3225730**, Anyka **AK3918AV100**, original Tuya firmware **6.10.33** (6.10.42 OTA offered but **not installed**).
- **Server:** Debian virtual machine, Docker + Dockge, **go2rtc 1.9.15**.
- The consumer Tuya account authenticated, and go2rtc received H.264 data. Yet **MSE, WebRTC and VLC were black**.
- FFmpeg extracted a correct JPEG and a valid 15-second, 2560×1440 MP4 when fed the filter `fps=15,setpts=N/(15*TB)`.
- A separate live transcode stream using `fps=12,scale=960:-2,setpts=N/(12*TB)` and a fast H.264 profile gave a **usable MSE preview**. The final Android TV playback has not been tested.
- The working `tuya://...` URI contains **account credentials** and is deliberately omitted from this repository.

## Intended architecture — components can be used independently

~~~text
Stock solar camera + Tuya consumer cloud
       ├── video → go2rtc → FFmpeg timestamp correction ─┬─ MSE browser [TESTED]
       │                                                 ├─ Home Assistant [TO TEST]
       │                                                 └─ Android TV overlay [TO TEST]
       └── "human detected" Tuya automation → HA / MQTT ──── adapter → overlay [TO BUILD]
~~~

[Frigate Glance](https://github.com/Gathin23/cleanyourtv/tree/main/addons/frigate-glance) is **not** Frigate NVR. The Android add-on expects Frigate-compatible MQTT events and HTTP API responses. A working go2rtc stream **does not automatically supply those events or API endpoints**. The add-on may show JPEG snapshots rather than a second live video while another TV app is playing.

## Sanitized examples

- [Docker Compose](examples/compose.yaml) — edit the **Docker host's absolute path**, particularly when using Dockge in Docker.
- [go2rtc configuration](examples/go2rtc.yaml.example) — replace a placeholder with a privately generated Tuya URI; never commit the real YAML.
- [Frigate Glance settings skeleton](examples/frigate-glance-config.example.json) — **not operational without Frigate or a future compatible bridge**.
- [Read-only stream-inspection script](scripts/inspect-streams.sh) — omits private Tuya URLs.

## Scope

This currently **still depends on Tuya cloud**; it is not a cloud-free firmware replacement. A separate experimental microSD/Anyka study is preserved as research, not an install recommendation.

No private IP addresses, e-mails, passwords, device IDs, live footage, firmware dumps or original DEBUG logs belong in the public repository. Please review [security rules](docs/10-security.md) before contributing. See [CONTRIBUTING.md](CONTRIBUTING.md) for evidence and test requirements. Documentation is Apache-2.0 licensed; third-party software is linked, not bundled.

