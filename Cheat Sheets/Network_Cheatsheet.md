# Networking Cheat Sheet
A comprehensive cheatsheet with all my current knowledge on networking, IP Addressing, ports and packet protocols as well as general knowledge i've picked up.
## Table of Contents:

### Physical
- [Cable Classifications and Speeds](#cable-classifications-and-speeds)
- [Physical Networking](#physical-networking)
  - [Switches](#switches)
  - [Access Points](#access-points)
  - [Exchanges](#exchanges)

### Core Networking
- [Routing Protocols](#routing-protocols)
- [Network Address Translation](#network-address-translation-nat)
- [IP Addressing, DHCP, and DNS](#ip-addressing-dhcp-and-dns)
  - [Common Ports and Protocols](#common-ports-and-protocols)
  - [Subnetting Basics](#subnetting-basics)
- [Wireless Networking](#wireless-networking)
  - [SMB Network Shares](#smb-network-shares)
- [Network Monitoring and Management](#network-monitoring-and-management)

### General Networking
- [Software-Defined Networking](#software-defined-networking-sdn)
- [Software Defined WAN](#software-defined-wan-sd-wan)
- [Container Networking](#container-networking)
- [Websockets](#websockets)
- [Encryption](#encryption)
- [Firewalls](#firewalls)

### VPN Networking
- [Load Balancing](#load-balancing)
- [Virtual Private Networks (VPN)](#virtual-private-networks-vpns)

## OSI 7 Layer Model

- **Layer 1 - Physical:** Involves the physical aspects of transmitting data, such as voltage levels, cable types, and physical network topologies.
- **Layer 2 - Data Link:** Divided into two sublayers: Logical Link Control (LLC) and Media Access Control (MAC).
- **Layer 3 - Network:** Concerned with logical addressing, routing, and packet forwarding to ensure data reaches its destination across multiple networks.
- **Layer 4 - Transport:** Responsible for end-to-end communication and data delivery.
- **Layer 5 - Session:** Establishes, manages, and terminates sessions between applications.
- **Layer 6 - Presentation:** Responsible for data translation, encryption, and compression.
- **Layer 7 - Application:** Interacts directly with end-users and provides network services to applications.

## Cable Classifications and Speeds:

### Ethernet Cables

- **Category 5e (Cat5e):** Enhanced version of Cat5 cable, supports Gigabit Ethernet and is backward compatible with Cat5.
- **Category 6 (Cat6):** Provides higher performance than Cat5e, supporting 10 Gigabit Ethernet over shorter distances.
- **Category 6a (Cat6a):** Augmented version of Cat6, supports 10 Gigabit Ethernet over longer distances.
- **Category 7 (Cat7):** Offers even better performance and shielding than Cat6a, supporting 10 Gigabit Ethernet over longer distances.

### Network Switch Cables:

- **Network switch cables** connect devices like computers and printers to a network switch, enabling data transmission within a LAN.
- **Types:** Commonly include Ethernet cables (e.g., Cat5e, Cat6).

### Patch Cables:

- **Patch cables** are short Ethernet cables used to connect devices to a patch panel or network switch, allowing flexible connections in network racks or cabinets.
- **Connectors:** Typically feature RJ45 connectors on both ends.


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

## Routing Protocols:

- **OSPF (Open Shortest Path First):**
  - **Description:** Link-state routing protocol.
  - **Algorithm:** Uses Dijkstra's algorithm to calculate the shortest path.
  - **Usage:** Commonly used in large networks.
- **BGP (Border Gateway Protocol):**
  - **Description:** Path vector routing protocol.
  - **Usage:** Used between different autonomous systems (ASes) on the internet.
  - **Emphasis:** Policy-based routing decisions.
- **EIGRP (Enhanced Interior Gateway Routing Protocol):**
  - **Description:** Cisco proprietary routing protocol.
  - **Features:** Hybrid distance vector and link-state protocol.
  - **Support:** Variable-length subnet masks (VLSM) and rapid convergence.
- **RIP (Routing Information Protocol):**
  - **Description:** Distance vector routing protocol.
  - **Features:** Simple and easy to configure.
  - **Usage:** Commonly used in small to medium-sized networks.
- **IS-IS (Intermediate System to Intermediate System):**
  - **Description:** Link-state routing protocol.
  - **Usage:** Commonly used in large service provider networks.
- **Babel:**
  - **Description:** Distance vector routing protocol.
  - **Features:** Designed for wireless mesh networks and multi-hop ad hoc networks.

## Common Ports and Protocols:

 **TCP (Transmission Control Protocol):**
  - **Description:** Connection-oriented protocol used for reliable, ordered delivery of data packets.
  - **Features:** Provides error checking and flow control mechanisms.
  - **Usage:** Widely used in applications such as web browsing, email, file transfer.
 **UDP (User Datagram Protocol):**
  - **Description:** Connectionless protocol used for faster, but unreliable, communication.
  - **Features:** Minimal overhead compared to TCP, suitable for real-time applications.
  - **Usage:** Commonly used in streaming media, online gaming, DNS.

**SCTP (Stream Control Transmission Protocol):**
  - **Description:** SCTP is a connection-oriented protocol used for reliable, ordered delivery of data packets. It offers additional features such as multi-homing and multi-streaming.
  - **Features:** Provides reliability and congestion control similar to TCP, along with enhanced fault tolerance and performance.
  - **Usage:** Used in applications where improved fault tolerance and performance are required, such as telecommunications and Voice over IP (VoIP).

**DCCP (Datagram Congestion Control Protocol):**
  - **Description:** DCCP is a transport layer protocol designed to provide unreliable, connection-oriented communication similar to UDP but with congestion control mechanisms similar to TCP.
  - **Features:** Offers unreliable communication similar to UDP with congestion control mechanisms similar to TCP.
  - **Usage:** Used for real-time multimedia streaming applications where some packet loss is acceptable, but congestion control is still necessary.

**RTP (Real-time Transport Protocol):**
  - **Description:** RTP is a higher-level protocol commonly used for real-time multimedia streaming applications such as VoIP and video conferencing.
  - **Features:** Provides timestamping, sequence numbering, and payload identification for real-time data streams.
  - **Usage:** Often used in conjunction with UDP for transporting real-time data packets.

**QUIC (Quick UDP Internet Connections):**
  - **Description:** QUIC is a transport layer protocol developed by Google that runs over UDP. It aims to provide low-latency communication with built-in encryption and congestion control.
  - **Features:** Offers low-latency communication, built-in encryption, and congestion control.
  - **Usage:** Designed to address some of the limitations of TCP, such as the latency introduced by TCP's handshake process.

### Ports:

 **FTP (File Transfer Protocol):**
   - Port 20 (FTP Data) and Port 21 (FTP Control) (TCP)
   - Used for transferring files between a client and server on a network.

 **SSH (Secure Shell):**
   - Port 22 (TCP)
   - Provides secure remote access to a device or server over a network.

 **SMTP (Simple Mail Transfer Protocol):**
   - Port 25 (TCP)
   - Used for sending email messages between servers.

 **DNS (Domain Name System):**
   - Port 53 (UDP/TCP)
   - Resolves domain names to IP addresses and vice versa.

 **HTTP (Hypertext Transfer Protocol):**
   - Port 80 / 8080 (TCP)
   - Used for transferring web pages and related content on the World Wide Web.

 **POP3 (Post Office Protocol version 3):**
   - Port 110 (TCP)
   - Retrieves email from a remote server to a local client.

 **IMAP (Internet Message Access Protocol):**
   - Port 143 (TCP)
   - Allows an email client to access email on a remote server.

 **HTTPS (Hypertext Transfer Protocol Secure):**
   - Port 443 (TCP)
   - Secure version of HTTP, encrypted using SSL/TLS.
   - Also used for VPN services and Websockets (SSL Hooks)

  **SQL (Structured Query Language):**
   - Port 118 & Port 156

  **NTP (Network Time Protocol):**
   - Port 123
   - Used for time synchronization across a network

  **EPMAP (End Point Mapper):**
   - Port 135
   - Used to remotely manage services like DHCP server, DNS server and WINS. Also used by DCOM.

  **NETBIOS (NetBIOS):**
   - Ports 137-139
   - NetBIOS Name Service used for name registration and resolution on Port 137
   - NetBIOS Datagram Service on Port 138
   - NetBIOS Session Serivce on Port 139

  **IMAP (Internet Message Access Protocol):**
   - Port 143
   - Used for managment of electronic mail messages on servers.

  **ADDS (Active Directory Domain Services):**
   - Port 445
   - Used by both ADDS and SMB (Net Shares)

### KERBEROS PORTS

 **KERBEROS (Kerberos):**
   - Port 88 & 464
   - Used in conjunction with NTLM and LDAP
   - Standard way to authenticate sessions and users within an Active Directory Domain.
   - Port 464 is used for Changing & Setting passwords.
  
  **KLOGIN (Kerberos Login):**
   - Port 543

  **KSHELL (Kerberos Remote Shell):**
   - Port 544

  **Kerberos Administration:**
   - Port 749

  **Kerberos-iv (Version IV):**
   - Port 750

  **Kerberos_Master (Kerberos Authentication):**
   - Port 751

  **PASSWD_SERVER (Kerberos Password "kpasswd" Server):**
   - Port 752

  **KRB5_PROP (Kerberos v5 Slave Propagation):**
   - Port 754

  **KRBUPDATE [KREG] (Kerberos Registration)**
   - Port 760

  **FTPS (File Transfer Protocol Secure):**
   - Ports 989-990
   - 989 is used for data over TLS/SSL
   - 990 is used for control over TLS/SSL

## Subnetting Basics:

- Two IP addresses are always reserved within a subnet. One for the broadcast and one for the network address. So a /24 network would have 254 rather than 256.

- **Subnet Mask:** Determines network and host portions of an IP address.
- **CIDR Notation:** Shorthand for subnet masks (/x format).
- **IP Address Range:** Range of IP addresses within a subnet.
- **Max IP Availability:** Maximum available IP addresses for each subnet.

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

## Firewalls

- **Definition:** A security device or software that monitors and controls incoming and outgoing network traffic based on predetermined security rules.
- **Types of Firewalls:**
  - **Packet Filtering Firewalls:** Examines packets and filters them based on criteria such as source and destination IP addresses, ports, and protocols.
  - **Stateful Inspection Firewalls:** Tracks the state of active connections and makes decisions based on the context of the traffic.
  - **Proxy Firewalls:** Act as intermediaries between internal and external networks, inspecting and filtering traffic at the application layer.
- **Firewall Rules:** Configurations that dictate how a firewall should handle traffic. Rules can allow, block, or restrict specific types of traffic based on various criteria.
- **Intrusion Detection and Prevention Systems (IDPS):** Often integrated with firewalls, IDPS monitors network traffic for suspicious activities and can take action to block or alert on detected threats.

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

## WebSockets

- **Definition:** WebSockets is a communication protocol that provides full-duplex communication channels over a single, long-lived TCP connection. It enables bi-directional communication between a client and server.
- **Features:**
  - **Full-duplex Communication:** Allows both the client and server to send messages to each other simultaneously.
  - **Low Latency:** Maintains a persistent connection, reducing overhead compared to traditional HTTP requests.
  - **Efficiency:** Eliminates the need for repeated HTTP header negotiation, resulting in lower latency and bandwidth usage.
  - **Real-time Updates:** Ideal for applications requiring real-time updates or notifications, such as chat applications, online gaming, and financial trading platforms.
- **Usage:** WebSockets are commonly used in web applications to enable real-time, interactive features without the need for continuous polling or frequent HTTP requests.
- **Protocol:** WebSockets use a handshake mechanism to establish a connection between the client and server, followed by message framing to exchange data.
- **Supported Platforms:** WebSockets are supported by most modern web browsers and can be implemented using various programming languages and frameworks, such as JavaScript, Python, and Node.js.

## Network Address Translation (NAT):

- **Definition:** Network Address Translation (NAT) is a technique used to modify network address information in packet headers while in transit, typically to map private IP addresses to public IP addresses and vice versa.
- **Types of NAT:**
  - **Static NAT:** Maps a private IP address to a single public IP address on a one-to-one basis.
  - **Dynamic NAT:** Dynamically assigns a public IP address from a pool of available addresses to private IP addresses on a one-to-one basis as needed.
  - **Port Address Translation (PAT):** Maps multiple private IP addresses to a single public IP address by using different port numbers to distinguish between connections.
  - **Overloading:** Another term for PAT, where multiple private IP addresses are mapped to a single public IP address.
- **Applications:** NAT is commonly used in home and enterprise networks to conserve public IP addresses, enable communication between private and public networks, and enhance network security.

## Load Balancing:

- **Definition:** Load balancing is the process of distributing incoming network traffic across multiple servers to optimize resource utilization, ensure high availability, and improve performance.
- **Load Balancing Algorithms:**
  - **Round Robin:** Distributes traffic evenly across servers in a sequential manner.
  - **Least Connections:** Routes traffic to the server with the fewest active connections, minimizing response time and avoiding overloading.
  - **Least Response Time:** Directs traffic to the server with the fastest response time based on historical performance data.
- **Implementation:** Load balancing can be achieved through hardware load balancers, software-based load balancers, or cloud-based load balancers.
- **Applications:** Load balancing is essential for distributing workloads across servers in web applications, ensuring scalability, fault tolerance, and optimal performance.

## Software-Defined Networking (SDN):

- **Definition:** Software-Defined Networking (SDN) is an approach to networking that decouples the control plane from the data plane, allowing network administrators to programmatically control network behavior through centralized software-based controllers.
- **Key Components:**
  - **SDN Controller:** Centralized software platform that manages the network and communicates with switches and routers using protocols like OpenFlow.
  - **Southbound APIs:** Interfaces that allow the SDN controller to communicate with network devices, controlling their behavior.
  - **Northbound APIs:** Interfaces that enable integration with higher-level network management applications and orchestration systems.
- **Benefits:**
  - **Centralized Management:** Simplifies network configuration, monitoring, and troubleshooting.
  - **Dynamic Provisioning:** Enables automated provisioning and deployment of network resources based on application requirements.
  - **Scalability and Flexibility:** Allows for rapid scalability and adaptation to changing network demands.
- **Applications:** SDN is used in data centers, campus networks, and wide-area networks (WANs) to improve network agility, efficiency, and security.

## Container Networking:

- **Definition:** Container networking refers to the networking capabilities and configurations associated with containerized applications deployed in container runtime environments such as Docker, Kubernetes, and others.
- **Key Concepts:**
  - **Container Networking Interface (CNI):** Specification for network plugins in container runtimes, enabling containers to connect to networks and each other.
  - **Overlay Networks:** Virtual networks created on top of existing physical networks to facilitate communication between containers across different hosts.
  - **Service Discovery:** Mechanisms for automatically detecting and connecting containerized services within a network, often using DNS or service registries.
- **Networking Models:**
  - **Bridge Networking:** Containers share the host's network stack, each with its own IP address and network namespace.
  - **Host Networking:** Containers share the host's network stack and IP address, bypassing network isolation but offering better performance.
  - **Overlay Networking:** Containers communicate over an overlay network, abstracting underlying physical network details and enabling multi-host communication.
- **Tools and Technologies:** Various container networking solutions exist, including Docker Networking, Kubernetes networking plugins (e.g., Flannel, Calico), and container orchestration platforms.
- **Use Cases:** Container networking enables microservices architectures, facilitates application scalability, and supports cloud-native development and deployment practices.

## Wireless Networking:

- **Definition:** Wireless networking refers to the technology that enables communication between devices without the use of physical wired connections, typically using radio frequency signals.
- **Key Concepts:**
  - **Wi-Fi (802.11):** Standard for wireless local area networking (WLAN) that allows devices to connect to a network wirelessly within a limited range.
  - **Bluetooth:** Wireless technology used for short-range communication between devices, such as smartphones, laptops, and peripherals.
  - **Zigbee:** Low-power wireless communication protocol commonly used in home automation, industrial control, and sensor networks.
- **Security Considerations:**
  - **Encryption:** Implementing security protocols like WPA2 (Wi-Fi Protected Access 2) to encrypt wireless communications and prevent unauthorized access.
  - **Access Control:** Configuring MAC address filtering, disabling SSID broadcasting, and using strong passwords to control access to wireless networks.
- **Best Practices:**
  - **Placement of Access Points:** Strategically placing access points to ensure adequate coverage and minimize interference in wireless networks.
  - **Firmware Updates:** Regularly updating firmware for wireless routers and access points to address security vulnerabilities and improve performance.
- **Challenges:** Wireless networking faces challenges such as signal interference, limited range, and security vulnerabilities, which require careful consideration and mitigation strategies.

### SMB Network Shares:

- **Definition:** SMB (Server Message Block) network shares allow users to access files and folders stored on remote servers over a network, providing a centralized storage solution for sharing resources within a workgroup or domain.
- **Key Components:**
  - **Shared Folders:** Directories or volumes on a file server that are made accessible to network users through SMB shares.
  - **Permissions:** Access control settings that determine which users or groups have read, write, or modify permissions on shared folders.
  - **Mapping Drives:** Associating a drive letter with an SMB network share for easier access and navigation.
- **Authentication Methods:**
  - **Workgroup Authentication:** Users provide credentials specific to the server hosting the SMB share.
  - **Domain Authentication:** Users authenticate against a centralized domain controller, allowing for unified access control and management.
- **Access Protocols:**
  - **SMBv1:** Legacy version of the SMB protocol with known security vulnerabilities. Deprecated in modern environments due to security risks.
  - **SMBv2/v3:** Improved versions of the SMB protocol with enhanced security features, better performance, and support for features like encryption and opportunistic locking.
- **Best Practices:**
  - **Security Hardening:** Disabling SMBv1 where possible, implementing secure authentication mechanisms (e.g., Kerberos), and enforcing strict access controls to mitigate security risks.
  - **Data Backup:** Regularly backing up data stored on SMB network shares to prevent data loss in case of hardware failures, user errors, or security breaches.



## Virtual Private Networks (VPNs):

- **Definition:** A Virtual Private Network (VPN) is a secure and encrypted connection established over a public network, such as the internet, to provide privacy and security for users accessing resources from remote locations.
- **VPN Protocols:**
  - **OpenVPN:** Open-source VPN protocol known for its flexibility, cross-platform compatibility, and strong security features.
  - **IPSec (Internet Protocol Security):** Suite of protocols used for secure communication over IP networks, commonly used in site-to-site VPNs and remote access VPNs.
  - **L2TP/IPSec (Layer 2 Tunneling Protocol/IPSec):** Combines the features of L2TP and IPSec to provide a secure and encrypted tunnel for VPN connections.
  - **SSL/TLS VPN:** Utilizes SSL/TLS protocols to establish a secure VPN connection, often used for remote access to web-based applications.
- **VPN Types:**
  - **Remote Access VPN:** Allows individual users to connect securely to a corporate network from remote locations using VPN client software.
  - **Site-to-Site VPN:** Establishes secure connections between multiple networks, such as branch offices or data centers, over the internet.
- **VPN Security:** VPNs use encryption and authentication mechanisms to ensure the confidentiality, integrity, and authenticity of transmitted data.
- **Benefits:** VPNs provide secure remote access to corporate resources, enable anonymous browsing and access to geo-restricted content, and enhance network security and privacy.

## Software-Defined WAN (SD-WAN):

- **Definition:** Software-Defined WAN (SD-WAN) is a technology that simplifies the management and operation of a wide-area network (WAN) by separating the network hardware from its control mechanism and using software to intelligently direct traffic across the WAN.
- **Key Features:**
  - **Centralized Management:** SD-WAN solutions offer centralized control and management of network resources, allowing administrators to configure policies, monitor performance, and optimize traffic flow from a single interface.
  - **Dynamic Path Selection:** SD-WAN dynamically selects the best path for network traffic based on application requirements, network conditions, and business policies, improving performance and reliability.
  - **Application Visibility and Control:** SD-WAN provides visibility into application traffic and enables granular control over how applications are routed and prioritized across the network.
- **Deployment Models:**
  - **On-Premises SD-WAN:** Deployed as physical or virtual appliances within the enterprise network infrastructure, providing direct control over network traffic and security policies.
  - **Cloud-based SD-WAN:** Hosted and managed by a third-party service provider, offering scalability, flexibility, and simplified management for distributed organizations.
- **Benefits:**
  - **Improved Performance:** SD-WAN optimizes network traffic and application performance by dynamically routing traffic over the most efficient path.
  - **Enhanced Reliability:** SD-WAN enhances network reliability by leveraging multiple transport links, such as MPLS, broadband internet, and LTE, and automatically rerouting traffic in case of link failures.
  - **Cost Savings:** SD-WAN reduces WAN costs by leveraging cost-effective internet connections, minimizing reliance on expensive MPLS circuits, and optimizing bandwidth usage.
- **Use Cases:** SD-WAN is used by organizations to improve branch connectivity, support cloud migration, enhance application performance, and reduce operational costs.

## Network Monitoring and Management:

- **Definition:** Network monitoring and management involves the use of tools, protocols, and techniques to monitor, analyze, and manage the performance, availability, and security of computer networks.
- **Key Components:**
  - **Network Monitoring Tools:** Software applications used to collect and analyze network traffic data, monitor device performance, and detect anomalies or security threats.
  - **Network Management Protocols:** Protocols such as SNMP (Simple Network Management Protocol) and NetFlow used to manage network devices, monitor performance metrics, and configure network settings remotely.
- **Monitoring Techniques:**
  - **Traffic Analysis:** Analyzing network traffic patterns, bandwidth utilization, and packet-level details to identify performance bottlenecks, troubleshoot issues, and detect security threats.
  - **Performance Monitoring:** Monitoring key performance indicators (KPIs) such as latency, packet loss, and throughput to ensure optimal network performance and identify areas for improvement.
  - **Alerting and Notification:** Configuring alerts and notifications to proactively identify and respond to network issues, security breaches, or performance degradation.
- **Management Practices:**
  - **Configuration Management:** Managing and maintaining device configurations, ensuring consistency, compliance with security policies, and efficient network operation.
  - **Change Management:** Implementing processes and procedures to plan, schedule, and document changes to the network infrastructure, minimizing disruption and ensuring stability.
  - **Capacity Planning:** Forecasting future network requirements, analyzing current usage trends, and scaling network resources to accommodate growth and maintain performance.
- **Tools and Solutions:**
  - **Network Monitoring Software:** Commercial and open-source tools such as Nagios, Zabbix, and PRTG used for real-time monitoring, alerting, and reporting.
  - **Network Management Systems (NMS):** Integrated platforms for network monitoring, configuration management, performance analysis, and troubleshooting.
- **Best Practices:** Implementing network monitoring and management best practices such as regular monitoring, proactive maintenance, documentation, and collaboration between IT teams to ensure efficient network operation and security.

## Physical Networking:

  #### Switches:
  - **Definition:** Switches are networking devices that connect multiple devices within a local area network (LAN) and forward data packets between them based on their MAC addresses.
  - **Key Features:**
    - Port Density: Number of ports available on the switch for connecting devices.
    - VLAN Support: Ability to segment the network into virtual LANs for improved performance and security.
    - PoE (Power over Ethernet): Capability to provide power to connected devices such as IP phones and wireless access points over Ethernet cables.
  - **Switch Languages:**
    - **CLI (Command Line Interface):** Text-based interface used for configuring and managing switches through commands.
    - **GUI (Graphical User Interface):** Visual interface with menus and icons for configuring switches, suitable for less experienced users.
  - **Best Practices:** Implementing switch redundancy with features like Spanning Tree Protocol (STP) or Rapid Spanning Tree Protocol (RSTP) to ensure network reliability.

  #### Access Points:
  - **Definition:** Access points (APs) are devices that provide wireless connectivity to devices within a network by creating a wireless LAN (WLAN) infrastructure.
  - **Key Features:**
    - Wireless Standards: Support for Wi-Fi standards such as 802.11ac, 802.11ax (Wi-Fi 6), and 802.11ad (WiGig).
    - Dual-band or Tri-band: Ability to operate on multiple frequency bands (2.4 GHz and 5 GHz) for improved performance and flexibility.
    - Wireless Security: Implementation of encryption protocols like WPA2/WPA3 and wireless intrusion detection/prevention systems (WIDS/WIPS).
  - **Deployment Considerations:** Placement of access points for optimal coverage and signal strength, considering factors like building layout, interference, and client density.

  #### Exchanges:
  - **Definition:** Exchanges, or network exchanges, are facilities where network service providers interconnect their networks to exchange traffic.
  - **Key Functions:**
    - **Peering:** Establishment of direct connections between networks to exchange traffic without traversing the public internet.
    - **Routing:** Directing traffic between interconnected networks based on routing policies and agreements.
    - **Interconnection Services:** Offering services such as colocation, cross-connects, and internet exchange points (IXPs) to facilitate network interconnection.
  - **Types of Exchanges:** Internet exchanges (IXs), carrier-neutral data centers, and network access points (NAPs) are examples of facilities that serve as network exchanges.