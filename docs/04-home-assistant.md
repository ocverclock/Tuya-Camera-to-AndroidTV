# 04 — Home Assistant : vidéo, MQTT et détection humaine

**État au 13 novembre 2026 : vidéo RTSP Home Assistant validée ; publication MQTT simulée → popup TCL validée ; vraie alerte humaine Tuya → HA non validée.**

## A. Vidéo Home Assistant : validée sur un profil dédié

La caméra solaire LSC passe par Tuya et un serveur **go2rtc**. Le profil `camera_action_ha_fast` a été testé avec succès dans Home Assistant via Generic Camera / RTSP :

~~~yaml
streams:
  camera_action_ha_fast:
    - "ffmpeg:camera_action#video=h264_fast#raw=-vf fps=10,scale=640:-2,setpts=N/(10*TB)"
~~~

URL générique : `rtsp://<HOTE_GO2RTC>:8554/camera_action_ha_fast`. L'adresse locale `127.0.0.1` dans HA ne désigne pas le serveur go2rtc distant.

**Limite :** le fonctionnement n'est pas garanti après un long sommeil solaire / expiration de session Tuya ; redémarrage de go2rtc déjà nécessaire lors d'un incident.

## B. MQTT : liaison avec Frigate Glance confirmée

La configuration de test contient une passerelle HTTP compatible Frigate (sans Frigate NVR) et la connexion à un broker MQTT Home Assistant. Les journaux TV ont confirmé `frigate ok` et `mqtt connected`. Un appel `mqtt.publish` avec une charge utile Frigate `reviews/new` a ouvert la popup sur TCL.

Exemple d'action HA générique (adapter le préfixe au paramétrage local de Frigate Glance) :

~~~yaml
action: mqtt.publish
data:
  topic: lsc_glance/reviews
  qos: 1
  retain: false
  payload: '{"type":"new","after":{"id":"test-001","camera":"camera_action","severity":"alert","data":{"objects":["person"],"detections":[]}}}'
~~~

**Non validé :** le message `end` n'a pas fermé la fenêtre comme prévu. La passerelle JPEG répond encore HTTP 503 lors du dernier test. Voir [05 — Frigate Glance](05-cleanyourtv-glance.md).

## C. Détection humaine Tuya : toujours à relever dans HA

L'application mobile Tuya de cette caméra propose « Détection par IA », « Détection de forme humaine », « Notification uniquement pour les messages de forme humaine », sensibilité et durée d'enregistrement 15/30 s. **Un push dans Tuya n'implique pas qu'une entité `binary_sensor` ou `event` soit disponible dans l'intégration HA.**

Prochaine étape : examiner les entités de la caméra dans *Paramètres → Appareils et services → Tuya* et *Outils de développement → États* pendant une détection humaine réelle. Si l'événement est disponible, construire une automatisation avec anti-rebond, `new` et `end` portant le même ID. Sinon, investiguer une voie de remontée compatible depuis Tuya ; ne pas inventer d'entité.

## Critères d'acceptation restants

- Popup et JPEG visibles pendant SmartTube/Jellyfin.
- Fermeture automatique fiable, même pour un message final perdu.
- Détection humaine **réelle** dans HA → TV, sans ouvrir Tuya sur téléphone.
- Réveil fiable et consommation maîtrisée pour la batterie solaire.
- Aucune seconde instance go2rtc ni ouverture réseau WAN.