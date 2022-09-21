#!/bin/bash

Creation Date: September 20th, 2022
Created by: gfeze@prismhr.com
Modified on:

#Description : This Script is issue to Deploy Okta Login App and Okta API Through Docker Swarm for Dev Env

#Variables
LOGIMAGE=`docker-dtr.prismhr.com/prismhr/okta-auth:latest`
APIMAGE=`docker-dtr.prismhr.com/prismhr/okta-auth-api:latest`
`
#login on the Server as "docker-stg" user
echo "Login on the server as docker-stg user"
sudo su - docker-stg
sleep 2

#Tearing Down the related stacks
echo -e "\nTearing down okta-auth-006 stack"
sleep 2
docker stack rm okta-auth-006
echo -e "\nTearing down okta-auth-api-006 stack"
docker stack rm okta-auth-api-006

#Download the latest versions of the app
echo -e "\nDownloading Okta Login App latest image"
sleep 2
docker image pull ${LOGIMAGE}
sleep 2
echo -e "\nDownloading Okta Auth API latest image"
docker image pull ${APIMAGE}

#Getting in the appropriate Directory
cd /opt/docker/stg/okta-auth/006

#Deploy the Okta-Login-App
echo -e "\nDeploying Okta-Login-App Stack"
sleep 2
docker stack deploy --compose-file docker-compose.yml okta-auth-006

#Deploy the Okta-Auth-Api
echo -e "\nDeploying Okta-Auth-Api Stack"
cd /opt/docker/stg/okta-auth-api/006
sleep 2
docker stack deploy --compose-file docker-compose.yml okta-auth-api-006

RESULT=$(echo $?)

if [[ ${RESULT} == 0 ]]
then
echo -e "\nDEPLOYMENT SUCCESSFUL"
else 
echo -e "\nDEPLOYEMENT FAILED"
fi
