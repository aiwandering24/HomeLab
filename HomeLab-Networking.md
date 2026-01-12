# Home Lab Networking Documentation

## Overview

This document provides a summary of the Home Lab networking setup, derived from the Networking.drawio.xml Draw.io diagram. The lab features a rack-mounted infrastructure with multiple servers, switches, routers, and supporting hardware for a comprehensive home lab environment.

## Hardware Components

### Servers

The lab includes several enterprise-grade servers from Dell and HP:

- **Dell PowerEdge R720XD** - High-performance server with Large Form Factor (LFF) drives, 2U rack unit
- **Dell PowerEdge R720** - Versatile server with LFF configuration, 2U rack unit
- **HP ProLiant DL380 G7** - Enterprise server
- **HP ProLiant DL360 G5** - Mid-range server
- **HP ProLiant DL160 G6** - Compact server

### Switches

Networking is handled by a mix of Aruba, HP, and Cisco switches:

- **Aruba 2530 48G PoE+** - 48-port Gigabit Ethernet switch with Power over Ethernet support
- **HP 48 Ethernet Switch** - 48-port Ethernet switch
- **Cisco Switch (Small Business)** - Small business-grade Cisco switch
- **Cisco Catalyst 4900M** - High-performance enterprise switch

### Routers

Internet connectivity and routing are provided by:

- **TL-WRB841N 300Mbps Wireless N Router** - Wireless router for network access
- **TELUS 8774 300Mbps Wireless N** - Additional wireless router

### Other Infrastructure

Supporting components include:

- **24-port Ethernet patch panel** - For organized cable management
- **Power strips** - Dell-branded power distribution
- **Fans** - Cooling systems for the rack
- **Dell Sonicwall TZ400** - Firewall/security appliance (front and rear views in diagram)

## Rack Layout

The diagram shows a rack elevation with the servers and networking equipment mounted in a standard server rack. The layout includes:

- Multiple server units stacked vertically
- Switches positioned for optimal cable routing
- Patch panels for cable organization
- Power distribution units
- Cooling fans for thermal management

## Network Topology

The NetworkDiagram page illustrates the logical connections between components:

- Servers connected to switches
- Switches interconnected for redundancy and traffic distribution
- Routers providing internet access and routing
- Firewall integration for security
- Patch panel serving as the central cable distribution point

This setup supports a robust home lab environment capable of running virtual machines, network services, and testing various IT configurations.