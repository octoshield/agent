---
id: agent-configuration
title: Agent Configuration
sidebar_label: Configuration
---
## Configuration

By default, your agent is configured using `/etc/octoshield-agent/config.yml`:

```yaml
token: TEST_TOKEN
serverUrl: "https://agent.octoshield.com"
#Set your environment
env: PREPROD
#you must set at list 1 tag to select your agent
#the tags `hostname` and `ip` are automatically added for you
tags:
  app: mysql

#Agent uuid, if not set, a random uuid will be generated during the first startup
#uuid:

#Proxy configuration
#proxy:
#  url:
#  username:
#  password:
#  insecureSkipVerify: true
``` 

If you don't set a uuid, the agent will automatically generate a uuid during the first startup and save it under a `uuid` file. 

## Agent options

| option            | Description                   | default                           | values
|:-----------------:|:-----------------------------:| ----------------------------------|------------------------------
| --log-level       | change the log level          | INFO                              |  DEBUG,INFO,WARN,ERROR          
| --config-file     | configuration file            | /etc/octoshield-agent/config.yml  |  string          

 