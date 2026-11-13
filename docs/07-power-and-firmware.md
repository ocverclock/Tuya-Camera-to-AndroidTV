# 07 — Veille solaire et versions de firmware

**Observations partielles.** Le fonctionnement de la batterie et des réveils n'est pas équivalent à celui d'une caméra alimentée sur secteur.

## PowerTrace microSD

Lors de tests avec des journaux de processus/ports/sommeil :

- **Direct Tuya maintenu ouvert** : une session de 90 échantillons s'est achevée normalement, avec un dernier uptime Linux de **194,66 s** ; `app_boot` et `app_media` restaient présents.
- **Direct fermé après environ 20 s** : dernier échantillon du boot à **124,16 s**, sans fin normale de trace, puis autre identifiant de boot dans le journal. Cela **suggère** un événement d'arrêt/veille mais **ne démontre pas sa cause** : reboot, alimentation et autres interventions ne sont pas exclus.
- Le flag `/tmp/sleep_flag` n'a pas été observé avant l'interruption du test, et les compteurs réseau `iot0` ne suffisent pas à prouver une panne Wi-Fi.

## Firmware

- **6.10.33** : version **installée et utilisée**.
- **6.10.42** : OTA **proposée, téléchargée et comparée hors ligne**, **non installée**.

Les analyses archivées indiquent un `app_media` identique (SHA-256) mais un `app_boot` différent entre versions ; elles ne permettent **pas** d'attribuer une correction du sommeil ou du flux à la 6.10.42. La sauvegarde de la flash ne constitue pas une méthode de restauration validée.

**Conseil pour reproduire les essais :** ne pas mettre à jour ou flasher pendant le diagnostic vidéo. Tester des périodes d'inactivité, les réveils, la charge solaire, le CPU du serveur et la possibilité d'un aperçu **à la demande**. Ne pas désactiver la veille en permanence sans bilan énergétique.

