#include <pcap.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <arpa/inet.h>

#define LOG_FILE "packet_log.bin"

struct ieee80211_radiotap_header {
    uint8_t it_version;
    uint8_t it_pad;
    uint16_t it_len;
    uint32_t it_present;
};

struct ieee80211_frame_control {
    uint8_t version:2;
    uint8_t type:2;
    uint8_t subtype:4;
    uint8_t to_ds:1;
    uint8_t from_ds:1;
    uint8_t more_frag:1;
    uint8_t retry:1;
    uint8_t pwr_mgt:1;
    uint8_t more_data:1;
    uint8_t protected_frame:1;
    uint8_t order:1;
};

struct ieee80211_data_frame {
    struct ieee80211_frame_control fc;
    uint16_t duration_id;
    uint8_t addr1[6];
    uint8_t addr2[6];
    uint8_t addr3[6];
    uint16_t seq_ctrl;
    uint8_t addr4[6];
};

struct ip_header {
    uint8_t  ver_ihl;        // Version (4 bits) + Internet header length (4 bits)
    uint8_t  tos;            // Type of service 
    uint16_t tlen;           // Total length 
    uint16_t identification; // Identification
    uint16_t flags_fo;       // Flags (3 bits) + Fragment offset (13 bits)
    uint8_t  ttl;            // Time to live
    uint8_t  proto;          // Protocol
    uint16_t crc;            // Header checksum
    uint32_t saddr;          // Source address
    uint32_t daddr;          // Destination address
    uint32_t op_pad;         // Option + Padding
};

struct tcp_header {
    uint16_t sport;          // Source port
    uint16_t dport;          // Destination port
    uint32_t seq;            // Sequence number
    uint32_t ack;            // Acknowledgement number
    uint8_t  data_offset;    // Data offset
    uint8_t  flags;          // Flags
    uint16_t window;         // Window size
    uint16_t checksum;       // Checksum
    uint16_t urg_ptr;        // Urgent pointer
};

struct udp_header {
    uint16_t sport;          // Source port
    uint16_t dport;          // Destination port
    uint16_t len;            // Datagram length
    uint16_t crc;            // Checksum
};

void log_packet_info(const struct pcap_pkthdr *header) {
    FILE *file = fopen(LOG_FILE, "ab");
    if (file) {
        fwrite(header, sizeof(struct pcap_pkthdr), 1, file);
        fclose(file);
    }
}

void log_packet(const unsigned char *pkt_data, uint32_t len) {
    FILE *file = fopen(LOG_FILE, "ab");
    if (file) {
        fwrite(pkt_data, len, 1, file);
        fclose(file);
    }
}

void handle_wifi_packet(const struct pcap_pkthdr *header, const unsigned char *pkt_data) {
    if (header->len < sizeof(struct ieee80211_radiotap_header)) {
        fprintf(stderr, "Packet too short for Radiotap header\n");
        return;
    }

    struct ieee80211_radiotap_header *radiotap_header = (struct ieee80211_radiotap_header *)pkt_data;
    unsigned int radiotap_len = radiotap_header->it_len;

    if (header->len < radiotap_len + sizeof(struct ieee80211_data_frame)) {
        fprintf(stderr, "Packet too short for 802.11 data frame\n");
        return;
    }

    struct ieee80211_data_frame *data_frame = (struct ieee80211_data_frame *)(pkt_data + radiotap_len);

    printf("WiFi Packet captured: length %d\n", header->len);
    log_packet_info(header);
    log_packet(pkt_data, header->len);

    printf("Frame Control: \n");
    printf("  Version: %d\n", data_frame->fc.version);
    printf("  Type: %d\n", data_frame->fc.type);
    printf("  Subtype: %d\n", data_frame->fc.subtype);
    printf("  To DS: %d\n", data_frame->fc.to_ds);
    printf("  From DS: %d\n", data_frame->fc.from_ds);

    printf("Addresses: \n");
    printf("  Address 1: %02x:%02x:%02x:%02x:%02x:%02x\n",
           data_frame->addr1[0], data_frame->addr1[1], data_frame->addr1[2],
           data_frame->addr1[3], data_frame->addr1[4], data_frame->addr1[5]);
    printf("  Address 2: %02x:%02x:%02x:%02x:%02x:%02x\n",
           data_frame->addr2[0], data_frame->addr2[1], data_frame->addr2[2],
           data_frame->addr2[3], data_frame->addr2[4], data_frame->addr2[5]);
    printf("  Address 3: %02x:%02x:%02x:%02x:%02x:%02x\n",
           data_frame->addr3[0], data_frame->addr3[1], data_frame->addr3[2],
           data_frame->addr3[3], data_frame->addr3[4], data_frame->addr3[5]);

    if (data_frame->fc.to_ds && data_frame->fc.from_ds) {
        printf("  Address 4: %02x:%02x:%02x:%02x:%02x:%02x\n",
               data_frame->addr4[0], data_frame->addr4[1], data_frame->addr4[2],
               data_frame->addr4[3], data_frame->addr4[4], data_frame->addr4[5]);
    }

    printf("Sequence Control: %d\n", data_frame->seq_ctrl);
}

void handle_tcp_packet(const unsigned char *pkt_data) {
    struct tcp_header *tcp = (struct tcp_header *)pkt_data;
    printf("TCP Packet:\n");
    printf("  Source Port: %d\n", ntohs(tcp->sport));
    printf("  Destination Port: %d\n", ntohs(tcp->dport));
    printf("  Sequence Number: %u\n", ntohl(tcp->seq));
    printf("  Acknowledgment Number: %u\n", ntohl(tcp->ack));
}

void handle_udp_packet(const unsigned char *pkt_data) {
    struct udp_header *udp = (struct udp_header *)pkt_data;
    printf("UDP Packet:\n");
    printf("  Source Port: %d\n", ntohs(udp->sport));
    printf("  Destination Port: %d\n", ntohs(udp->dport));
    printf("  Length: %d\n", ntohs(udp->len));
}

void handle_ip_packet(const unsigned char *pkt_data) {
    struct ip_header *ip = (struct ip_header *)pkt_data;
    unsigned int ip_header_len = (ip->ver_ihl & 0x0F) * 4;

    printf("IP Packet:\n");
    printf("  Source IP: %s\n", inet_ntoa(*(struct in_addr *)&ip->saddr));
    printf("  Destination IP: %s\n", inet_ntoa(*(struct in_addr *)&ip->daddr));
    printf("  Protocol: %d\n", ip->proto);

    switch (ip->proto) {
        case 6:  // TCP
            handle_tcp_packet(pkt_data + ip_header_len);
            break;
        case 17: // UDP
            handle_udp_packet(pkt_data + ip_header_len);
            break;
        default:
            printf("  Unhandled IP protocol: %d\n", ip->proto);
            break;
    }
}

void handle_ethernet_packet(const struct pcap_pkthdr *header, const unsigned char *pkt_data) {
    printf("Ethernet Packet captured: length %d\n", header->len);
    log_packet_info(header);
    log_packet(pkt_data, header->len);

    struct ip_header *ip = (struct ip_header *)(pkt_data + 14);  // Skip Ethernet header (14 bytes)
    handle_ip_packet((unsigned char *)ip);
}

void packet_handler(unsigned char *param, const struct pcap_pkthdr *header, const unsigned char *pkt_data) {
    // Determine packet type and call the appropriate handler
    struct ether_header *eth_header = (struct ether_header *)pkt_data;
    switch (ntohs(eth_header->ether_type)) {
        case ETHERTYPE_IP:
            handle_ethernet_packet(header, pkt_data);
            break;
        default:
            printf("Unhandled Ethernet type: %x\n", ntohs(eth_header->ether_type));
            break;
    }
}

int main() {
    pcap_t *handle;
    char errbuf[PCAP_ERRBUF_SIZE];
    char *dev = pcap_lookupdev(errbuf);

    if (dev == NULL) {
        fprintf(stderr, "Couldn't find default device: %s\n", errbuf);
        return 2;
    }

    handle = pcap_open_live(dev, BUFSIZ, 1, 1000, errbuf);
    if (handle == NULL) {
        fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
        return 2;
    }

    pcap_loop(handle, 0, packet_handler, NULL);

    pcap_close(handle);
    return 0;
}