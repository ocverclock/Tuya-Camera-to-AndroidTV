# Caméra Tuya → go2rtc → Home Assistant → Android TV

**Documentation modulaire et retour d'expérience réel.** L'objectif final est d'afficher une petite fenêtre de caméra sur Android TV, par-dessus SmartTube/Jellyfin, lorsqu'une personne est détectée. Mais chaque brique doit pouvoir servir **indépendamment** du reste.

[English README](README.md) · [Tableau des validations](docs/09-validation-matrix.md)

> **Situation vérifiée au 13 novembre 2026 :** authentification Tuya, go2rtc sur Dockge, correction FFmpeg et lecture **MSE satisfaisante** sur PC. L'intégration **Home Assistant**, l'événement humain dans HA et la popup **CleanYourTV / Frigate Glance** restent **à réaliser et à tester**. Aucun résultat futur n'est présenté comme déjà fonctionnel.

## Choisir son parcours

| Besoin | Documentation | Résultat |
|---|---|---|
| Utiliser une caméra Tuya d'origine | [01 — Caméra / Tuya](docs/01-camera-tuya.md) | Testé |
| Installer go2rtc avec Docker/Dockge | [02 — Docker / Dockge](docs/02-docker-dockge.md) | Testé |
| Corriger l'écran noir H.264 | [03 — FFmpeg et timestamps](docs/03-ffmpeg-black-video.md) | Testé |
| Ajouter la caméra à Home Assistant | [04 — Home Assistant](docs/04-home-assistant.md) | À tester |
| Ouvrir une popup sur la télévision | [05 — CleanYourTV / Frigate Glance](docs/05-cleanyourtv-glance.md) | À développer |
| Étudier le flux TCP local et le firmware | [06 — Recherche Anyka](docs/06-anyka-local-research.md) | Expérimental |
| Étudier la veille et les versions de firmware | [07 — Énergie / firmware](docs/07-power-and-firmware.md) | Partiel |

| **Reproduire et personnaliser CleanYourTV seul** | [12 — Retour d'expérience TCL](docs/12-cleanyourtv-field-report.md) | **Validé sur TCL** |

Autres ressources : [erreurs rencontrées](docs/08-troubleshooting.md), [validations](docs/09-validation-matrix.md), [sécurité](docs/10-security.md), [projets similaires](docs/11-references.md).

## Matériel du retour d'expérience

**Action / LSC Smart Connect Solar Outdoor PTZ SLF26322 (Action 3225730)**, SoC **Anyka AK3918AV100**, Linux 4.4.282, firmware Tuya **6.10.33** maintenu. Serveur Debian/Docker administré par **Dockge**, go2rtc **1.9.15**. La caméra sur batterie/solaire a des particularités de veille.

Le compte de l'application mobile **Tuya Smart** et le compte **Tuya Developer Platform** possédaient des mots de passe différents. Une fois la bonne connexion établie, go2rtc recevait des mégaoctets de H.264 mais tous les lecteurs affichaient du noir. FFmpeg a identifié des anomalies DTS ; une image JPEG et une vidéo MP4 corrigée étaient bonnes. Le live a été débloqué en régularisant la cadence et les horodatages, puis allégé à environ **960×540 / 12 ips**, avec lecture MSE jugée satisfaisante pour nos essais.

## Les deux branches du projet

1. **Parcours recommandé — firmware Tuya intact :** vidéo via compte Tuya dans go2rtc, correction FFmpeg, puis intégration HA et TV **à tester**.
2. **Recherche facultative « LSC Libre » :** rétro-ingénierie de la caméra Anyka, scripts microSD, TCP/5002, sommeil et autonomie sans cloud. Certaines découvertes matérielles ont été démontrées, **aucun firmware sans Tuya prêt à installer**.

La seconde branche ne doit pas ralentir ni mettre en danger la première.

## Architecture cible

~~~text
Caméra LSC d'origine → go2rtc → FFmpeg H.264 → aperçu MSE [validé]
                                      ├──> Home Assistant [à tester]
                                      └──> Frigate Glance TV [à tester]
Détection humaine Tuya → HA → MQTT/API compatible Frigate [à construire]
~~~

**Frigate ≠ Frigate Glance.** Glance est une application complémentaire Android TV, et non le NVR. Pour s'en passer, il faudra reproduire uniquement les événements et données qu'attend Glance. Un navigateur PC utilisant MSE n'implique pas que l'overlay Android utilise lui aussi MSE.

Voir les [exemples anonymisés](examples/) : ils **ne contiennent aucun compte ni appareil réel**. Ne publiez jamais une URL Tuya complète, qui contient les informations de connexion ; voir [sécurité](docs/10-security.md).

Le dépôt public est un **journal vérifiable**, non une recette universelle. Les documents privés de développement, les vidéos et les sauvegardes flash restent hors GitHub.

