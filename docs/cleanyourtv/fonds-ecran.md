# Fonds d'écran horizontaux pour CleanYourTV

Objectif confirmé : un écran TV **paysage/horizontal**, des photos naturelles HD de qualité et une collection **variée**, pas seulement une même région ou un seul type de paysage. La rotation était fixée à **cinq minutes**, en ordre **aléatoire**.

## Deux sources distinctes

**1. Le thème `nature-calm` amont**

Le [thème officiel](https://github.com/Gathin23/cleanyourtv/tree/main/themes/nature-calm) fournit une douzaine de photographies de nature depuis Wikimedia Commons, avec les crédits et licences correspondants dans [`CREDITS.md`](https://github.com/Gathin23/cleanyourtv/blob/main/themes/nature-calm/CREDITS.md). Ces photos sont soumises à leurs propres licences ; la licence Apache-2.0 de notre dépôt ne les remplace pas.

**2. Wallhaven, retenu pour élargir les paysages**

L'adresse que nous avons jugée particulièrement adaptée aux fonds de téléviseur est **https://wallhaven.cc/**. Les recherches portaient sur grands espaces, canyons, forêts, montagnes, paysages naturels variés.

Choisir des images avec :
- orientation **horizontale**, idéalement ratio **16:9** (ou recadrage compatible) ;
- résolution au moins Full HD pour le rendu téléviseur ;
- absence de filigranes ; images dont l'utilisation est autorisée ;
- mélange de régions et saisons plutôt qu'un lot monotone.

**Droit d'auteur :** une image trouvée sur Wallhaven n'est **pas automatiquement libre de réutilisation**. Ce dépôt n'héberge donc aucun pack trouvé en ligne, ni photographie copiée depuis un service externe.

## Configuration de base

~~~json
{
  "wallpaper": true,
  "wallpaper_rotation_minutes": 5,
  "wallpaper_order": "shuffle",
  "wallpaper_true_color": true,
  "wallpaper_dim": 14
}
~~~

Cela définit l'affichage ; il faut toujours fournir **les fichiers images appropriés**, selon la méthode de thème amont. Les métadonnées de crédits ne doivent pas être perdues lors du tri des fichiers.

Pour importer une collection locale avec le lanceur, consulter [la documentation des thèmes](https://github.com/Gathin23/cleanyourtv/blob/main/themes/README.md) : la structure attend un thème avec `config.json` et éventuellement `wallpapers/`. Ne pas remplacer une collection sauvegardée sans avoir une copie de retour arrière.

