# Cisco IOS Switch Commands Cheat Sheet

```
## Interface Configuration

- **Enable privileged mode:**  
  ```shell
  enable
  ```

- **Enter global configuration mode:**  
  ```shell
  configure terminal
  ```

- **Access interface configuration mode:**  
  ```shell
  interface <interface_name>
  ```

- **Set interface description:**  
  ```shell
  description <description>
  ```

- **Set interface speed and duplex mode:**  
  ```shell
  speed <speed>
  duplex <mode>
  ```

- **Assign interface to VLAN:**  
  ```shell
  switchport access vlan <vlan_id>
  ```

- **Enable port security:**  
  ```shell
  switchport port-security
  ```

- **Set maximum number of secure MAC addresses:**  
  ```shell
  switchport port-security maximum <max_addresses>
  ```

## VLAN Configuration

- **Create VLAN:**  
  ```shell
  vlan <vlan_id>
  ```

- **Set VLAN name:**  
  ```shell
  name <vlan_name>
  ```

## Spanning Tree Protocol (STP)

- **Enable Rapid Spanning Tree Protocol (RSTP):**  
  ```shell
  spanning-tree mode rapid-pvst
  ```

- **Set bridge priority:**  
  ```shell
  spanning-tree vlan <vlan_id> priority <priority>
  ```

## Border Gateway Protocol (BGP)

- **Enable BGP routing:**  
  ```shell
  router bgp <as_number>
  ```

- **Configure neighbor:**  
  ```shell
  neighbor <neighbor_ip> remote-as <neighbor_as>
  ```

- **Advertise networks:**  
  ```shell
  network <network_address> mask <subnet_mask>
  ```

- **Set BGP router ID:**  
  ```shell
  bgp router-id <router_id>
  ```

- **Redistribute routes into BGP:**  
  ```shell
  redistribute <source_protocol> [route-map <route_map_name>]
  ```

- **Set BGP timers:**  
  ```shell
  timers bgp <keepalive_time> <hold_time>
  ```

- **Enable BGP authentication:**  
  ```shell
  neighbor <neighbor_ip> password <password>
  ```