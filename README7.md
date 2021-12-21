## Create a swarm

```
docker swarm init
```

-> Current host will turn to manager node.

## Join a swarm

### 1. Generate the tokeen for join (in master node)

As a worker

```
docker swarm join-token worker
```

As a manager

```
docker swarm join-token manager
```

### 2. Join from the other nodes (in other nodes)

```
docker swarm join --token <token> <master-node-ip>:2377
```

## Add a yml file to stack

```
docker stack deploy --compose-file stack.yml <stack-name>
```

Check the stack:

```
docker stack ls
docker stack ps <stack-name>
```

## Add necessary port:

```
UDP/TCP
```

-   Open port 8080

## Update service replicas

```
docker service update --replicas 3 <service-name>
```
