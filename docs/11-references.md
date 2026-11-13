# 11 — Références et remerciements

Ces projets sont des **sources distinctes**. Aucun code ou firmware tiers n'est redistribué dans ce dépôt.

## Logiciels de l'architecture

- [AlexxIT/go2rtc](https://github.com/AlexxIT/go2rtc) — récupération, redistribution et réencodage vidéo.
- [AlexxIT/WebRTC](https://github.com/AlexxIT/WebRTC) — piste d'intégration Home Assistant, pas encore validée ici.
- [Gathin23/cleanyourtv](https://github.com/Gathin23/cleanyourtv) — lanceur TV déjà personnalisé, à préserver.
- [Frigate Glance](https://github.com/Gathin23/cleanyourtv/tree/main/addons/frigate-glance) — complément Android de popup ; nécessite événements MQTT et API Frigate.
- [Frigate NVR](https://github.com/blakeblackshear/frigate) — logiciel séparé, non déployé dans notre parcours actuel.
- [Issue go2rtc #2655](https://github.com/AlexxIT/go2rtc/issues/2655) — signalement de caméra solaire LSC qui fige ; **notre correctif ne prouve pas la résolution de ce ticket**.

## Recherches Anyka / autres modèles

- [berobloom/LSC-1080p-Anyka-Decloud](https://github.com/berobloom/LSC-1080p-Anyka-Decloud) — méthode de dé-cloud, matériel différent.
- [FluxAlchemist/LSC_AK3918AV130_cam_custom_firmware](https://github.com/FluxAlchemist/LSC_AK3918AV130_cam_custom_firmware) — architecture RTSP C pour **AV130**, non compatible en binaire avec notre AV100.
- [medevil84/ipcd](https://github.com/medevil84/ipcd) — démon vidéo local, matériel différent.
- [OpenIPC/builder issue #36](https://github.com/OpenIPC/builder/issues/36) — rapprochement de plateforme, pas un firmware directement utilisable.
- [Niek/lsc-solar-ip-camera](https://github.com/Niek/lsc-solar-ip-camera) — contraintes de veille solaire, SoC différent.
- [SotosSW/anykav380-ak3918-hacking](https://github.com/SotosSW/anykav380-ak3918-hacking) — pistes de commandes PTZ.

Les licences, conditions d'utilisation et compatibilités matérielles sont celles de chacun de ces projets.


Pour la personnalisation du lanceur et la restauration des changements ADB : [retour d'expérience TCL](12-cleanyourtv-field-report.md), [documentation officielle des thèmes](https://github.com/Gathin23/cleanyourtv/blob/main/themes/README.md), [script amont de restauration](https://github.com/Gathin23/cleanyourtv/blob/main/tools/restore.sh).
