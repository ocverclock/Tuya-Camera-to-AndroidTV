# Thème nature-calm — décisions UI/UX et essais

Le rendu recherché est **Apple TV sobre, moins de halos colorés**, plutôt qu'une démonstration d'effets visuels. Notre historique couvre plusieurs itérations : **ne pas mélanger un essai et une configuration finale**.

## Dock confirmé

Quatre favoris, par ordre :

1. SmartTube — `org.smarttube.stable`
2. IBO Pro — `com.ibopro.player`
3. Jellyfin — `org.jellyfin.androidtv`
4. OQEE / Free TV — `net.oqee.androidtv.store`

Le dock a été souhaité **centré, très bas, compact**, avec bandeau de verre. Une grille réduite, des tuiles plus petites et la suppression d'une rangée secondaire ont été **envisagées**, mais certains essais de compilation n'ont pas abouti.

## Valeurs relevées dans la configuration nature-calm

| Clé | Valeur observée/retenue | Précision |
|---|---|---|
| `background_color` | `#05070C` | Fond très sombre |
| `wallpaper_rotation_minutes` | `5` | Toutes les cinq minutes |
| `wallpaper_order` | `shuffle` | Rotation aléatoire |
| `wallpaper_true_color` | `true` | Pas de palette recolorée |
| `wallpaper_dim` | `14` | Atténuation modérée |
| `dock_glass` | `true` | Bandeau de verre |
| `dock_opacity` | `40` à une étape | Un essai/proposition à 30 % a aussi existé ; état final non exporté |
| `ambient_glow` | `false` demandé | Suppression du halo d'ambiance coloré |
| `app_glow` | `false` demandé | Rejet des halos colorés sous les apps |
| `focus_overshoot` | `false` | Éviter le rebond |
| `advanced_effects` | `true` à une étape | Les animations décoratives peuvent ensuite être affinées |
| `wallpaper_captions` | `true` à une étape | Désactivation proposée plus tard, résultat final non confirmé |

Le [`nature-calm` officiel](https://github.com/Gathin23/cleanyourtv/tree/main/themes/nature-calm) a ses propres valeurs par défaut, notamment **six applications** ; notre dock **quatre apps** est une personnalisation de ce thème, pas une copie inchangée.

## Essais rejetés ou non prouvés

- **Halo coloré** : affichage testé et **rejeté explicitement**.
- **Effet de pulsation** : expérimenté, puis retiré de la direction souhaitée.
- **Agrandissement important du focus** : une augmentation **au-delà de 12 %** était demandée ; proposition **+16 %**, **sans preuve consolidée de build/installation final**.
- **Radius des icônes et du bandeau** : objectif de réduire les arrondis ; proposition **12 dp / 18 dp** demandait un **changement de code Java**, pas seulement du JSON. **Ne pas affirmer que ces valeurs existent dans le thème officiel.**
- **Réduction de taille des tuiles** : tentative de reconstruction affectée par des `.backup-*` dans les sources.
- **Dock à 30 % d'opacité et 720 dp de grille** : explorations, pas état final vérifié.

Le plus important n'est pas la valeur absolue mais la **réversibilité** : changer une variable à la fois, valider à l'écran, sauvegarder le JSON versionné et pouvoir revenir en arrière.

## Exemple public

[`examples/cleanyourtv/nature-calm-4-apps.example.json`](../../examples/cleanyourtv/nature-calm-4-apps.example.json) contient une base utilisable pour une personnalisation **neuve** ; **ce n'est pas** un export exact de la TV de référence. Les fonds de l'amont doivent être apportés séparément, et les apps doivent exister sur la TV.

Une fois le thème personnalisé à votre goût, **ne relancez pas le script d'installation ou de thème upstream sans sauvegarde** : certains réglages effectués depuis l'interface peuvent être remplacés.

