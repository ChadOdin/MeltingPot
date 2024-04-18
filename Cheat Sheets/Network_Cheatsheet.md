# Networking Cheat Sheet

A comprehensive cheatsheet with all my current knowledge on networking, IP Addressing, ports and packet protocols.

## Table of Contents:

- [Ethernet Cable Classifications and Speeds](#ethernet-cable-classifications-and-speeds)
- [IP Addressing, DHCP, and DNS](#ip-addressing-dhcp-and-dns)
- [Encryption](#encryption)
- [Subnetting Basics](#subnetting-basics)
- [Routing Protocols](#routing-protocols)
- [Common Ports and Protocols](#common-ports-and-protocols)
- [Firewalls](#firewalls)

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
   - Port 80 / 8080 (TCP)
   - Used for transferring web pages and related content on the World Wide Web.

 **HTTPS (Hypertext Transfer Protocol Secure):**
   - Port 443 (TCP)
   - Secure version of HTTP, encrypted using SSL/TLS.

 **DNS (Domain Name System):**
   - Port 53 (UDP/TCP)
   - Resolves domain names to IP addresses and vice versa.

 **FTP (File Transfer Protocol):**
   - Port 20 (FTP Data) and Port 21 (FTP Control) (TCP)
   - Used for transferring files between a client and server on a network.

 **SSH (Secure Shell):**
   - Port 22 (TCP)
   - Provides secure remote access to a device or server over a network.

 **SMTP (Simple Mail Transfer Protocol):**
   - Port 25 (TCP)
   - Used for sending email messages between servers.

 **POP3 (Post Office Protocol version 3):**
   - Port 110 (TCP)
   - Retrieves email from a remote server to a local client.

 **IMAP (Internet Message Access Protocol):**
   - Port 143 (TCP)
   - Allows an email client to access email on a remote server.

## Firewalls

- **Definition:** A security device or software that monitors and controls incoming and outgoing network traffic based on predetermined security rules.
- **Types of Firewalls:**
  - **Packet Filtering Firewalls:** Examines packets and filters them based on criteria such as source and destination IP addresses, ports, and protocols.
  - **Stateful Inspection Firewalls:** Tracks the state of active connections and makes decisions based on the context of the traffic.
  - **Proxy Firewalls:** Act as intermediaries between internal and external networks, inspecting and filtering traffic at the application layer.
- **Firewall Rules:** Configurations that dictate how a firewall should handle traffic. Rules can allow, block, or restrict specific types of traffic based on various criteria.
- **Intrusion Detection and Prevention Systems (IDPS):** Often integrated with firewalls, IDPS monitors network traffic for suspicious activities and can take action to block or alert on detected threats.