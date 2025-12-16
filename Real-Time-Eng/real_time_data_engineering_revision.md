# Real-Time Data Engineering - Guide Complet de Révision

## PARTIE 1 : FONDATIONS DU TEMPS RÉEL

---

## 1. Motivation : Pourquoi le Temps Réel ?

### Un Monde Devenu Temps Réel

Les systèmes modernes produisent des événements en continu dans plusieurs domaines :

**Finance** : transactions carte bancaire, ordres de bourse, flux HFT.
**E-commerce** : clics, vues produit, abandons de panier.
**IoT industriel** : température, vibrations, pression, consommation.
**Réseaux sociaux** : posts, likes, commentaires, partages.
**Cloud / DevOps** : logs applicatifs, métriques CPU / RAM / latence.

### Message Fondamental

Le Real-Time Data Engineering permet d'**analyser et d'agir pendant que les événements se produisent**, et non seulement après coup.

**Idée clé** : Quand la valeur de la donnée diminue très vite avec le temps, le traitement batch n'est plus suffisant.

### Exemples Concrets de Besoins Temps Réel

**Détection de fraude**

- Identifier une transaction suspecte avant la validation
- Bloquer la carte immédiatement si nécessaire

**Recommandation en ligne**

- Proposer un produit pertinent pendant la navigation
- S'adapter en fonction des clics de l'utilisateur

**Monitoring d'infrastructure**

- Détecter un pic CPU ou une latence anormale
- Déclencher une alerte ou un scaling automatique

**Logistique / transport**

- Suivre les véhicules en direct
- Recalculer les itinéraires en fonction du trafic

### Analogie : Batch vs Streaming

**Batch = Médecin de contrôle**

- Bilan annuel, analyses faites après la prise de sang
- Le médecin observe des résultats déjà figés
- On prend des décisions avec du recul, pas dans l'urgence

**Streaming = Urgences / Réanimation**

- Monitoring continu : ECG, tension, saturation en oxygène
- Le médecin agit en fonction de ce qui se passe maintenant
- Les décisions sont immédiates, parfois à la milliseconde près

**Principe** : Le streaming correspond aux situations nécessitant surveillance permanente et réaction immédiate. **L'objectif n'est pas que tout soit temps réel, mais d'identifier où le temps réel apporte un gain décisif.**

---

## 2. Types de Données

### Données Classiques

- **Format** : tables, fichiers
- **Exemples** : fichiers CSV, tables SQL, export CRM
- **Vision** : "tables statiques"
- **Caractéristique** : ensemble fini, on sait quand la collecte est terminée

### Données Événementielles

- **Format** : flux chronologiques
- **Exemples** : clic, transaction, mesure capteur, log système
- **Vision** : "flux qui s'écoulent dans le temps"
- **Caractéristique** : le flux d'événements peut être théoriquement infini

### Changement de Paradigme

On ne pense plus seulement en "tables statiques" mais en **flux qui s'écoulent dans le temps**.

### Structure d'un Événement

Un événement est une petite structure de données qui décrit :

- **quoi** : type d'événement (clic, transaction, mesure, log...)
- **qui** : identifiant logique (user_id, card_id, sensor_id...)
- **quand** : timestamp (moment où il s'est produit)
- **détails** : payload associé (montant, URL, mesure, coordonnées, etc.)

**Exemples d'événements** :

```
page_view(user=42, url="/home", time=10:01:23)
transaction(card=XXXX, amount=120.50, time=10:01:25)
sensor(id=7, temp=86.2, time=10:01:30)
```

### Exemple : Navigation d'un Utilisateur

Séquence typique d'un parcours e-commerce :

```
page_view("/home")
search("ordinateur")
page_view("/product/42")
click("add_to_cart", product=42)
checkout(order_id=1234, amount=1299.99)
```

Ces événements forment **un flux chronologique pour un utilisateur**, et **un flux global quand on agrège tous les utilisateurs**.

---

## 3. Batch Processing vs Stream Processing

### Batch Processing

**Définition** : Traiter un ensemble fini de données en exécutant un calcul global (ou une série de calculs) sur ce jeu de données, en général selon une planification (une fois par jour, par heure, etc.).

**Pipeline classique (ETL)** :

```
Extraction → Transformation → Chargement
Sources/fichiers → Nettoyage, agrégations → Entrepôt de données
```

**Exemples d'utilisation** :

- Rapport hebdomadaire de ventes par magasin
- Calcul du P&L mensuel d'un portefeuille
- Entraînement d'un modèle de Machine Learning sur les données de l'année passée

**Forces du batch** :

- On dispose de toutes les données avant de lancer le calcul
- Possibilité de trier, filtrer, nettoyer
- Possibilité de relire les données plusieurs fois
- Utilisation d'algorithmes complexes
- Très adapté à l'analyse historique, aux rapports réglementaires, à l'entraînement de modèles sur de grands volumes

**Intuition** : Le batch = **prendre du recul sur un historique figé**.

**Limites profondes** :

- **Latence élevée** : si le batch tourne une fois par jour, la donnée peut avoir 24h de retard → impossible de réagir à une fraude en quelques secondes
- **Pas de visibilité continue** : on voit "ce qui s'est passé", pas "ce qui se passe maintenant"
- **Modèle de données fini** : le traitement suppose un ensemble de données clos, peu adapté à des flux qui ne s'arrêtent jamais

### Stream Processing

**Définition** : Traiter un flux potentiellement infini d'événements au fur et à mesure de leur arrivée, avec des contraintes de latence faible et la nécessité de maintenir un état interne (state) pour agréger l'information.

**Point crucial** : Le streaming n'est pas un batch "plus rapide" — c'est un **modèle de calcul fondamentalement différent**.

**Exemples d'outils** :

- Apache Flink (streaming-first)
- Spark Structured Streaming (micro-batch)
- Kafka Streams (librairie embarquée côté microservice)

**Intuition** :

- Batch : on voit le problème **après coup** (trop tard)
- Streaming : on intervient **pendant la montée en température**

### Comparaison Structurée

| Aspect               | Batch                  | Streaming                     |
| -------------------- | ---------------------- | ----------------------------- |
| Données              | Ensemble fini          | Flux infini                   |
| Moment du traitement | Après collecte         | Pendant la collecte           |
| Latence              | Minutes, heures, jours | Millisecondes, secondes       |
| Mémoire              | Historique complet     | État résumé (fenêtres, state) |
| Objectif             | Analyses historiques   | Réaction temps réel           |
| Gestion du temps     | Temps de traitement    | Event Time                    |

### Exemple d'Application : Alerte Température Machine

Un capteur envoie une mesure toutes les 2 secondes.
On surveille un seuil critique : 90℃.
On veut être alerté si la température dépasse 90℃ ou augmente trop rapidement (+10℃ en 30s).

**Batch** : on voit le problème après coup (trop tard).
**Streaming** : on intervient pendant la montée en température.

---

## 4. Flux d'Événements : Structure, Désordre et Latence

### Désordre Naturel des Événements

**Point critique** : Le timestamp d'événement est souvent différent du moment où le système reçoit l'événement.

**Visualisation** :

```
Temps réel (Event Time)          A B C D
Temps d'arrivée (Processing Time) D A C B
```

Les événements A, B, C, D ne sont pas reçus dans l'ordre où ils se sont réellement produits.

### Causes Fréquentes du Désordre

- **Réseaux mobiles** : latences variables, pertes, reconnections
- **Buffers** : navigateurs, OS, proxies peuvent retarder certains paquets
- **Retries automatiques** : une requête échoue, est renvoyée plus tard
- **Distance géographique** : data centers éloignés, routes réseau différentes
- **Charge du système** : files d'attente internes, micro-pannes, backpressure

### Conséquence

**Toute statistique basée uniquement sur l'ordre d'arrivée ignore la réalité temporelle du métier.**

---

## 5. Temporalité : Event Time, Ingestion Time, Processing Time

### Les Trois Notions de Temps

**Event Time (Temps de l'événement)**

- Moment où l'événement s'est réellement produit du point de vue métier
- Exemple : heure exacte du paiement par l'utilisateur
- **C'est le temps pertinent pour les statistiques métier** (taux de clics par minute, volumétrie par heure, taux de conversion)

**Ingestion Time (Temps d'ingestion)**

- Moment où l'événement entre dans la plateforme (Kafka, par exemple)
- Dépend du réseau, des buffers, etc.

**Processing Time (Temps de traitement)**

- Moment où le job de traitement l'exécute effectivement
- Dépend de la charge, des ressources, de la file interne

### Schéma Temporel Simplifié

```
Event Time → Ingestion Time → Processing Time
(événement) → (Kafka)        → (Flink/Spark)
   ↓              ↓                  ↓
Entre l'événement et sa prise en compte par le système,
plusieurs délais techniques s'ajoutent.
```

### Latence d'un Système Temps Réel

**Définition** : Le délai entre :

1. Le moment où l'événement se produit (Event Time)
2. Le moment où le système réagit (alerte, recommandation, écriture en base)

**Exemples de latences acceptables** :

- Détection de fraude : quelques millisecondes / secondes
- Monitoring technique : quelques secondes
- Reporting interne : minutes acceptables

**Trade-off important** : Plus on veut une latence faible, plus :

- L'architecture doit être optimisée
- On doit accepter des compromis sur la complexité des traitements

---

## PARTIE 2 : ARCHITECTURE D'UN PIPELINE TEMPS RÉEL

---

## 6. Architecture d'un Pipeline Temps Réel Moderne

### Vue d'Ensemble

```
Sources → Ingestion (Kafka) → Traitement (Flink/Spark) → Stockage rapide → Dashboards/API/Alertes
```

### Sources Possibles

**Exemples de sources** :

- Applications web / mobiles (flux de clics, logs HTTP)
- Systèmes de paiement (transactions)
- Capteurs IoT (mesures physiques)
- Systèmes internes (événements métier, logs)

**Rôle de la couche d'ingestion** :

- Absorber de grands volumes d'événements
- Les bufferiser et les rendre disponibles aux applications consommatrices
- Offrir des garanties de durabilité et d'ordre (partiel)

### Traitement en Temps Réel

**Rôle de la couche de traitement** :

- Filtrer les événements inutiles
- Enrichir (join avec d'autres flux ou données de référence)
- Agréger (comptages, moyennes, fenêtres temporelles)
- Détecter des patterns (fraude, anomalies, comportements)

### Stockage et Exposition des Résultats

**Stockages typiques** :

- **Redis** : cache rapide pour scores, alertes, compteurs
- **Cassandra** : historique temps réel clé-valeur
- **ClickHouse** : requêtes analytiques rapides
- **Elasticsearch** : recherche plein texte, logs

**Consommateurs** :

- Dashboards (Grafana, Kibana)
- Applications front (API REST / GraphQL)
- Systèmes d'alerting (emails, SMS, Slack, etc.)

---

## PARTIE 3 : APACHE KAFKA - INGESTION DISTRIBUÉE

---

## 7. Pourquoi Kafka est Devenu Central ?

### Propriétés Clés

- **Débit très élevé** : millions de messages par seconde
- **Stockage persistant** : messages stockés sur disque
- **Possibilité de rejouer** : relire l'historique (replay)
- **Tolérance aux pannes** : réplication, cluster de brokers
- **Partitionnement** : scalabilité horizontale

### Idée Clé

Kafka n'est pas une simple file de messages : c'est un **log distribué immuable et partitionné**.

---

## 8. Architecture Interne de Kafka

### Vue Globale du Cluster

```
Broker 1        Broker 2        Broker 3
    │               │               │
    └───────────────┼───────────────┘
                    │
              Cluster Kafka
```

Un cluster Kafka = plusieurs brokers.
Les topics sont répartis en partitions sur les brokers.
Chaque partition a un leader et éventuellement des réplicas.

### Topics, Partitions et Réplicas

```
Topic "paiements"
Broker 1            Broker 2
P0 (leader)         P0 (réplica)
P1 (réplica)        P1 (leader)
```

Pour chaque partition :

- **Un leader** gère les lectures / écritures
- **Un ou plusieurs réplicas** assurent la redondance

### ISR — In-Sync Replicas

**Définition** : Les réplicas à jour (synchronisés avec le leader) forment l'ensemble ISR. En cas de panne du leader, Kafka choisit le nouveau leader dans l'ISR.

**Exemple** :
Partition P0 :

- Leader sur Broker 1
- Réplicas sur Brokers 2 et 3
- ISR = {Broker 1, Broker 2} (Broker 3 est en retard)

Si Broker 1 tombe :

- Kafka promeut Broker 2 (dans l'ISR) comme leader
- Broker 3 ne peut pas devenir leader tant qu'il n'est pas à jour

**Attention** : Un réplica hors ISR ne doit jamais devenir leader, sinon les derniers événements confirmés peuvent être perdus.

### Leader, Followers et Tolérance aux Pannes

- Les **producers** écrivent sur le **leader** d'une partition
- Les **followers** répliquent les données du leader
- En cas de panne du leader : un follower in-sync devient le nouveau leader
- Les applications bénéficient d'une **transparence** (rebalancing côté clients)

**Scénario** :
Partition P0 : leader sur Broker 1, réplicas sur Broker 2 et 3.
Broker 1 tombe :

- Kafka élit un nouveau leader (par ex. Broker 2)
- Les producers / consumers redirigent automatiquement leurs flux

### Segments de Log et Index

Chaque partition est stockée comme une suite de segments de fichiers.
Un segment contient :

- Des messages (log)
- Des index pour retrouver rapidement un offset

Quand un segment est trop gros (taille ou temps) :

- Kafka roule vers un nouveau segment (rollover)

**Importance** : Permet d'effacer ou de compacter les vieux segments sans toucher aux récents.

### Politiques de Rétention et Log-Compaction

**Rétention classique**

- **Time-based** : garder les messages pendant X jours
- **Size-based** : garder jusqu'à Y Go par partition

**Log-compaction**

- Par clé, Kafka ne garde que la dernière valeur (et éventuellement quelques anciennes)
- Adapté pour des topics de "table de référence"
- Exemple : topic user-profile avec la dernière version du profil utilisateur

### Découplage Spatio-Temporel

- Les **producers** n'ont pas besoin de connaître les **consumers**
- Les **consumers** n'ont pas besoin de connaître les **producers**
- Kafka agit comme une zone tampon durable

**Conséquences pratiques** :

- On peut ajouter un nouveau consumer (ex : "modèle de fraude v2") sans changer les producers
- On peut rejouer l'historique pour tester un nouveau modèle

**Idée clé** : Kafka permet de "geler" les flux d'événements dans un log, puis de les relire à volonté.

---

## 9. Topics, Partitions et Partitionnement

### Structure

```
Topic "clicks"
├── Partition 0 [offset 0, 1, 2, ...]
├── Partition 1 [offset 0, 1, 2, ...]
└── Partition 2 [offset 0, 1, 2, ...]
```

### Ordre dans Kafka

**L'ordre est garanti à l'intérieur d'une partition, mais pas entre partitions différentes.**

### Partitionnement : Pourquoi, Comment ?

Kafka distribue les messages d'un topic sur plusieurs partitions.

**Objectifs** :

- Scalabilité (plus de débit)
- Parallélisme de traitement
- Ordre garanti par clé

**Stratégies de partitionnement** :

- **Hash de clé** : partition = hash(key) mod N
- **Round-robin** : sans clé, on répartit de manière uniforme
- **Custom partitioner** : logique métier spécifique

**Point crucial** : L'ordre est garanti uniquement à l'intérieur d'une même partition. Si une même clé est envoyée sur plusieurs partitions, on perd cet ordre.

### Offsets : Positions dans le Log

Chaque message dans une partition reçoit un offset croissant : offset = 0, 1, 2, 3, ...

**Propriétés importantes** :

- Lecture séquentielle très efficace
- Reprise exacte après une panne (en mémorisant l'offset)
- Possibilité de relire l'historique (replay)

**Reprise après panne** : Si un consumer tombe après avoir traité l'offset 123, il peut redémarrer et continuer à partir de 124.

---

## 10. Producers Avancés

### Rôle et Responsabilités

- Prendre un événement métier (structuré) et le sérialiser (JSON, Avro, Protobuf...)
- Choisir : le topic, la clé (pour le partitionnement), éventuellement la partition
- Configurer le niveau de fiabilité : acks, retries, linger.ms, batch.size, compression.type, etc.

**Vision** : Un producer est un **adaptateur entre le monde applicatif et le log distribué Kafka**.

### Paramètre acks : Fiabilité vs Latence

**acks=0**

- Le producer n'attend aucune confirmation
- Très rapide, mais on ne sait pas si le message est arrivé
- Risque : perte possible

**acks=1**

- Confirmation du leader uniquement
- Bon compromis débit / fiabilité

**acks=all**

- Attente de la réplication sur tous les ISR
- Plus fiable, mais plus de latence

### Batches, Linger et Compression

**Batching** :

- **batch.size** : taille max d'un batch envoyé d'un coup
- **linger.ms** : temps d'attente pour remplir le batch
- Plus les batches sont gros, plus le débit est élevé (mais latence plus grande)

**Compression** :

- **compression.type** : none, gzip, snappy, lz4, zstd
- Réduit le volume réseau et disque, mais consomme de la CPU

**Règle d'or** : On ajuste ces paramètres en fonction de la tolérance à la latence, du débit souhaité et de la charge CPU acceptable.

### Idempotence et Transactions Kafka

**Producer idempotent** :

- Permet d'éviter les doublons en cas de retries
- Kafka assigne un producer ID (PID) et suit les séquences de messages

**Transactions Kafka** :

- Permettent des écritures atomiques sur plusieurs partitions / topics
- Utiles pour les scénarios exactly-once avec un moteur de streaming
- Utiles pour les opérations "lire puis écrire" (read-process-write)

**Complexité** : Les transactions améliorent la sémantique (exactly-once), mais ajoutent de la complexité de configuration et de monitoring.

**Exemple** :
Pipeline :

- Lecture d'un événement de paiement
- Écriture dans un topic audit et un topic paiements-traités

Sans transaction : un seul des deux topics peut être écrit → incohérence.
Avec transaction : soit les deux sont écrits, soit aucun.

---

## 11. Consumers Avancés

### Rôle d'un Consumer

- Lire les messages séquentiellement depuis une ou plusieurs partitions
- Les désérialiser et appliquer une logique métier
- Gérer les offsets : que s'est-il passé si je tombe en panne ?

### Gestion des Offsets : Auto-commit vs Manuel

**Auto-commit** :

- Kafka commite périodiquement l'offset pour vous
- Simple, mais moins de contrôle
- Risque : on peut perdre des messages ou en rejouer selon le timing

**Commit manuel** :

- L'application décide quand commiter
- Après traitement réussi, éventuellement par batch
- Permet d'implémenter un at-least-once robuste

**Décision clé** : À quel moment committe-t-on l'offset ?

- Avant traitement ⇒ risque de perte en cas de crash
- Après traitement ⇒ risque de rejouer deux fois

**Bonne pratique** : Toujours réfléchir : "Si mon consumer tombe maintenant, que va-t-il se passer ?"

### Consumer Groups et Rebalancing

**Principe** :

- Un consumer group = plusieurs instances qui consomment un même topic
- Kafka répartit les partitions entre les consumers du groupe
- Si un consumer rejoint ou quitte le groupe : Kafka déclenche un rebalancing

```
Partition 0 ─┐
Partition 1 ─┼─→ Consumer 1
Partition 2 ─┤
              │
Partition 3 ─┼─→ Consumer 2
Partition 4 ─┤
Partition 5 ─┘
```

**Impact du rebalancing** :

- Pendant un rebalancing : certains consumers arrêtent temporairement de consommer
- La latence peut augmenter
- Le lag peut augmenter puis redescendre

**Attention** : Un rebalancing trop fréquent (consumers instables, timeouts trop courts) peut rendre le pipeline très instable en latence.

### Isolation Level : read_committed vs read_uncommitted

**read_uncommitted** :

- Le consumer voit tous les messages, même ceux issus de transactions non commitées
- Potentiellement plus rapide, mais risque de lire des données rollbackées

**read_committed** :

- Le consumer ne voit que les messages de transactions commitées
- Cohérent avec les scénarios exactly-once

---

## 12. Garanties de Livraison

### At-most-once : Au Plus Une Fois

**Stratégie** : On committe l'offset **avant** de traiter le message.

**Conséquence** : Si l'application tombe après le commit, le message est perdu.

**Utilisation possible** :

- Logs non critiques
- Métriques approximatives, où une petite perte est acceptable

**Risque** : Pas acceptable pour transactions financières, événements réglementaires, comptage de type "facturation".

### At-least-once : Au Moins Une Fois

**Stratégie** : On committe l'offset **après** le traitement.

**Conséquence** : Si l'application tombe après le traitement mais avant le commit, le message sera retraité à la reprise.

**Résultat** :

- Pas de perte de message
- Mais possible duplication du traitement

**Approche standard** : On combine souvent :

- At-least-once + logique idempotente côté traitement

### Exactly-once : Exactement Une Fois

**Objectif** : Ni perte, ni duplication du point de vue du résultat final.

**En pratique** : Combinaison de :

- Transactions Kafka
- State managé par le moteur de streaming (ex : Flink)
- Sink transactionnel ou idempotent

**Important** : "Exactly-once" signifie "exactement une fois au niveau du résultat", pas forcément "exactement une fois au niveau des appels internes".

**Exemple** :
Un paiement est traité deux fois à cause d'un crash/restart :

- Avec une logique idempotente côté base de données (clé unique), la 2e écriture ne change pas le résultat
- Côté utilisateur, la transaction n'apparaît qu'une fois

**Exactly-once dépend** :

- Du producer (transactions)
- Du moteur de streaming (gestion de state)
- Du sink (idempotent / transactionnel)
- Ce n'est jamais "magique"

### Où se Produisent Pertes et Doublons ?

**Entre producer et broker** :

- Pertes possibles si acks=0 ou configuration réseau fragile
- Doublons possibles si retries sans idempotence

**Entre broker et consumer** :

- Pertes possibles si on commite avant traitement (at-most-once)
- Doublons possibles si on commite après traitement (at-least-once)

**Entre consumer et sink** :

- Dépend de la sémantique du sink (DB, cache, etc.)

**Question à se poser** : Pour chaque "maillon" de la chaîne, quelle sémantique de livraison est réellement obtenue ?

---

## 13. Monitoring et Performance

### Kafka Lag : Définition et Interprétation

**Définition** :
Le lag d'un consumer group sur une partition = (dernier offset produit) - (dernier offset commité).

**Interprétation** :

- **Lag proche de 0** : consumer "à l'heure"
- **Lag qui augmente** : consumer en retard, risque de latence importante

**Pratique** :

- Si le lag explose : débit des producers > capacité des consumers
- Actions possibles :
  - Augmenter le parallélisme (plus de partitions / consumers)
  - Optimiser le code du consumer
  - Réduire la complexité des traitements

**Attention** : Un lag qui augmente en continu signifie :

- Soit le débit producer a augmenté
- Soit le consumer est devenu plus lent (code, I/O, rebalancing, etc.)

### Débit (Throughput) et Latence End-to-End

**Throughput** :

- Mesure : messages/s, octets/s
- Mesuré côté producers, brokers et consumers

**Latence end-to-end** :

- Temps entre Event Time et arrivée dans le sink final
- Dépend de Kafka ET du moteur de streaming

**Compromis à gérer** :

- Plus de sécurité (acks, transactions) ⇒ plus de latence
- Plus de débit ⇒ risque de lag et parfois de perte de messages mal configurés

### Outils de Monitoring

**Kafka UI / outils graphiques** :

- Visualiser topics, partitions, lags

**JMX + Grafana / Prometheus** :

- Métriques détaillées : débit, latence, taille des files, erreurs

**CLI Kafka / kcat** :

- Inspection rapide d'un topic, d'une partition
- Consommation ponctuelle pour debug

**Message** : Un pipeline temps réel sans monitoring est un pipeline qui finira par échouer sans que vous le voyiez venir.

---

## SYNTHÈSE GÉNÉRALE

### Points Clés à Retenir

✓ **Batch vs Streaming** : deux paradigmes fondamentalement différents, chacun pour des cas d'usage spécifiques

✓ **Event Time est crucial** : utiliser l'heure réelle des événements, pas l'ordre d'arrivée

✓ **Latence = délai entre événement réel et réaction du système**

✓ **Kafka = fondation** : log distribué partitionné, découplage producteur-consommateur

✓ **Trade-offs constants** : latence basse = architecture complexe et compromis acceptés

✓ **Cas d'usage temps réel** : fraude, recommandations, monitoring — pas tout doit être temps réel

✓ **Garanties de livraison** : at-most-once (perte), at-least-once (duplication), exactly-once (idempotence)

✓ **Monitoring essentiel** : lag, throughput, latence — les indicateurs de santé du pipeline

### Fil Conducteur

On part du **besoin métier** ("pourquoi ?"), puis on construit progressivement les **outils techniques** ("comment ?").

---

## OBJECTIFS PÉDAGOGIQUES ATTEINTS

À la fin de cette révision, vous êtes capable de :

1. Expliquer pourquoi le temps réel est devenu crucial dans de nombreux domaines
2. Distinguer clairement batch et streaming, au-delà de l'idée "plus rapide"
3. Décrire ce qu'est un événement, un flux et la notion de latence
4. Comprendre la différence entre Event Time, Ingestion Time et Processing Time
5. Dessiner l'architecture logique d'un pipeline temps réel moderne
6. Présenter les concepts essentiels de Kafka : topics, partitions, offsets, consumer groups
7. Configurer un producer fiable (acks, batch, compression)
8. Configurer un consumer robuste (gestion des offsets, rebalancing)
9. Analyser les garanties de livraison et identifier où se produisent pertes / doublons
10. Interpréter le Kafka lag, le débit et la latence pour diagnostiquer un pipeline
