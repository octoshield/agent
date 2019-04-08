#!/usr/bin/env bash
echo "INFO: Octoshield-agent installation"
echo "----------------------------------------"
echo "INFO: Creating octoshield-agent user..."
export USER=octoshield-agent
sudo mkdir -p "/etc/$USER"
sudo useradd $USER --home-dir "/etc/$USER"

echo "INFO: Downloading agent binary..."
sudo wget -O /etc/octoshield-agent/octoshield-agent https://raw.githubusercontent.com/octoshield/agent/master/octoshield-agent 2>/dev/null || sudo curl -o /etc/octoshield-agent/octoshield-agent https://raw.githubusercontent.com/octoshield/agent/master/octoshield-agent
sudo chown octoshield-agent:octoshield-agent /etc/octoshield-agent/octoshield-agent

echo "INFO: creating default configuration file in /etc/octoshield-agent/config.yml"

sudo bash -c "cat >/etc/octoshield-agent/config.yml"  <<EOL
token: $TOKEN
serverUrl: "http://localhost:8080"
env: PREPROD
#you must set at list 1 tag to select your agent
tags:
#  key1: value1

#extra options:
#Agent uuid, if not set, a random uuid will be generated during the first startup
#uuid:

#Proxy configuration
#proxy:
#  url:
#  username:
#  password:
#  insecureSkipVerify: true

EOL
sudo chown octoshield-agent:octoshield-agent /etc/octoshield-agent/config.yml
sudo chmod 660 /etc/octoshield-agent/config.yml

echo "INFO: Creating octoshield-agent service"
sudo bash -c "cat >/etc/systemd/system/octoshield-agent.service"  <<EOL
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
EOL
sudo systemctl daemon-reload


export FILE='/etc/sudoers'
if [ -f $FILE ]; then
    RESTART_COMMAND=""
    if [ -f /bin/systemctl ]; then
        RESTART_COMMAND="/bin/systemctl * "
    fi
    if [ -f /usr/sbin/service ]; then
        RESTART_COMMAND="$RESTART_COMMAND, /usr/sbin/service *"
    fi

    LINE="$USER        ALL = NOPASSWD: $RESTART_COMMAND #do not edit"
    sudo chmod +w $FILE
    bach -c 'grep -q "^$USER" $FILE && sed -i "s|^$USER.*do not edit$|$LINE|g" $FILE || echo "$LINE" >> $FILE'
    sudo chmod -w $FILE
    echo "INFO: $RESTART_COMMAND added as allowed sudo operation for $USER"
else
    echo "WARN: couldn't locate $FILE to allow service restart for $USER. systemd/service restarts might not work as rollback command (permission issue)"
fi

echo "----------------------------------------"
echo "INFO: octoshield-agent is ready to start!"
echo "      edit your configuration file in /etc/octoshield-agent/config.yml and run the service with systemctl start octoshield-agent"
