# Home Assistant — upcoming test plan

**Not yet validated** on the reference installation. First show video in HA, then test the Tuya person-detection event; the final TV popup is a separate module.

- Try Home Assistant **Generic Camera** with stream source `rtsp://<HOST_IP>:8554/camera_action_tv`. Optionally test the go2rtc JPEG frame API on your version before using it as a still source.
- Alternatively evaluate [AlexxIT/WebRTC](https://github.com/AlexxIT/WebRTC) with the **existing** go2rtc server; don't create a duplicate instance inadvertently.
- Verify HA camera entity, actual moving preview, restart/reconnect, video delay and server CPU.
- Tuya mobile exposes **Motion detected** and **Human detected** automation triggers on this camera, but **we have not established** that HA sees those as entities/events. Check actual HA state/event logs; a separate Tuya-device relay is only a possible experiment.
- Only once a real HA event works, implement debounce and translate it to the **Frigate-compatible MQTT/API** shape needed by Frigate Glance. Plain MQTT text is not enough.

[Complete French HA instructions](../04-home-assistant.md) · [TV overlay plan](../05-cleanyourtv-glance.md).

