#!/bin/bash
# Script to install SMS Agent on a Linux Machine
# - to store in OBS s3://obs-jla-repo
echo "----------------------------------"
echo "Starting SMS Agent installation..."
echo "----------------------------------"

echo "----------------------------------"
echo "Downloading SMS Agent..."
echo "----------------------------------"
wget -t 3 -T 15 https://sms-agent-bucket.oss.eu-west-0.prod-cloud-ocb.orange-business.com/SMS-Agent.tar.gz

echo "----------------------------------"
echo "?? SMS Agent..."
echo "----------------------------------"
#curl -O https://sms-agent-bucket.oss.eu-west-0.prod-cloud-ocb.orange-business.com/SMS-Agent.tar.gz

echo "----------------------------------"
echo "Uncompressing SMS Agent..."
echo "----------------------------------"
tar -zxf SMS-Agent.tar.gz
echo "----------------------------------"
echo "Starting SMS Agent..."
echo "----------------------------------"
cd SMS-Agent
./startup.sh
