# Tuya H.264 packets arrive, but all players show black

**Tested observation:** go2rtc 1.9.15 successfully connected with `tuya/webrtc` / `mqtt+udp`. Several MB of H.264 arrived; MSE, WebRTC and VLC were black. FFmpeg sometimes selected an empty HEVC track or logged `non monotonically increasing dts`.

**Diagnostic MP4 that worked:**

~~~bash
timeout 35 ffmpeg -hide_banner -loglevel warning -rtsp_transport tcp \
  -i rtsp://127.0.0.1:8554/camera_action \
  -t 15 -an -vf 'fps=15,setpts=N/(15*TB)' \
  -c:v libx264 -preset ultrafast -pix_fmt yuv420p \
  -y /tmp/camera_action_test.mp4
~~~

The MP4 contained real motion (15 seconds, 2560×1440, 15 fps). This supports a viable source and timestamp-related workaround, not a definitive firmware root-cause diagnosis.

**Live config excerpt — never commit a real Tuya URL:**

~~~yaml
streams:
  camera_action:
    - "tuya://GENERATED_PRIVATE_URL_REPLACE_LOCALLY"
  camera_action_tv:
    - "ffmpeg:camera_action#video=h264_fast#raw=-vf fps=12,scale=960:-2,setpts=N/(12*TB)"

ffmpeg:
  h264_fast: "-c:v libx264 -g 12 -preset ultrafast -tune zerolatency -profile:v baseline -pix_fmt yuv420p"
~~~

Preserve existing YAML sections and verify the actual FFmpeg command on your go2rtc version. A PC **MSE preview** was accepted after this optimization. Android TV compatibility and continuous stability are still unknown.

[Complete French diagnosis](../03-ffmpeg-black-video.md).

