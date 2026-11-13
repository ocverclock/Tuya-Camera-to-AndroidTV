# 12 — CleanYourTV sur TCL Android TV 9 : retour d'expérience (novembre 2026)

**Projet indépendant et réutilisable.** Ce chapitre documente la préparation de notre TV *avant* toute intégration caméra. Il complète [05 — Frigate Glance](05-cleanyourtv-glance.md) : on peut adopter CleanYourTV sans Tuya, go2rtc, Home Assistant ou Frigate.

**Origine des faits :** essais ADB et retours utilisateur des 6–8 novembre 2026, puis état du 13 novembre, complétés par les notes du projet caméra conservées sur Drive. Les scripts et thèmes viennent du dépôt amont [Gathin23/cleanyourtv](https://github.com/Gathin23/cleanyourtv). **Aucune sauvegarde privée de la TV, APK modifié, capture d'écran personnelle ou adresse réseau réelle n'est publiée.**

> **Résultat acquis :** CleanYourTV `com.gathin.tvhome` a été installé, ouvert sur la TCL et utilisé avec le thème nature-calm et quatre favoris. Le résultat de configuration a été explicitement déclaré **« CONFIGURATION VALIDÉE »**. L'installation de Frigate Glance, la superposition caméra et l'automatisation Tuya restent **non réalisées**.

## 1. Téléviseur et environnement des tests

| Élément | Observé |
|---|---|
| TV | TCL BeyondTV2, Android TV 9 |
| Build | `PPR1.180610.011 / AP06` |
| Outil de connexion | ADB TCP via Wi-Fi / réseau local (`<TV_IP>:5555`) |
| Environnement de préparation | Linux Zorin OS ; un iMac a aussi servi de client ADB |
| Source du logiciel | Projet amont `Gathin23/cleanyourtv` |
| Package de l'application | `com.gathin.tvhome` |
| Root / flashage | Non requis pour cette approche |
| But | Remplacer l'accueil publicitaire, conserver les fonctions TV utiles, construire un dock sobre et personnalisable |

Nous ne garantissons pas ces résultats sur tous les TCL Android 9 : les services préinstallés et les autorisations changent selon modèle et firmware.

## 2. Ce que nous avons conservé ou désactivé

Le but n'était **pas** de tout désactiver. Les fonctions à préserver étaient **Chromecast / Google Cast**, **mises à jour système**, **HDMI / CEC**, TV et lecture vidéo. L'assistant vocal et les suggestions publicitaires n'étaient pas souhaités.

**Packages TCL désactivés au cours des essais :**
- `com.tcl.samba` — composant de collecte Samba TV ;
- `com.tcl.assistant` — assistant TCL ;
- `com.tcl.bootadservice` — service publicitaire au démarrage.

Cette liste est **un retour d'expérience sur notre appareil**, **pas** une liste universelle à appliquer sur tous les TCL. L'état désactivé n'est pas une preuve d'absence totale de télémétrie : il faudrait une capture réseau pour établir ce point. **Ne jamais désactiver sans identifier le package ni enregistrer son état initial.** Voir [ADB, sauvegarde et restauration](cleanyourtv/adb-et-restauration.md).

### Le point bloquant : récupérer la touche Home

Le launcher CleanYourTV était présent et lançable, mais l'accueil Google/TCL restait initialement prioritaire. Il a fallu **désactiver le lanceur d'origine concerné sur notre appareil** pour que CleanYourTV prenne la main. Le nom exact du package Home stock doit être **identifié sur chaque TV**, pas deviné ou repris d'une autre marque.

Ne pas exécuter une commande de désactivation du Home stock avant d'avoir :
1. confirmé le démarrage de CleanYourTV ;
2. relevé le gestionnaire Home en place ;
3. vérifié une sauvegarde et une procédure de retour arrière ;
4. conservé ADB et l'accès aux paramètres.

## 3. Configuration finale visée : peu d'apps, peu d'effets

**Dock retenu — quatre applications, dans cet ordre :**

| Application | Package relevé |
|---|---|
| SmartTube | `org.smarttube.stable` |
| IBO Pro | `com.ibopro.player` |
| Jellyfin Android TV | `org.jellyfin.androidtv` |
| OQEE / Free TV | `net.oqee.androidtv.store` |

La personnalisation est issue de **`nature-calm`** : fond presque noir (`#05070C`), **photos nature horizontales**, ordre aléatoire, **rotation toutes les 5 minutes**, couleurs non dénaturées, atténuation **14 %**, et **dock translucide** placé aussi bas que possible.

**Leçons visuelles réellement apprises :**
- **Halo coloré : rejeté.** Essai jugé insatisfaisant (« C'est moche ») ; préférer **pas de halo coloré**, seulement un focus discret non coloré.
- **Pulsation : abandonnée.** Ne pas interpréter une démonstration comme une option finale.
- **Agrandissement du focus :** une valeur **supérieure à 12 %** était demandée ; un **zoom de 16 %** et des rayons de 12 dp (tuiles) / 18 dp (bandeau) ont été **proposés**, mais leur intégration nécessitait une modification de code/compilation et **n'est pas certifiée validée sur la TV**.
- **Coins arrondis :** une esthétique plus discrète et de type Apple était préférée ; l'abaissement effectif des rayons ne doit pas être présenté comme testé.
- **Opacité du verre :** **40 %** figurait dans une configuration effectivement relevée ; **30 %** et des changements de taille ont également été envisagés. Aucune sauvegarde finale complète ne permet de garantir que **40 %** était la dernière valeur.
- **Légendes des photos :** actives dans un état relevé ; une désactivation ultérieure a été proposée sans preuve consolidée de son adoption définitive.

La bonne méthode publique est donc de fournir [un exemple de thème commenté](../examples/cleanyourtv/nature-calm-4-apps.example.json) et non d'affirmer disposer du `config.json` exact de la TV. Voir [choix esthétiques](cleanyourtv/theme-et-ergonomie.md).

## 4. Fonds d'écran

La collection `nature-calm` amont propose des photos de paysages sous diverses licences Wikimedia, avec crédits. Des alternatives ont été recherchées pour une plus grande **diversité de paysages naturels**, toujours en **format horizontal pour téléviseur**. L'utilisateur a retenu **[Wallhaven](https://wallhaven.cc/)** comme source particulièrement adaptée aux wallpapers de bureau/TV.

**Ne pas recopier les photos Wallhaven dans le dépôt** sans vérifier la licence de chaque image et les éventuels crédits. Le dossier Git contient la méthode, pas les images. Voir [fonds d'écran](cleanyourtv/fonds-ecran.md).

## 5. Sauvegarde de configuration : le vrai prérequis aux tests

Les échanges attestent une copie de `config.json` du launcher (environ **5,3 Ko**) et une sauvegarde de fonds d'écran (environ **12,2 Mo**). Une méthode d'injection et de relecture ADB a été testée/proposée pendant les ajustements ; toutes les comparaisons de fichiers **n'ont pas été confirmées** dans les traces conservées.

**Règle reproductible :** avant chaque nouvelle modification, sauvegarder localement :
- le JSON de configuration et les images du launcher ;
- les packages désactivés et l'identité du Home stock ;
- la version de CleanYourTV et du firmware ;
- la procédure de retour arrière.

Le script de restauration de debloat **amont** dépend du **même fichier de liste** utilisé à la désactivation ; une simple liste de nos trois packages n'est pas un inventaire complet de votre TV.

Voir [ADB et restauration](cleanyourtv/adb-et-restauration.md).

## 6. Incidents et tentatives non concluantes

- **« No devices/emulators found »** : l'ADB n'était plus connecté à l'IP de la TV, notamment après des redémarrages ; reconnecter et contrôler `adb devices` avant une installation.
- **Compilation perturbée par des fichiers `.backup-*`** : une tentative de réduire la taille des tuiles a échoué dans ce contexte ; éviter d'introduire des copies de fichiers sources dans les dossiers réellement compilés.
- **`mCurrentFocus=null`** : un état fugace de `dumpsys window` ne signifie pas que le launcher est absent ; vérifier le package et lancer explicitement l'activité HOME pour compléter le diagnostic.
- **Réglages météo/température** : l'utilisateur a signalé ensuite que la température s'affichait correctement. Une proposition de modification du code météo n'a pas été démontrée comme compilée ; ne pas la promouvoir comme correctif prouvé.
- **Retour du Home Google/TCL** : lorsque le launcher installé ne devient pas l'accueil effectif, identifier le composant Home exact et préserver le retour arrière.

[Guide de dépannage détaillé](cleanyourtv/diagnostics-et-erreurs.md).

## 7. Pourquoi ce travail prépare Frigate Glance

L'objectif futur est une carte caméra **au-dessus d'autres applications**, sans toucher à la configuration CleanYourTV déjà aboutie. L'extension [Frigate Glance](https://github.com/Gathin23/cleanyourtv/tree/main/addons/frigate-glance) est **séparée** du lanceur et requiert des permissions de superposition, un serveur/API Frigate compatible et MQTT. Sur notre matériel elle **n'est pas encore installée**.

Dans les prochaines étapes : sauvegarder le launcher, tester une carte de démonstration, puis un RTSP/JPEG venant de go2rtc, enfin un événement humain Tuya/HA. Ne pas supposer que la vidéo MSE qui fonctionne dans un navigateur PC fonctionnera dans le lecteur Android.

[Module TV / Frigate Glance](05-cleanyourtv-glance.md) · [Module Home Assistant](04-home-assistant.md) · [Matrice des validations](09-validation-matrix.md).

## 8. Limites du retour d'expérience

Ce document est une **reconstruction des faits observés**, **pas** un export complet de la dernière configuration TV. Les paramètres explicitement proposés mais non confirmés sont signalés. Les commandes génériques et le thème d'exemple doivent être adaptés au matériel, au dépôt amont du jour et à votre configuration personnelle.

