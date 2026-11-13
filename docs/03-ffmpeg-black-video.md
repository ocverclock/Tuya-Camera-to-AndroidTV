# 03 — Flux H.264 reçu, mais écran noir

**Symptôme prouvé** avec go2rtc 1.9.15 et la caméra solaire Action/LSC : connexion `tuya/webrtc` / `mqtt+udp` établie, H.264 reçu (**8,61 Mo / 7 663 paquets** lors d'un essai), mais **MSE, WebRTC et VLC noirs**. Maintenir l'app Tuya ouverte n'a pas corrigé l'image.

## Diagnostic pas à pas

Le flux signalait H.264 et HEVC. Une piste HEVC vide a parfois conduit FFmpeg à `Could not find codec parameters ... hevc ... unspecified size`, sans prouver une incompatibilité H.264. Un autre essai H.264 donnait **`non monotonically increasing dts`** : des horodatages désordonnés/dupliqués sont une piste sérieuse, mais pas une preuve absolue de causalité.

**Premier test : extraire une image** (attention, image privée) :

~~~bash
timeout 30 ffmpeg -hide_banner -loglevel error -rtsp_transport tcp \
  -i rtsp://127.0.0.1:8554/camera_action \
  -frames:v 1 -update 1 -y /tmp/camera_action_test.jpg
~~~

**Deuxième test : MP4 avec horodatages reconstruits**, exécuté sur le serveur où FFmpeg est installé :

~~~bash
timeout 35 ffmpeg -hide_banner -loglevel warning -rtsp_transport tcp \
  -i rtsp://127.0.0.1:8554/camera_action \
  -t 15 -an -vf 'fps=15,setpts=N/(15*TB)' \
  -c:v libx264 -preset ultrafast -pix_fmt yuv420p \
  -y /tmp/camera_action_test.mp4
~~~

**Résultat observé :** JPEG correct, MP4 animé de **15 secondes / 2560×1440 / 15 images/s**. Les warnings `deprecated pixel format used` n'ont pas empêché le résultat. Supprimer les fichiers de test locaux après diagnostic.

## Solution live appliquée dans go2rtc

Conserver le flux d'origine et en créer **un second**. Extrait à intégrer sans effacer `api`, `rtsp`, `webrtc` ni le reste du YAML :

~~~yaml
streams:
  camera_action:
    - "tuya://GENERATED_PRIVATE_URL_REPLACE_LOCALLY"
  camera_action_tv:
    - "ffmpeg:camera_action#video=h264_fast#raw=-vf fps=12,scale=960:-2,setpts=N/(12*TB)"

ffmpeg:
  h264_fast: "-c:v libx264 -g 12 -preset ultrafast -tune zerolatency -profile:v baseline -pix_fmt yuv420p"
~~~

Un premier essai de réencodage sans les filtres d'horodatage laissait l'écran noir. Avec `fps` et `setpts`, la vidéo live est apparue. Une première version était très saccadée ; le profil réduit à environ **960×540 / 12 images/s** et un encodeur rapide a ensuite donné un affichage **MSE jugé très bien pour l'usage**.

- Test MSE : `http://<HOST_IP>:1984/stream.html?src=camera_action_tv&mode=mse`.
- Test RTSP : `rtsp://<HOST_IP>:8554/camera_action_tv`.
- Un essai MP4 dans navigateur était plutôt fluide mais avait **3 à 5 secondes** de retard.
- Charge mesurée avant optimisation : environ **64,67 % d'un cœur logique** au sens Docker et **183 Mio** de RAM pour go2rtc ; cela ne démontre pas une saturation CPU.

**Important :** ce contournement n'est prouvé que sur notre version/matériel et à court terme. La syntaxe du profil et de `#raw` doit être contrôlée dans la version go2rtc utilisée, notamment via le processus FFmpeg réellement lancé. Le décodage par la future application Android ne sera pas nécessairement le même que celui du navigateur MSE.

Diagnostic des compteurs **sans afficher l'URL privée** : [scripts/inspect-streams.sh](../scripts/inspect-streams.sh).

