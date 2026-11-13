# 08 — Problèmes réellement rencontrés

| Symptôme | Cause ou piste | Solution / test |
|---|---|---|
| Tuya « compte ou mot de passe incorrect » | Compte mobile ≠ compte Tuya Developer | Mot de passe **de l'app mobile**, région serveur correcte |
| `cannot unmarshal !!str into map` | `tuya://` collée seule comme contenu YAML | Déclarer l'URI sous `streams` |
| `open /config/go2rtc.yaml: is a directory` | Docker a créé un **répertoire** au lieu du fichier | Inspecter bind hôte / volume `/config` |
| `OCI runtime ... not a directory` | Montage fichier ↔ répertoire incompatible | Chemin hôte **absolu**, vérifier la nature des chemins et volumes, sans prune global |
| Édition UI impossible | Fichier monté avec `:ro` | Donner accès écriture seulement si nécessaire |
| Pas de `DBG` dans les logs | `debig` au lieu de `debug` | Corriger le niveau de log |
| `exit with signal: terminated` | Peut correspondre au redémarrage | Vérifier que le conteneur est `Up` |
| `ps -C` échoue dans le conteneur | BusyBox `ps` sans option `-C` | Utiliser `ps -o pid,etime,args` |
| Python `'str' object has no attribute 'get'` | Champ `medias` = liste de chaînes | Utiliser [inspect-streams.sh](../scripts/inspect-streams.sh) |
| H.264 reçu, écran noir | DTS irréguliers observés ; décodage à vérifier | JPEG puis MP4 FFmpeg `fps` + `setpts` |
| HEVC `unspecified size` | Piste H.265 vide parfois sélectionnée | Examiner les pistes et la réception H.264 |
| `non monotonically increasing dts` | Images horodatées de façon incohérente | Réencodage et horodatages reconstruits |
| `deprecated pixel format used` | Avertissement de conversion FFmpeg | Pas forcément bloquant ; juger la sortie |
| MP4 avec 3–5 s de retard | Tampon du lecteur / pipeline | Comparer à MSE optimisé |
| MSE très saccadé | Coût/transit/horodatages possibles | 960 pixels, 12 ips, profil rapide, mesurer |
| « Humain détecté » absent de HA | Événement non encore vérifié | Inspecter entités/événements avant automatisation |

| go2rtc `frame.jpeg` répond HTTP 200 mais 0 octet | Absence de JPEG exploitable ; caméra ou source non décodable | Vérifier taille et type MIME, comparer source H.264 et flux MJPEG dédié, puis le réveil solaire |
| Passerelle Frigate `latest.jpg` retourne 503 et `snapshot not ready (ValueError)` | Extraction d'image échouée, malgré HTTP/MQTT connectés | Comparer JPEG direct `1984` et proxy `8057` ; inspecter le `SNAPSHOT_STREAM` effectif |
| Popup reçue via MQTT mais « No image » | Notifications opérationnelles, JPEG proxy indisponible | Réparer JPEG indépendamment du message MQTT |
| Notification MQTT `new` reste affichée malgré `end` | Fin/temporisation non validée | Vérifier même ID `new/end`, `CardController`, minuterie ; `am force-stop` seulement en dépannage |
| Télécommande ▲ déplace la sélection derrière la popup | Service d'accessibilité désactivé (test `accessibility_enabled=0`) | Activer `KeyService` de Frigate Glance, en préservant les services existants |
| Frigate Glance abandonne le RTSP solaire trop tôt | `GIVE_UP_MS=4000` trop court au réveil | Patch local `LiveVideo.java` à 15000 ms (test concluant) |

**Confidentialité :** les logs DEBUG montrent le mot de passe et l'URL complète du compte Tuya. Ne jamais les coller tels quels dans une issue.

