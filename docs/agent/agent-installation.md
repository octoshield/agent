---
id: agent-installation
title: Agent Installation
sidebar_label: Installation
---
## Automated Installation

To install your agent, go on app.octoshield.com/#/install to get your token, then run
```
TOKEN=<<YOUR_TOKEN>> bash -c "$(curl -H 'Cache-Control: no-cache' -L https://raw.githubusercontent.com/octoshield/agent/master/install.sh)"
```

## Manual installation

### Prerequisite
The agent doesn't require any library to start, however some chaos task require specific tools to work properly in the current version.

iptables and tc (traffic control) are required for some tasks. See details below.

### Binary
The agent binary is available at [https://raw.githubusercontent.com/octoshield/agent/master/octoshield-agent](https://raw.githubusercontent.com/octoshield/agent/master/octoshield-agent)

### Permissions
The agent doesn't requires to run as root user.

#### Capabilities
The installation script will automatically create a systemd service with the proper capabilities. 

Service example:

```bash
[Unit]
Description=Octoshield application
After=syslog.target

[Service]
User=octoshield-agent
Group=octoshield-agent
AmbientCapabilities=CAP_NET_RAW CAP_NET_ADMIN CAP_KILL CAP_SYS_BOOT
ExecStart=/bin/bash -c "/etc/octoshield-agent/octoshield-agent --log-level DEBUG >> /etc/octoshield-agent/agent.log 2>&1"

[Install]
WantedBy=multi-user.target
```
If you need to run the service with systemv instead of systemd, you'll have to change the `pam_cap.so` module to add the capabilities to your user.

#### service restarts (sudo)
In addition to these capacities, you might want to reboot some services as rollback commands. We advise to add this sudo command in your `/etc/sudoers` files without password:

```bash
octoshield-agent        ALL = NOPASSWD: /bin/systemctl restart *
``` 

### Detailed Permissions and dependencies required per attack

| Chaos Tasks       | Description                   | Dependencies                                | Capabilities
| -------------     |:-----------------------------:| -------------------------------------------:| ---------------:|
| **Network**       |
| BLOCK_NETWORK     | block all network traffic     | iptables (contact us for firewalld support) |  CAP_NET_RAW, CAP_NET_ADMIN| 
| IPTABLE           | apply specific iptables rules | iptables (contact us for firewalld support) |  CAP_NET_RAW, CAP_NET_ADMIN|
| NETWORK_LATENCIES | generate latency on network   | tc (traffic control)                        |  CAP_NET_RAW, CAP_NET_ADMIN|
| NETWORK_LOSS      | generate paquet loss on network   | tc (traffic control)                        |  CAP_NET_RAW, CAP_NET_ADMIN|
| NETWORK_BANDWIDTH | change bandwidth on network   | tc (traffic control)                        |  CAP_NET_RAW, CAP_NET_ADMIN|
| **Process**       |
| KILL              | kill a given process          | see STOP_SERVICE for service restart as rollback command |  CAP_KILL                                                                          | 
| STOP_SERVICE      | restart a custom service      | Require systemd or service                               |  sudo systemd/service * must be set in /etc/sudoers to allow service restart       | 
| **Resources**     |
| REBOOT            | kill a given process          |                                                          |  CAP_SYS_BOOT service * must be set in /etc/sudoers to allow service restart       | 
| REBOOT            | kill a given process          |                                                          |  CAP_SYS_BOOT service * must be set in /etc/sudoers to allow service restart       | 
