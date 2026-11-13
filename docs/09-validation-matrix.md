# 09 — Matrice de validation — 13 novembre 2026

| Fonction | Statut | Preuve ou limite |
|---|---|---|
| Caméra Anyka AV100 / firmware 6.10.33 | ✅ Observé | Identification matérielle |
| Authentification Tuya mobile dans go2rtc | ✅ Testé | Caméra découverte |
| Docker/Dockge, go2rtc 1.9.15 | ✅ Testé | Interface accessible, montage corrigé |
| H.264 transféré | ✅ Mesuré | ~8,61 Mo reçus dans un contrôle |
| Image brute MSE/WebRTC/VLC | ❌ Noire | Ce n'est pas la preuve d'un flux vide |
| Extraction JPEG FFmpeg | ✅ Testé | Image correcte |
| MP4 réencodé 15 s | ✅ Testé | Images animées 2560×1440 |
| Live MSE optimisé | ✅ Testé à court terme | Jugé satisfaisant pour les essais |
| Stabilité 24 h / veille solaire | ⏳ À mesurer | Non démontré |
| Caméra dans Home Assistant | ⏳ À tester | Aucune entité vidéo validée |
| Option « Humain détecté » dans Tuya mobile | ✅ Observée | Pas une preuve d'événement HA |
| Détection humaine réellement visible dans HA | ⏳ À tester | Pas d'état/événement capturé |
| Adaptateur Frigate-compatible | ⏳ À développer | Ni API ni MQTT testés |
| Frigate Glance sur la TCL cible | ⏳ Non installé | CleanYourTV existant doit être préservé |
| Popup par-dessus SmartTube/Jellyfin | ⏳ À tester | RTSP/JPEG à comparer |
| Décapsulation de TCP/5002 hors ligne | ⚠️ Partiel | H.264 640×360 démontré sur capture |
| Prototype RTSP embarqué microSD | ⚠️ Partiel | Port répond ; vidéo décodable non démontrée |
| Caméra sans cloud Tuya | ❌ Non atteint | Dépendance stock conservée |

Les validations ci-dessus ne s'étendent pas automatiquement aux autres révisions de caméras Tuya.

