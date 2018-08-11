#!/bin/bash

OUTPUT=$(sudo file -s /dev/xvdf)
if [[ $OUTPUT =~ (: data)* ]]; then
    sudo mkfs -t ext4 /dev/xvdf
fi

sudo mkdir -p /app/teamcity
sudo mount /dev/xvdf /app/teamcity

sudo yum install -y docker
sudo service docker start

sudo docker run -d --name teamcity-server -v /app/teamcity/datadir:/data/teamcity_server/datadir -v /app/teamcity/logs:/opt/teamcity/logs -p 80:8111 -m 2048m jetbrains/teamcity-server
sudo docker run -d --name teamcity-agent --link teamcity-server -e SERVER_URL=http://teamcity-server:8111 -e AGENT_NAME=ubuntu -v /app/teamcity/agents/ubuntu:/data/teamcity_agent/conf -m 1024m jetbrains/teamcity-agent
