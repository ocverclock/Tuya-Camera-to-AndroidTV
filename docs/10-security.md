# 10 — Sécurité et confidentialité du dépôt public

**Interdiction de publier** : URL `tuya://...` réelle, e-mail, mot de passe, identifiant d'appareil, jetons, clés Wi-Fi/MQTT/HA, captures de vidéos/photos privées, firmware/dumps MTD, ou journaux DEBUG non caviardés.

- La commande debug `[streams] start producer url=...` peut afficher **le mot de passe Tuya en clair**. Si exposé, **le renouveler** dans Tuya puis actualiser l'URL locale.
- Publier uniquement **go2rtc.yaml.example**, jamais votre configuration opérationnelle.
- Dans les docs, utiliser `<HOST_IP>` ou des adresses réservées à la documentation ; ne pas révéler les vrais hôtes/IP locaux de l'installation source.
- Garder UI/API go2rtc et RTSP sur **LAN de confiance** ; aucune redirection de ports sur Internet. Protéger les accès ; le port 1984 donne des informations techniques.
- Ne pas désactiver la veille batterie pour obtenir une image permanente.
- Les images flash contiennent potentiellement clés et secrets ; **ne pas les commiter**. Une sauvegarde ne garantit pas une restauration.
- Ne pas relancer des essais d'exécution root depuis une microSD provenant d'une source inconnue ; ne pas appliquer les GPIO ou partitions d'un autre SoC.

Avant chaque commit ou PR, rechercher les traces de `password=`, `device_id=`, `tuya://`, `@`, adresses IP, `mtd*.bin`, vidéos, journaux et archives.

