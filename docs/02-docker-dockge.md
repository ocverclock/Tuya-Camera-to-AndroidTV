# 02 — go2rtc dans Docker/Dockge

**Validé :** Debian VM, Docker Compose, Dockge, image `alexxit/go2rtc:1.9.15`.

## Installation type

Préparer une stack distincte `go2rtc`. Utiliser [`examples/compose.yaml`](../examples/compose.yaml) et [`examples/go2rtc.yaml.example`](../examples/go2rtc.yaml.example). Garder la configuration **réelle** hors Git.

Ports habituels : **1984/TCP** UI/API, **8554/TCP** RTSP, **8555/TCP+UDP** WebRTC. Ne pas les exposer à Internet ; vérifier que Frigate ou un autre serveur n'occupe pas déjà ces ports.

### Piège constaté : chemin hôte ≠ chemin interne Dockge

Dockge était lui-même un conteneur avec les stacks montées dans `/opt/stacks`, mais le démon Docker voyait un **autre chemin absolu sur l'hôte**. Un bind pointant vers `/opt/stacks/.../go2rtc.yaml` a donc créé un répertoire inattendu ; l'image go2rtc déclarait aussi un volume sur `/config`. On obtenait :

- `open /config/go2rtc.yaml: is a directory` ;
- puis `OCI runtime ... not a directory` en montant un fichier à la place d'un répertoire ;
- et la sauvegarde Web pouvait échouer si le bind était `:ro`.

**Correction testée :** utiliser le **chemin absolu du fichier sur l'hôte Docker** vers `/config/go2rtc.yaml` et autoriser l'écriture (`:rw`) si l'éditeur web doit sauvegarder. Vérifier les deux côtés avec :

~~~bash
docker inspect dockge --format '{{range .Mounts}}{{println .Source "->" .Destination}}{{end}}'
docker inspect go2rtc --format '{{range .Mounts}}{{println .Source "->" .Destination "RW:" .RW}}{{end}}'
~~~

Sur la machine test, un répertoire **vide** et erroné `go2rtc.yaml` dans le seul volume anonyme concerné a été retiré avec `rmdir`, après vérification. **Ne supprimez jamais aveuglément un volume** et ne lancez pas `docker system prune --volumes` sur un serveur partagé avec d'autres applications.

### Vérifications

~~~bash
docker compose config --quiet
docker ps -a --filter name=go2rtc
docker stats --no-stream go2rtc
~~~

Le lancement et le redémarrage se font dans **Dockge**, uniquement pour cette stack. Si les journaux n'affichent pas `DBG`, vérifier `log:` → `level: debug`, sans faute de frappe comme `debig` ; **le debug peut exposer le mot de passe Tuya**, donc revenir à `info` après le test.

