# 01 — Caméra et compte Tuya

**Testé sur LSC SLF26322 / Anyka AK3918AV100 / stock 6.10.33**, sans modification de firmware. Une référence commerciale voisine ne garantit pas le même matériel.

## Connexion

1. Vérifier d'abord le direct dans l'application mobile **Tuya Smart**.
2. Ouvrir l'assistant Tuya dans l'interface go2rtc. Sur notre compte France, la région de serveur **EU Central** fonctionnait ; ce choix n'est pas une liste de pays.
3. Saisir l'adresse et **le mot de passe du compte de l'application mobile**, pas celui de **Tuya Developer Platform**. Ils peuvent différer malgré le même e-mail. Notre première authentification échouait pour cette raison.
4. Après découverte de la caméra, récupérer en privé l'URL `tuya://...` générée par go2rtc. Elle contient des données d'authentification : ne jamais l'envoyer sur GitHub.
5. Dans `go2rtc.yaml`, placer cette URI sous `streams.camera_action` ; une URL collée comme tout le document provoque une erreur YAML.

Extrait **fictif** :

~~~yaml
streams:
  camera_action:
    - "tuya://GENERATED_PRIVATE_URL_REPLACE_LOCALLY"
~~~

Le format réel est celui produit par l'assistant go2rtc. Le modèle testé annonçait des pistes H.264 et H.265, mais seule la piste H.264 recevait des octets lors du contrôle.

**Limites :** l'authentification et les octets reçus ne prouvent ni une image décodable ni la disponibilité du direct après la veille solaire. Cette méthode **reste dépendante de Tuya**. Voir [03 — diagnostic vidéo](03-ffmpeg-black-video.md).

