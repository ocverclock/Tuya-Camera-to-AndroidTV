# Diagnostics et erreurs : TCL + CleanYourTV

Les symptômes ci-dessous sont issus de nos essais ; ils ne doivent pas être présentés comme des bogues universels de CleanYourTV.

| Observation | Diagnostic | Remède / prudence |
|---|---|---|
| APK installé, mais Google/TCL Home reste visible | Le package launcher existe mais n'est pas forcément **Home actif** | Vérifier `resolve-activity`, lancement HOME, sauvegarde et mécanisme de retour arrière **avant** désactivation ciblée du Home stock |
| `adb: no devices/emulators found` | La session ADB n'est plus connectée (notamment après reboot) | `adb connect <TV_IP>:5555`, puis `adb devices` et autorisation sur TV |
| `unauthorized` / `offline` | Débogage non autorisé ou transport indisponible | Accepter l'autorisation TV, vérifier l'IP / le mode debug ; ne pas appliquer de changements pendant cet état |
| `mCurrentFocus=null` | Capture de fenêtre à un instant possiblement transitoire | Vérifier activité HOME et l'image réelle, ne pas interpréter seul |
| Échec de compilation avec `.backup-*` | Des copies placées dans les dossiers sources ont interféré avec une tentative de build | Tenir les sauvegardes **hors** des sources compilées ; revenir aux fichiers d'origine avant de reconstruire |
| Halo coloré visible | Effets `app_glow` / `ambient_glow` possibles | Désactiver selon **les options réellement reconnues** par la version du thème ; ne pas chercher à résoudre avec le zoom |
| Changement de thème efface des réglages | Upstream : overlay de thème et choix locaux peuvent avoir des priorités différentes | Sauvegarder et lire [themes/README](https://github.com/Gathin23/cleanyourtv/blob/main/themes/README.md) avant `theme.sh` |
| Couleurs/paysages répétitifs | Collection trop peu diversifiée ou shuffle inactif | Vérifier `wallpaper_order: shuffle` et les images locales horizontales |
| Météo/température incohérente | Une proposition de correctif logiciel avait été discutée | L'utilisateur a finalement signalé température OK ; **aucun patch météo compilé n'est attesté** |
| Plus d'accueil utilisable après debloat | Package Home critique désactivé sans alternative | Utiliser l'outil de restauration et le fichier de sauvegarde **effectivement créés**, pas une commande générique arbitraire |
| Glance ne montre rien | **Glance n'était pas installé** pendant ces essais | Distinguer intégration **future** caméra et fonctionnement **déjà validé** du lanceur |

## Bon ordre de test

1. Vérifier la liaison ADB et le package `com.gathin.tvhome`, sans modification.
2. Lire les états et sauvegarder la configuration actuelle.
3. Ne changer **qu'un paramètre à la fois**.
4. Comparer le comportement visuel réel avec l'objectif (halo neutre, bandeau bas, quatre favoris).
5. En cas d'échec, restaurer le dernier `config.json` connu et les désactivations via l'outil prévu.
6. Ne jamais confondre un **lancement d'intent** réussi avec une preuve que l'app est le HOME par défaut.

