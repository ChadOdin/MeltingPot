# Packet Protocol Cheat Sheet

## OSI 7 Layer Model
- **Layer 1 - Physical:** Involves the physical aspects of transmitting data, such as voltage levels, cable types, and physical network topologies.  
  - **Typical services:** Cable infrastructure, NICs.

- **Layer 2 - Data Link:** Divided into two sublayers: Logical Link Control (LLC) and Media Access Control (MAC).  
  - **Typical services:** Ethernet, MAC addresses.

- **Layer 3 - Network:** Concerned with logical addressing, routing, and packet forwarding to ensure data reaches its destination across multiple networks.  
  - **Typical services:** IP addressing, routing.

- **Layer 4 - Transport:** Responsible for end-to-end communication and data delivery. Protocols like TCP and UDP operate at this layer.  
  - **Typical services:** network traffic between hosts and end systems to ensure complete data transfers. Transport-layer protocols such as TCP, UDP, DCCP, and SCTP are used to control the volume of data, where it is sent, and at what rate.

- **Layer 5 - Session:** Establishes, manages, and terminates sessions between applications, ensuring data synchronization and dialogue control.  
  - **Typical services:** NetBIOS, RPC.

- **Layer 6 - Presentation:** Responsible for data translation, encryption, and compression to ensure compatibility between different systems.  
  - **Typical services:** SSL/TLS, ASCII.

- **Layer 7 - Application:** Interacts directly with end-users and provides network services to applications. Protocols like HTTP, FTP, and SMTP operate at this layer.  
  - **Typical services:** Web browsing (HTTP), email (SMTP), file transfer (FTP).

## Ethernet Cable Classifications and Speeds:
- **Category 5e (Cat5e):** Enhanced version of Cat5 cable, supports Gigabit Ethernet and is backward compatible with Cat5.  
  - **Typical services:** Ethernet networking, Gigabit Ethernet.
- **Category 6 (Cat6):** Provides higher performance than Cat5e, supporting 10 Gigabit Ethernet over shorter distances.  
  - **Typical services:** 10 Gigabit Ethernet.
- **Category 6a (Cat6a):** Augmented version of Cat6, supports 10 Gigabit Ethernet over longer distances with improved crosstalk performance.  
  - **Typical services:** 10 Gigabit Ethernet (longer distances).
- **Category 7 (Cat7):** Offers even better performance and shielding than Cat6a, supporting 10 Gigabit Ethernet over longer distances and frequencies up to 600 MHz.  
  - **Typical services:** 10 Gigabit Ethernet (shielded).

## IP Addressing, DHCP, and DNS
- **IPv4 (Internet Protocol version 4):** 
  - **Definition:** The fourth version of the Internet Protocol, using 32-bit addresses.
  - **Typical services:** Host addressing, packet routing.
- **IPv6 (Internet Protocol version 6):** 
  - **Definition:** The sixth version of the Internet Protocol, using 128-bit addresses.
  - **Typical services:** Address space expansion, improved security.
- **DHCP (Dynamic Host Configuration Protocol):**
  - **Definition:** Protocol used to dynamically assign IP addresses and network configuration parameters to devices on a network.
  - **Typical services:** IP address allocation, subnet configuration, DNS server assignment.
- **DNS (Domain Name System):**
  - **Definition:** Protocol used to translate domain names into IP addresses and vice versa.
  - **Typical services:** Domain name resolution, IP address management.

## Encryption
- **SSL/TLS (Secure Sockets Layer/Transport Layer Security):** 
  - **Definition:** Protocols used to secure communications over a computer network.
  - **Typical services:** Web browsing (HTTPS), email encryption.
- **IPSec (Internet Protocol Security):**
  - **Definition:** Suite of protocols used to ensure the secure exchange of packets at the IP layer.
  - **Typical services:** VPNs, secure data transmission over IP networks.
- **SSH (Secure Shell):**
  - **Definition:** Protocol used to securely connect to a remote computer or server.
  - **Typical services:** Remote administration, secure file transfer (SFTP).
- **PGP (Pretty Good Privacy):**
  - **Definition:** Encryption program that provides cryptographic privacy and authentication for data communication.
  - **Typical services:** Secure email communication, file encryption.

## Subnetting Basics:

- **Subnet Mask**: Determines network and host portions of an IP address.
- **CIDR Notation**: Shorthand for subnet masks (/x format).
- **IP Address Range**: Range of IP addresses within a subnet.
- **Max IP Availability**: Maximum available IP addresses for each subnet.

#### Max IP Availability:

- /1: 2,147,483,646 IPs
- /2: 1,073,741,822 IPs
- /3: 536,870,910 IPs
- /4: 268,435,454 IPs
- /5: 134,217,726 IPs
- /6: 67,108,862 IPs
- /7: 33,554,430 IPs
- /8: 16,777,214 IPs
- /9: 8,388,606 IPs
- /10: 4,194,302 IPs
- /11: 2,097,150 IPs
- /12: 1,048,574 IPs
- /13: 524,286 IPs
- /14: 262,142 IPs
- /15: 131,070 IPs
- /16: 65,534 IPs
- /17: 32,766 IPs
- /18: 16,382 IPs
- /19: 8,190 IPs
- /20: 4,094 IPs
- /21: 2,046 IPs
- /22: 1,022 IPs
- /23: 510 IPs
- /24: 254 IPs
- /25: 126 IPs
- /26: 62 IPs
- /27: 30 IPs
- /28: 14 IPs
- /29: 6 IPs
- /30: 2 IPs
- /31: 2 IPs
- /32: 1 IP

## Routing Protocols:

1. **OSPF (Open Shortest Path First)**:
   - Link-state routing protocol.
   - Uses Dijkstra's algorithm to calculate the shortest path.
   - Commonly used in large networks.
   
2. **BGP (Border Gateway Protocol)**:
   - Path vector routing protocol.
   - Used between different autonomous systems (ASes) on the internet.
   - Emphasizes policy-based routing decisions.

3. **EIGRP (Enhanced Interior Gateway Routing Protocol)**:
   - Cisco proprietary routing protocol.
   - Hybrid distance vector and link-state protocol.
   - Supports variable-length subnet masks (VLSM) and rapid convergence.

### Common Ports and Protocols:

1. **HTTP (Hypertext Transfer Protocol)**:
   - Port 80 (TCP)
   - Used for transferring web pages and related content on the World Wide Web.

2. **HTTPS (Hypertext Transfer Protocol Secure)**:
   - Port 443 (TCP)
   - Secure version of HTTP, encrypted using SSL/TLS.

3. **DNS (Domain Name System)**:
   - Port 53 (UDP/TCP)
   - Resolves domain names to IP addresses and vice versa.

4. **FTP (File Transfer Protocol)**:
   - Port 20 (FTP Data) and Port 21 (FTP Control) (TCP)
   - Used for transferring files between a client and server on a network.

5. **SSH (Secure Shell)**:
   - Port 22 (TCP)
   - Provides secure remote access to a device or server over a network.

6. **SMTP (Simple Mail Transfer Protocol)**:
   - Port 25 (TCP)
   - Used for sending email messages between servers.

7. **POP3 (Post Office Protocol version 3)**:
   - Port 110 (TCP)
   - Retrieves email from a remote server to a local client.

8. **IMAP (Internet Message Access Protocol)**:
   - Port 143 (TCP)
   - Allows an email client to access email on a remote server.