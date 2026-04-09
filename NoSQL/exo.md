## Gestion des pilotes

```redis
HSET pilote:1 nom "Max Verstappen" pays "Belgique" ecurie "Oracle Red Bull Racing"
HSET pilote:44 nom "Lewis Hamilton" pays "Grande Bretagne" ecurie "Mercedes-AMG PETRONAS Formula One Team"
HSET pilote:16 nom "Charles Leclerc" pays "Monaco" ecurie "Scuderia Ferrari"
HSET pilote:4 nom "Lando Norris" pays "Grande Bretagne" ecurie "McLaren Formula 1 Team"
HSET pilote:14 nom "Fernando Alonso" pays "Espagne" ecurie "Aston Martin Aramco Formula One Team"
HSET pilote:10 nom "Pierre Gasly" pays "France" ecurie "BWT Alpine F1 Team"
```

```redis
HSET pilote:1 pays "Pays Bas"
```

```redis
HGETALL pilote:44
```

```redis
HGET pilote:14 nom
```

```redis
DEL pilote:10
```

```redis
HSET pilotes:noms "Max Verstappen" 1 "Lewis Hamilton" 44 "Charles Leclerc" 16 "Lando Norris" 4 "Fernando Alonso" 14
```

## Gestion des courses terminees

```redis
SADD courses:terminees "Bahrein" "Arabie Saoudite"
```

```redis
SADD courses:terminees "Venezuela"
```

```redis
SADD courses:terminees "Australie"
```

```redis
SREM courses:terminees "Venezuela"
```

```redis
SMEMBERS courses:terminees
```

## Gestion des resultats

```redis
ZADD gp:bahrein 1 "Max Verstappen" 7 "Lewis Hamilton" 4 "Charles Leclerc" 6 "Lando Norris" 9 "Fernando Alonso"
ZADD gp:arabie_saoudite 1 "Max Verstappen" 9 "Lewis Hamilton" 3 "Charles Leclerc" 8 "Lando Norris" 5 "Fernando Alonso"
ZADD gp:australie 2 "Charles Leclerc" 3 "Lando Norris" 8 "Fernando Alonso"
```

```redis
ZRANGE gp:arabie_saoudite 0 -1 WITHSCORES
```

```redis
ZRANGE gp:australie 0 2 WITHSCORES
```

```redis
ZSCORE gp:bahrein "Lando Norris"
```
