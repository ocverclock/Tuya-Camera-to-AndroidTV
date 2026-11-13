# 04 — Home Assistant : vidéo et événements humains

**Statut : À TESTER.** Cette intégration est la prochaine étape du projet, **indépendamment** de la popup Android TV. Ne pas publier de capture ou d'entité HA prétendument validée avant essai.

## A. Afficher le flux vidéo dans HA

Prérequis : `camera_action_tv` lisible sur le LAN et go2rtc accessible depuis l'instance Home Assistant. **L'adresse 127.0.0.1 sur HA ne désigne pas le serveur go2rtc externe.**

**Option 1 — Generic Camera :** dans Home Assistant, explorer *Paramètres → Appareils et services → Ajouter une intégration → Generic Camera*. Tester comme **source vidéo** l'URI `rtsp://<HOST_IP>:8554/camera_action_tv`, et si nécessaire une source JPEG via l'API go2rtc `http://<HOST_IP>:1984/api/frame.jpeg?src=camera_action_tv` (vérifier cet endpoint sur votre version avant de le déclarer).

**Option 2 — WebRTC Camera :** examiner [AlexxIT/WebRTC](https://github.com/AlexxIT/WebRTC) et sa connexion à **une instance go2rtc déjà existante**. Éviter d'installer un deuxième serveur inutile avec conflit de ports.

**Tests à documenter :** vignette, vidéo animée, latence, reprise après redémarrage, CPU et comportement de veille. Une caméra solaire ne doit pas être sollicitée constamment par un tableau de bord resté ouvert.

## B. Obtenir « Humain détecté » depuis Tuya

L'application mobile Tuya expose des déclencheurs d'automatisation **« Mouvement détecté »** et **« Humain détecté »** pour notre caméra. **Cela ne prouve pas** que l'intégration officielle Tuya crée un `binary_sensor` ou envoie un événement dans HA.

Étapes de validation :

1. Inventorier les entités de la caméra effectivement visibles dans HA.
2. Déclencher une vraie détection devant la caméra ; vérifier *Outils de développement → États* et les événements disponibles.
3. Si rien n'arrive directement, envisager **à titre expérimental** une automatisation Tuya qui bascule un appareil Tuya auxiliaire visible dans HA, puis détecter sa transition. Ce contournement n'a pas encore été essayé.
4. Après validation seulement, créer un déclencheur HA avec anti-rebond, événement « début/fin », et durée de notification.
5. Traduire l'événement vers le format **Frigate-compatible MQTT/API** attendu par Frigate Glance : un simple texte MQTT `person` ne suffit pas.

## C. Critères d'acceptation

- Entité caméra réelle et lisible depuis le tableau de bord.
- Aucune deuxième instance go2rtc non désirée.
- Événement « humain » réellement observé, et non supposé.
- Une alerte par passage, durée de présence, fermeture automatique.
- Pas de réduction significative de l'autonomie batterie.
- Aucun port WAN ouvert.

Voir [05 — CleanYourTV / Frigate Glance](05-cleanyourtv-glance.md) pour la cible d'affichage ; cette partie **n'est pas encore livrée**.

