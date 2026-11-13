# English quick start — independent modules

**Tested hardware:** LSC Smart Solar Outdoor PTZ SLF26322, Anyka AK3918AV100, original firmware 6.10.33, go2rtc 1.9.15 under Docker/Dockge.

1. Confirm the camera works in the **Tuya Smart mobile application**. Its password can differ from Tuya **Developer Platform** even for the same email. **EU Central** worked for the tested French account.
2. Use the [Docker/Dockge example](../../examples/compose.yaml). **Use the absolute path from the Docker HOST**, not the internal Dockge container path.
3. Discover the private `tuya://...` URL through go2rtc's wizard; insert it under `streams.camera_action` in the **local** config. **Never share it**.
4. If MSE/WebRTC/VLC are black despite H.264 packets, see the [English FFmpeg fix](black-video-fix.md).
5. A separate transcoded stream with `fps=12,scale=960:-2,setpts=N/(12*TB)` gave an acceptable **MSE preview**, with only short-term testing.
6. [Home Assistant](home-assistant.md) and [Android TV Frigate Glance](../05-cleanyourtv-glance.md) are **not yet tested** end to end.

This is **not** a cloud-free camera firmware. Keep debug logs, camera pictures and original firmware dumps private.

