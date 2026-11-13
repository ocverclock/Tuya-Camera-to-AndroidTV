# ADB, sauvegarde et restauration — TCL Android 9

**Testé :** contrôle de la TCL BeyondTV2 par ADB réseau ; package de lancement `com.gathin.tvhome`. Commandes **génériques** ci-dessous, avec un hôte fictif et sans secret. Travailler **sur votre réseau local**.

## Lire sans modifier

Sur l'ordinateur équipé d'Android platform-tools :

~~~bash
export TV_HOST="<TV_IP>"
adb connect "$TV_HOST:5555"
adb devices
adb -s "$TV_HOST:5555" shell getprop ro.build.version.release
adb -s "$TV_HOST:5555" shell getprop ro.build.display.id
adb -s "$TV_HOST:5555" shell pm list packages | grep -Ei 'gathin|smarttube|jellyfin|oqee|ibopro'
~~~

L'invite Android **« Autoriser le débogage USB ? »** doit être acceptée sur la TV. Si `unauthorized` ou `offline`, ne pas poursuivre les commandes de modification.

Lecture de l'accueil : les commandes et les formats des champs varient selon le firmware. Le fait qu'un package soit installé **n'implique pas** qu'il reçoive Home.

~~~bash
adb -s "$TV_HOST:5555" shell cmd package resolve-activity --brief \
    -a android.intent.action.MAIN -c android.intent.category.HOME
adb -s "$TV_HOST:5555" shell pm list packages -d
~~~

Pour examiner le comportement de la touche Home sans désinstaller :

~~~bash
adb -s "$TV_HOST:5555" shell am start \
    -a android.intent.action.MAIN -c android.intent.category.HOME
~~~

Un `mCurrentFocus=null` isolé ne suffit pas pour conclure ; vérifier aussi l'activité et l'affichage à l'écran.

## Sauvegarder avant de modifier

Dans notre historique, un JSON launcher d'environ **5,3 Ko** et un pack d'images d'environ **12,2 Mo** ont été sauvegardés. Le chemin généralement relevé sur Android 9 était :

`/sdcard/Android/data/com.gathin.tvhome/files/config.json`

La disponibilité de ce chemin dépend de la version d'Android et du launcher ; inspecter avant de copier :

~~~bash
mkdir -p ./backup-cleanyourtv
adb -s "$TV_HOST:5555" pull \
  /sdcard/Android/data/com.gathin.tvhome/files/config.json \
  ./backup-cleanyourtv/config-before.json
adb -s "$TV_HOST:5555" shell pm list packages -d > ./backup-cleanyourtv/packages-disabled-before.txt
~~~

**Ne pas publier ces sauvegardes** : elles peuvent contenir noms de réseau, préférences ou chemins personnels. Pour les wallpapers, s'appuyer sur l'outil de thème amont et sauvegarder le dossier image réellement présent sur la TV ; ne pas supposer que le chemin de la collection est identique à celui du JSON.

## Modification de thème, méthode privilégiée

Le projet amont propose un système de thèmes avec `config.json` et collection `wallpapers/` (sans recompilation APK). Depuis son dépôt, **après sauvegarde** et en adaptant l'adresse :

~~~bash
TV_HOST="<TV_IP>" tools/theme.sh themes/nature-calm
~~~

**Attention :** d'après la documentation upstream, réappliquer un thème peut réinitialiser certains choix d'interface faits depuis les réglages du launcher. **Ne pas lancer cette commande sur une installation personnelle achevée simplement pour tester.** Le thème d'exemple publié ici doit être copié dans un dossier personnel, puis relu avant usage.

## Debloat : seulement après inventaire

Les packages `com.tcl.samba`, `com.tcl.assistant` et `com.tcl.bootadservice` ont été désactivés lors de nos essais. **Ne pas les désactiver aveuglément sur une autre TV.** Le projet amont dispose de scripts de désactivation/réactivation qui enregistrent les états, et vérifient des cas à risque :

- [tools/disable.sh](https://github.com/Gathin23/cleanyourtv/blob/main/tools/disable.sh)
- [tools/restore.sh](https://github.com/Gathin23/cleanyourtv/blob/main/tools/restore.sh)

La restauration utilise **la même liste de packages** et les états enregistrés au moment de la désactivation. Ne pas improviser un `pm disable-user` sur l'accueil stock avant d'avoir une alternative fonctionnelle et un chemin de récupération.

Les fonctions **Chromecast / Google Cast**, mises à jour système et HDMI/CEC doivent rester actives. **Ne pas** désactiver arbitrairement les services Google Play ou les composants de mise à jour.

## Revenir en arrière

Si un thème gêne, la commande amont `tools/theme.sh --reset` retire l'overlay de thème et restaure les réglages intégrés, **mais ne restaure pas les apps système désactivées**. Le `tools/restore.sh` concerne les packages désactivés, **pas le thème**. Préserver les deux plans de retour arrière.

**Ne pas publier les IP réelles, APK personnels ni sauvegardes complètes.**

