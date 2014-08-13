#!/bin/bash

ip=$(sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" $1)

ssh -i docker/insecure_key root@$ip