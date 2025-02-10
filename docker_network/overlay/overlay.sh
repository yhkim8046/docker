docker network create -d overlay --attachable my-attachable-overlay

docker run -dit --network my-attachable-overlay --name my-container alpine sh
docker run -dit --network my-attachable-overlay --name my-container2 alpine sh

docker exec -it my-container sh
ping my-container2
