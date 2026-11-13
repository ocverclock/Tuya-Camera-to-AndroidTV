# 06 — Recherche avancée : Anyka, microSD, TCP/5002

**Branche expérimentale séparée du parcours go2rtc recommandé.** Aucun firmware « sans Tuya » stable n'est disponible dans ce dépôt.

## Constats sur caméra réelle

LSC SLF26322 : SoC **Anyka AK3918AV100**, ARM926EJ-S, Linux **4.4.282**, firmware installé **6.10.33**. Sauvegarde en lecture seule de **11 partitions MTD** réalisée ; les dumps restent **privés** (clés/configuration potentiellement incluses).

- Le script stock `/bin/check_test_shell.sh` peut exécuter des scripts depuis `/tmp/sdcard/test_shell/` au démarrage. Sur cet appareil, un test a démontré l'exécution en root. **Ne pas lancer de script inconnu sur cette entrée.**
- Services internes identifiés : `app_boot` (Tuya, Wi-Fi, MCU/énergie, démarrage), `app_media` (captation/encodage).
- Le port TCP **5002** répond lorsque la caméra est active. Une capture de **1 240 140 octets** contenait de la vidéo encapsulée ; un extracteur expérimental a reconstitué du **H.264 640×360**, reconnaissable par FFmpeg. Une autre extraction hors ligne indiquait également une piste HEVC 2560×1440. Ces résultats concernent les captures testées.
- Les messages observés utilisent notamment un marqueur `68 68` et différentes catégories de trames ; les longueurs et le cadrage ont été **déduits empiriquement**, non documentés par le fabricant.
- Prototype « LSC Libre V0.2 » exécuté via microSD : service HTTP d'état et RTSP local écoutaient initialement, mais `ffprobe` signalait `h264` avec **width=0 height=0`. Une image vidéo RTSP exploitable n'a **pas** été prouvée.
- Les services sont ensuite devenus inaccessibles ; mise en veille, Wi-Fi, reboot ou arrêt électrique restent possibles.

## Pourquoi nous conservons le firmware d'origine

La caméra utilise la batterie et le solaire. Le binaire `app_boot` est impliqué dans des fonctions vitales : réveil, batterie, Wi-Fi, MCU et contrôle. Le désactiver sans substitut testé peut rendre la caméra inutilisable. Aucun cycle complet **veille → réveil autonome local → vidéo → veille** n'a encore été validé.

Nous avons donc privilégié le **flux stock Tuya + go2rtc + FFmpeg** pour l'usage concret. Les archives de recherche microSD restent dans un espace privé. **Ne pas publier** flash, vidéos, binaires propriétaires, mots de passe, identifiants caméra ni scripts dangereux non vérifiés.

Voir [07 — énergie et firmwares](07-power-and-firmware.md) et [références techniques](11-references.md).

