# 05 — CleanYourTV et Frigate Glance sur Android TV

**Statut : ARCHITECTURE EN PRÉPARATION, non testée sur la télévision cible.**

Objectif : une **petite carte caméra** affichée automatiquement pendant SmartTube/Jellyfin lorsqu'une personne est détectée, puis disparaissant quelques secondes après. Le lanceur **CleanYourTV est déjà configuré et doit rester intact** : pas de remise à zéro, réinstallation ou écrasement du thème/dock.

## Ce que fait l'extension

[Frigate Glance](https://github.com/Gathin23/cleanyourtv/tree/main/addons/frigate-glance) est une **application Android complémentaire**, pas le serveur Frigate NVR. Son README décrit :

- la permission d'afficher par-dessus d'autres apps ;
- l'accès MQTT aux alertes Frigate et l'API HTTP pour les caméras/images ;
- la lecture RTSP de go2rtc quand le décodeur est libre ;
- **le basculement en images JPEG régulièrement rafraîchies pendant la lecture d'une autre vidéo**, lorsque la télévision ne peut pas décoder deux flux en parallèle ;
- fermeture automatique, snooze et actions télécommande.

**Conclusion importante :** la lecture MSE validée dans le navigateur PC ne prouve **pas** que la carte Android pourra utiliser MSE ou décoder le RTSP transcodé.

## Notre adaptation souhaitée, sans Frigate NVR

~~~text
go2rtc camera_action_tv ─────────────────┐
                                         ├─ pont Frigate-compatible HTTP/MQTT → Frigate Glance
Tuya « humain détecté » → HA → événement ┘
~~~

Frigate Glance attend des informations Frigate, notamment des messages apparentés à `frigate/reviews` / `frigate/events` et des endpoints comme `/api/config` ou `/api/<camera>/latest.jpg`. **go2rtc seul ne fournit pas toute cette interface.** L'adaptateur minimal est **à développer et vérifier contre le code de la version Glance utilisée** ; aucun serveur compatible ni APK personnalisé n'est livré ici.

## Ordre de test, sans abîmer le lanceur

1. Vérifier le package CleanYourTV et l'accès ADB à la TV ; sauvegarder sa configuration existante.
2. Examiner **avant de lancer** le script d'installation upstream de Frigate Glance : il active notamment permissions overlay, accessibilité et démarrage automatique.
3. Installer Glance comme **application distincte** et lancer une carte de test **manuelle** au-dessus du lanceur, de SmartTube puis de Jellyfin.
4. Tester le flux `camera_action_tv` en RTSP côté TV ; tester les **JPEG** pendant une autre lecture vidéo si le décodeur est occupé.
5. Développer l'adaptateur API/MQTT minimal et valider un événement simulé, puis la vraie détection HA.
6. Mesurer délai d'apparition, fermeture 20–30 s visée, charge, veille solaire et télécommande.

L'[exemple de configuration Glance](../examples/frigate-glance-config.example.json) est un **squelette**, inutilisable avec go2rtc seul avant un adaptateur compatible. Ne pas présenter cela comme une intégration « un clic ».

