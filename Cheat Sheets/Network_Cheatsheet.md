# Networking Cheat Sheet

A comprehensive cheatsheet with all my current knowledge on networking, IP Addressing, ports and packet protocols.

## Table of Contents:

- [Ethernet Cable Classifications and Speeds](#ethernet-cable-classifications-and-speeds)
- [IP Addressing, DHCP, and DNS](#ip-addressing-dhcp-and-dns)
- [Encryption](#encryption)
- [Subnetting Basics](#subnetting-basics)
- [Routing Protocols](#routing-protocols)
- [Common Ports and Protocols](#common-ports-and-protocols)

## OSI 7 Layer Model

- **Layer 1 - Physical:** Involves the physical aspects of transmitting data, such as voltage levels, cable types, and physical network topologies.
- **Layer 2 - Data Link:** Divided into two sublayers: Logical Link Control (LLC) and Media Access Control (MAC).
- **Layer 3 - Network:** Concerned with logical addressing, routing, and packet forwarding to ensure data reaches its destination across multiple networks.
- **Layer 4 - Transport:** Responsible for end-to-end communication and data delivery.
- **Layer 5 - Session:** Establishes, manages, and terminates sessions between applications.
- **Layer 6 - Presentation:** Responsible for data translation, encryption, and compression.
- **Layer 7 - Application:** Interacts directly with end-users and provides network services to applications.

## Ethernet Cable Classifications and Speeds:

- **Category 5e (Cat5e):** Enhanced version of Cat5 cable, supports Gigabit Ethernet and is backward compatible with Cat5.
- **Category 6 (Cat6):** Provides higher performance than Cat5e, supporting 10 Gigabit Ethernet over shorter distances.
- **Category 6a (Cat6a):** Augmented version of Cat6, supports 10 Gigabit Ethernet over longer distances.
- **Category 7 (Cat7):** Offers even better performance and shielding than Cat6a, supporting 10 Gigabit Ethernet over longer distances.

## IP Addressing, DHCP, and DNS

- **IPv4 (Internet Protocol version 4):**
- **IPv6 (Internet Protocol version 6):**
- **DHCP (Dynamic Host Configuration Protocol):**
- **DNS (Domain Name System):**

## Encryption

- **SSL/TLS (Secure Sockets Layer/Transport Layer Security):**
- **IPSec (Internet Protocol Security):**
- **SSH (Secure Shell):**
- **PGP (Pretty Good Privacy):**

## Subnetting Basics:

### Max IP Availability:

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

 **OSPF (Open Shortest Path First):**
   - Link-state routing protocol.
   - Uses Dijkstra's algorithm to calculate the shortest path.
   - Commonly used in large networks.

 **BGP (Border Gateway Protocol):**
   - Path vector routing protocol.
   - Used between different autonomous systems (ASes) on the internet.
   - Emphasizes policy-based routing decisions.

 **EIGRP (Enhanced Interior Gateway Routing Protocol):**
   - Cisco proprietary routing protocol.
   - Hybrid distance vector and link-state protocol.
   - Supports variable-length subnet masks (VLSM) and rapid convergence.

## Common Ports and Protocols:

 **HTTP (Hypertext Transfer Protocol):**
   - Port 80 (TCP)