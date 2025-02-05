### Docker Network Testing Process

This document outlines the steps to create a custom Docker network, connect multiple containers, and test container-to-container communication.

---

## **1. Creating a User-Defined Network (`my-net`)**
We first create a bridge network named `my-net`, which will be used to connect our containers.

```bash
$ docker network create -d bridge my-net
```

---

## **2. Running Containers in `my-net`**
We now run multiple containers and connect them to `my-net`.

### **2.1 Run a BusyBox Container (`container3`)**
```bash
$ docker run --network=my-net -itd --name=container3 busybox
```

### **2.2 Run a Redis Container (`redis-container`)**
```bash
$ docker run -d --name redis-container --network=my-net redis --bind 127.0.0.1
```

### **2.3 Execute `redis-cli` Inside the Redis Container**
```bash
$ docker run --rm -it --network container:redis-container redis redis-cli
```

### **2.4 Run an Nginx Container Accessible on `127.0.0.1:8080`**
```bash
$ docker run -p 127.0.0.1:8080:80 --network=my-net --name nginx-container nginx
```

### **2.5 Run Three BusyBox Containers for Communication Testing**
```bash
$ docker run --network=my-net -itd --name container1 busybox
$ docker run --network=my-net -itd --name container2 busybox
$ docker run --network=my-net -itd --name container3 busybox
```

---

## **3. Inspecting the Network and Connected Containers**

### **3.1 Check the List of Available Docker Networks**
```bash
$ docker network ls
```
#### **Output**
```bash
NETWORK ID     NAME                          DRIVER    SCOPE
1d2390c97984   bridge                        bridge    local
45195fb35703   getting-started-app_default   bridge    local
901086cff2cd   host                          host      local
f3551da4101c   my-net                        bridge    local
63d025a6d0c8   none                          null      local
ee0abe73e943   todo-app                      bridge    local
```

### **3.2 Inspect `my-net` to See Connected Containers**
```bash
$ docker network inspect my-net
```
#### **Output**
```json
[
    {
        "Name": "my-net",
        "Id": "f3551da4101c3f43e547be74f85bf507858ee826e8ff6492f194dd9d2b5a6f58",
        "Created": "2025-02-05T02:47:51.198716801Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.20.0.0/16",
                    "Gateway": "172.20.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "1b9b0a979700f16f7ba936c14b2e6420eeed8b54215ad3750d5c7df2067882db": {
                "Name": "redis-container",
                "EndpointID": "06f4ab8e0876c2ed6d54b82bd77768d950922e25c62e1aee7c427c0929245915",
                "MacAddress": "02:42:ac:14:00:03",
                "IPv4Address": "172.20.0.3/16",
                "IPv6Address": ""
            },
            "9b9f3cc43f52e8720bb7a0646b00f432eefdcd317b266b5c73d897d3f8b84e61": {
                "Name": "container1",
                "EndpointID": "d4e43b47700d4ff80a16251ce47488555459cd5469968c84889a45a5c73b1d24",
                "MacAddress": "02:42:ac:14:00:04",
                "IPv4Address": "172.20.0.4/16",
                "IPv6Address": ""
            },
            "e8803d113d113582451767dcb8e59b5327d42c3758b52b94b2aeac1ae23b29d2": {
                "Name": "container3",
                "EndpointID": "b3e957b37dd757947dffcddc6f729544ef9964dc041eb4c9b00c57f98f06980c",
                "MacAddress": "02:42:ac:14:00:02",
                "IPv4Address": "172.20.0.2/16",
                "IPv6Address": ""
            },
            "f983bb13d1f25703db5f9b4939233e3384373fd3ab8f4c50f348882a208c5167": {
                "Name": "container2",
                "EndpointID": "cd22ab57fd998842d170015fc32f5839e89d7904541d9670255d5ae3c5b0af9e",
                "MacAddress": "02:42:ac:14:00:05",
                "IPv4Address": "172.20.0.5/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

---

## **4. Testing Container-to-Container Communication**

To verify if containers can communicate, we use `ping` to check connectivity between `container1` and `container2`.

```bash
$ docker exec -it container1 ping container2
```

#### **Expected Output**
```bash
PING container2 (172.20.0.5): 56 data bytes
64 bytes from 172.20.0.5: seq=0 ttl=64 time=0.522 ms
64 bytes from 172.20.0.5: seq=1 ttl=64 time=0.105 ms
64 bytes from 172.20.0.5: seq=2 ttl=64 time=0.297 ms
64 bytes from 172.20.0.5: seq=3 ttl=64 time=0.319 ms
64 bytes from 172.20.0.5: seq=4 ttl=64 time=0.108 ms
```

If the ping test succeeds, it confirms that `container1` and `container2` can communicate within the `my-net` network.

---

## **Conclusion**
- We successfully created a custom bridge network (`my-net`).
- We launched Redis, Nginx, and multiple BusyBox containers within `my-net`.
- We confirmed that all containers were correctly connected to the network using `docker network inspect`.
- A successful `ping` test validated that containers within `my-net` can communicate with each other.
