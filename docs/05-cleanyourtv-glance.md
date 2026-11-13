# 05 — Frigate Glance sur TCL / CleanYourTV : retour d'expérience (13 novembre 2026)

**Statut : popup RTSP, plein écran HD, touches télécommande et liaison MQTT validés en tests manuels. Détection humaine réelle, fermeture automatique et fallback JPEG via passerelle encore non validés.**

Cette installation utilise **Frigate Glance comme application Android distincte** sur une TCL Android TV 9. **Frigate NVR n'est pas installé** : go2rtc fournit la vidéo, une petite passerelle HTTP imite les endpoints Frigate nécessaires, et Home Assistant / Mosquitto doivent envoyer des notifications `reviews`.

**Préserver CleanYourTV** : ne jamais réinitialiser son dock, son thème ou son lanceur.

## Chaîne de fonctionnement

~~~text
Caméra solaire LSC / Tuya
  ├─ direct Tuya → go2rtc → flux H.264 → Frigate Glance (miniature et plein écran)
  └─ détection humaine Tuya → Home Assistant (NON VÉRIFIÉ)
                                  └─ Mosquitto → topic reviews → popup TCL

go2rtc / image MJPEG → passerelle HTTP compatible Frigate → snapshot JPEG TCL
~~~

La vidéo est atteinte via RTSP depuis l'Android TV ; en parallèle d'une autre lecture vidéo, le code de Frigate Glance peut basculer sur des JPEG rafraîchis car un décodeur matériel peut être occupé. **Le JPEG de la passerelle n'est pas encore opérationnel** à la dernière observation du 13 novembre.

## Profils go2rtc testés

Le flux original `camera_action` est une session Tuya privée, à conserver exclusivement sur le serveur. Les exemples suivants supposent qu'un préréglage FFmpeg `h264_fast` a déjà été défini.

~~~yaml
streams:
  camera_action_ha_fast:
    - "ffmpeg:camera_action#video=h264_fast#raw=-vf fps=10,scale=640:-2,setpts=N/(10*TB)"
  camera_action_tv_popup:
    - "ffmpeg:camera_action#video=h264_fast#raw=-vf fps=8,scale=480:-2,setpts=N/(8*TB)"
  camera_action_tv_full:
    - "ffmpeg:camera_action#video=h264_fast#raw=-vf fps=12,scale=1280:-2,setpts=N/(12*TB)"
  camera_action_snapshot:
    - "ffmpeg:camera_action_tv_popup#video=mjpeg#raw=-r 1"
~~~

- **HA :** `camera_action_ha_fast`, Generic Camera RTSP, image observée fonctionnelle.
- **Miniature :** `camera_action_tv_popup`, 480×270 / 8 ips.
- **Plein écran :** `camera_action_tv_full`, 1280×720 / 12 ips, vérifié sur TCL.
- **JPEG :** `camera_action_snapshot`, 480×270, extraction go2rtc confirmée au moins une fois : HTTP 200, 17 154 octets, vrai JPEG. Ce succès **ne démontre ni la stabilité de la veille Tuya, ni celle du proxy JPEG**.

## Adaptation locale de Frigate Glance

Source Android : [Gathin23/cleanyourtv/addons/frigate-glance](https://github.com/Gathin23/cleanyourtv/tree/main/addons/frigate-glance).

Sur la version testée :
- `LiveVideo.java` : augmenter `GIVE_UP_MS` de **4000 à 15000** ; sans cela, le lecteur abandonne avant le démarrage du flux solaire, avec le délai supplémentaire la vidéo miniature est apparue.
- `GlanceConfig.streams` : `camera_action` → `camera_action_tv_popup`, et **clé supplémentaire locale** `camera_action_fullscreen` → `camera_action_tv_full`.
- `GlanceService.java` + `FullscreenActivity.java` : sélection locale de l'URL HD distincte lorsque la touche ▲ ouvre le plein écran. **Il s'agit d'une modification locale**, non d'une option standard garantie par la version upstream.
- Finition graphique locale : suppression de l'encadrement extérieur de la miniature ; suppression du texte « Back closes » en haut à gauche du plein écran ; validation visuelle utilisateur.
- `LiveVideo` utilise un lecteur RTSP Android, pas MSE dans l'application.

**Attention aux réinstallations :** elles peuvent déconnecter le service d'accessibilité qui capte les touches de la télécommande. Si ▲ déplace la sélection derrière l'overlay, vérifier sur la TV `accessibility_enabled` et `io.github.nickld.frigateglance/.KeyService`. Éviter d'écraser les autres services d'accessibilité.

Comportement validé : popup de test → ▲ plein écran HD → Retour à l'application précédente. Fermeture par ◀ après la notification MQTT réelle **non confirmée** ; `am force-stop io.github.nickld.frigateglance` a bien fermé une notification bloquée.

## Passerelle HTTP et MQTT : état des tests

Une passerelle distincte, conteneur Docker `camera-action-bridge`, a été installée sur le même hôte que go2rtc ; elle écoute sur **8057** en `network_mode: host`. Les vérifications suivantes ont réussi :
- `GET /health` renvoie `{"status":"ok","camera":"camera_action"}`.
- `GET /api/config` renvoie une entrée `cameras.camera_action` / `detect` / `live.streams`.
- Journaux Android : **`frigate ok`** puis **`mqtt connected`**, confirmant l'accès HTTP et au broker Home Assistant.
- Publication MQTT du `review` `new` sur le topic configuré → apparition de la popup TCL sans commande ADB.

**Problèmes ouverts :**
1. Le proxy `GET /api/camera_action/latest.jpg?h=270` renvoie **HTTP 503, 39 octets**, avec `snapshot not ready (ValueError)`. La tentative directe `/api/frame.jpeg?src=camera_action_tv_popup` a répondu **HTTP 200, Content-Length: 0**, ce qui n'est pas un JPEG.
2. Un flux dédié `camera_action_snapshot` (MJPEG) a répondu en direct avec un **JPEG 480×270 / 17 154 octets** après accès caméra via Tuya. **Il reste à confirmer que la passerelle utilise ce flux et qu'elle parvient à fournir un JPEG** ; un dernier essai via 8057 répondait encore 503.
3. Le message MQTT de type `end` n'a pas provoqué la fermeture attendue ; la fenêtre est restée affichée. **Ne pas prétendre que le TTL est fiable** ; examiner messages, IDs et machine d'état `CardController`, puis valider un cycle complet `new → end → fermeture`.
4. Le retour d'événement **« personne détectée » de Tuya vers HA n'a pas été identifié** dans les entités/événements ; seule la simulation par `mqtt.publish` est validée.
5. Le flux Tuya peut se figer après un changement réseau/veille ; le redémarrage du seul conteneur go2rtc l'avait rétabli. Hypothèse de session de veille/keepalive : **non prouvée**.

### Exemple générique d'alerte

~~~json
{"type":"new","after":{"id":"test-001","camera":"camera_action","severity":"alert","data":{"objects":["person"],"detections":[]}}}
~~~

Le topic est défini par `topicPrefix` dans l'application, dans notre configuration d'essai : `lsc_glance/reviews`. Un simple message MQTT `person` n'est pas suffisant. Ne pas publier de vrais identifiants MQTT ni l'URI Tuya dans le dépôt.

## Point de reprise ordonné

1. **Conserver l'état actuel** : ne pas toucher au lanceur ni aux flux RTSP validés.
2. Vérifier simultanément JPEG **direct go2rtc** et JPEG **via 8057**, sans ouvrir/fermer l'application Tuya entre les appels. Si direct OK / passerelle 503, inspecter le conteneur et son `SNAPSHOT_STREAM` effectif ; si les deux échouent, inspecter la session Tuya.
3. Réparer/valider la fermeture MQTT : nouveau `id` pour chaque détection, `end` avec le même `id`, délai de fermeture effectif, et solution de secours contre une alerte orpheline.
4. Trouver l'entité/événement humain Tuya réel dans Home Assistant avant de lier le déclencheur. La notification mobile n'en prouve pas la présence dans HA.
5. Faire l'essai caméra en veille, application Tuya du téléphone fermée, avec mesures du réveil/latence/autonomie.

Pour les traces réseau et les chemins privés exacts, consulter le dossier privé Drive `LSC_camera`.