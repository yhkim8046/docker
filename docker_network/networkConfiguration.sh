#!/bin/bash

# 1. Create a user-defined network named 'my-net'
docker network create -d bridge my-net  # Create a bridge network named 'my-net'

# 2. Run a BusyBox container connected to 'my-net'
docker run --network=my-net -itd --name=container3 busybox  # Start a BusyBox container and connect it to 'my-net'

# 3. Run a Redis container on 'my-net'
docker run -d --name redis-container --network=my-net redis --bind 127.0.0.1  # Start a Redis container on 'my-net' with binding to 127.0.0.1

# 4. Execute 'redis-cli' inside the Redis container
docker run --rm -it --network container:redis-container redis redis-cli  # Run Redis CLI inside the Redis container

# 5. Run an Nginx container and expose it on 127.0.0.1:8080
docker run -p 127.0.0.1:8080:80 --network=my-net --name nginx-container nginx  # Start an Nginx container and expose it on localhost:8080

# 6. Run three BusyBox containers on 'my-net' for testing inter-container communication
docker run --network=my-net -itd --name container1 busybox  # Start container1 on 'my-net'
docker run --network=my-net -itd --name container2 busybox  # Start container2 on 'my-net'
docker run --network=my-net -itd --name container3 busybox  # Start container3 on 'my-net' (potential duplicate)

# 7. Inspect the list of Docker networks
docker network ls  # List all available Docker networks
