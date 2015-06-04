# docker-redis-geo

Launch Redis server

```bash
docker run -d -p 6379:6379 --name redis atamos/docker-redis-geo
```

Get Redis server ip
```bash
docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis
````

Launch redis client
```bash
docker run --rm -ti --name  redisclient atamos/docker-redis-geo redis-cli -h REDISIPSERVER
```
or with linked container
```bash
docker run --rm  -it --name client --link redis:db atamos/docker-redis-geo sh -c 'exec redis-cli -h "$DB_PORT_6379_TCP_ADDR" -p "$DB_PORT_6379_TCP_PORT"'
```

enter into container
```bash
docker run --rm -ti --name  redisclient atamos/docker-redis-geo /bin/bash
```

To see installed modules
```bash
docker run --rm -ti --name  redisclient atamos/docker-redis-geo redis-cli -h REDISIPSERVER
ip:6379> info modules
```

This container export **/data** as Volume
