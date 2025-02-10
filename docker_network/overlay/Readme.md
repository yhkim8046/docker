## **Docker Swarm Overlay Network Setup & Verification**

### **1. Initialize Docker Swarm**
Before creating an overlay network, ensure that Docker Swarm is initialized.

```sh
docker swarm init
```
If Swarm is already active, you can check its status:
```sh
docker info | grep Swarm
```
The output should show `Swarm: active`.

---

### **2. Create an Overlay Network**
Run the following command to create an attachable overlay network:

```sh
docker network create -d overlay --attachable my-attachable-overlay
```
Verify that the network was created successfully:
```sh
docker network ls
```
You should see an entry like:
```
NETWORK ID     NAME                   DRIVER    SCOPE
tzne2i580e3e   my-attachable-overlay  overlay   swarm
```

---

### **3. Run a Container in the Overlay Network**
Start a container and attach it to the overlay network:
```sh
docker run -dit --network my-attachable-overlay --name my-container alpine sh
```
Verify that the container is running:
```sh
docker ps
```

---

### **4. Verify the Network Configuration**
#### **Option 1: Inspect the Network**
Check if the container is correctly connected to the overlay network:
```sh
docker network inspect my-attachable-overlay
```
Look for the `"Containers"` section in the output, which should include `my-container`.

#### **Option 2: Check Inside the Container**
Enter the running container:
```sh
docker exec -it my-container sh
```
List the network interfaces:
```sh
ip a
```
or
```sh
ifconfig
```
You should see an additional network interface (e.g., `eth1`) assigned an IP address.

#### **Option 3: Test Communication Between Containers**
Create a second container in the same network:
```sh
docker run -dit --network my-attachable-overlay --name my-container2 alpine sh
```
From `my-container`, try to ping `my-container2`:
```sh
docker exec -it my-container sh
ping my-container2
```
If the ping is successful, the overlay network is working correctly.

---

### **5. Check Swarm Nodes (Optional)**
Ensure that Swarm is managing the nodes correctly:
```sh
docker node ls
```

---

## **Conclusion**
By following these steps, you can set up and verify a Docker Swarm Overlay Network, ensuring that multiple containers across different hosts can communicate efficiently.
