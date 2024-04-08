# Packet Protocol Cheat Sheet

## OSI 7 Layer Model:
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

## IP Addressing, DHCP, and DNS:
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

## Encryption:
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
