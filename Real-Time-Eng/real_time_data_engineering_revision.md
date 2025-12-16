# Real-Time Data Engineering - Guide de Révision

## 1. Les Fondamentaux

### Pourquoi le temps réel ?
Le Real-Time Data Engineering permet d'**analyser et d'agir pendant que les événements se produisent**, et non après coup. Quand la valeur de la donnée diminue très vite avec le temps, le traitement batch ne suffit plus.

**Concept clé** : Le streaming correspond aux situations nécessitant surveillance permanente et réaction immédiate. L'objectif n'est pas que tout soit temps réel, mais d'**identifier où le temps réel apporte un gain décisif** (fraude, recommandations en ligne, monitoring).

---

## 2. Types de Données

### Données Classiques
- Format : tables, fichiers
- Exemples : fichiers CSV, tables SQL, export CRM
- Vision : "tables statiques"

### Données Événementielles
- Format : flux chronologiques
- Exemples : clic, transaction, mesure capteur, log système
- Vision : "flux qui s'écoulent dans le temps"

**Structure d'un événement** : Une petite structure de données décrivant `quoi`, `qui`, `quand` et `détails`

```
page_view(user=42, url="/home", time=10:01:23)
```

---

## 3. Deux Paradigmes de Traitement

### Batch Processing
**Principe** : Traiter un ensemble fini de données en exécutant un calcul global selon une planification (une fois par jour, par heure, etc.)

**Pipeline classique (ETL)** :
```
Extraction → Transformation → Chargement
```

**Caractéristiques** :
- Données : ensemble fini
- Moment : après collecte
- Latence : minutes, heures, jours
- Mémoire : historique complet
- Objectif : analyses historiques

**Limites** : On voit le problème après coup (trop tard)

### Stream Processing
**Principe** : Traiter un flux potentiellement infini d'événements au fur et à mesure de leur arrivée, avec des contraintes de latence faible.

**Caractéristiques** :
- Données : flux infini
- Moment : pendant la collecte
- Latence : millisecondes, secondes
- Mémoire : état résumé (fenêtres, state)
- Objectif : réaction temps réel

**Point crucial** : Le streaming n'est pas un batch "plus rapide" — c'est un **modèle de calcul fondamentalement différent**.

**Avantage** : On intervient pendant la montée en température

### Comparaison Rapide

| Aspect | Batch | Streaming |
|--------|-------|-----------|
| Données | Ensemble fini | Flux infini |
| Moment du traitement | Après collecte | Pendant la collecte |
| Latence | Minutes, heures, jours | Millisecondes, secondes |
| Mémoire | Historique complet | État résumé (fenêtres, state) |
| Objectif | Analyses historiques | Réaction temps réel |
| Gestion du temps | Temps de traitement | Event Time |

---

## 4. La Gestion du Temps : Le Point Critique

### Le Problème
Les événements n'arrivent pas toujours dans l'ordre où ils se sont produits, et le timestamp d'événement est souvent différent du moment où le système le reçoit.

**Danger** : Toute statistique basée uniquement sur l'ordre d'arrivée ignore la réalité temporelle du métier.

### Trois Concepts de Temps

**Event Time (Temps de l'événement)**
- Moment où l'événement s'est réellement produit du point de vue métier
- Exemple : heure exacte du paiement par l'utilisateur
- **C'est le temps pertinent pour les statistiques métier** (taux de clics par minute, volumétrie par heure)

**Ingestion Time (Temps d'ingestion)**
- Moment où l'événement entre dans la plateforme (Kafka, par exemple)
- Dépend du réseau, des buffers, etc.

**Processing Time (Temps de traitement)**
- Moment où le job de traitement l'exécute effectivement
- Dépend de la charge, des ressources, de la file interne

### Latence d'un Système Temps Réel
La latence est le délai entre :
1. Le moment où l'événement se produit (Event Time)
2. Le moment où le système réagit (alerte, recommandation, écriture en base)

**Trade-off important** : Plus on veut une latence faible, plus l'architecture doit être optimisée et plus on doit accepter des compromis sur la complexité des traitements.

---

## 5. Architecture Temps Réel

### Pipeline Standard

```
Sources → Ingestion (Kafka) → Traitement (Flink/Spark) → Stockage rapide → Dashboards/API/Alertes
```

### Kafka : Le Cœur de l'Ingestion

Kafka n'est pas une simple file de messages : c'est un **log distribué immuable et partitionné**.

**Caractéristiques clés** :
- L'ordre est garanti à l'intérieur d'une partition, mais pas entre partitions différentes
- Producers et consumers sont découplés dans le temps : un consumer peut arriver plus tard et relire l'historique
- **Consumer group** : ensemble d'instances qui coopèrent pour lire un même topic
- Kafka garantit qu'une partition donnée est lue par au plus un consumer dans un groupe
- On peut augmenter le nombre de consumers pour augmenter la parallélisation

---

## 6. Enjeux Avancés

### Exactly-Once Processing
Le traitement de niveau exactly-once est complexe à mettre en œuvre, mais essentiel pour certains cas métier (comptabilité, paiements).

Sans this guarantee, risque de doublons ou de pertes de données critiques.

---

## 7. Résumé des Points Clés à Retenir

✓ **Batch vs Streaming** : deux paradigmes fondamentalement différents, chacun pour des cas d'usage spécifiques

✓ **Event Time est crucial** : utiliser l'heure réelle des événements, pas l'ordre d'arrivée

✓ **Latence = délai entre événement réel et réaction du système**

✓ **Kafka = fondation** : log distribué partitionné, découplage producteur-consommateur

✓ **Trade-offs** : latence basse = architecture complexe et compromis acceptés

✓ **Cas d'usage temps réel** : fraude, recommandations, monitoring — pas tout doit être temps réel