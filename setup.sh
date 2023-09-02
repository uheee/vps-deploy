#!/bin/sh
REPO_URL=https://github.com/uheee/vps-deploy
DIR_NAME=deploy

SERVER=$1
ID=$2

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && sudo apt-get upgrade -y
curl https://get.docker.com | sh && sudo systemctl --now enable docker
git clone ${REPO_URL} ${DIR_NAME}
cd ${DIR_NAME}
sudo docker run --rm teddysun/xray:1.8.3 xray x25519 > keys.txt
PRIV_KEY=$(cat keys.txt | grep -Po '^Private key:\s*\K.*$')
SHORT_ID=$(openssl rand -hex 8)
echo "Short ID: ${SHORT_ID}" >> keys.txt
sed -i 's/${SERVER}/'"${SERVER}/g" xray/config.json
sed -i 's/${ID}/'"${ID}/g" xray/config.json
sed -i 's/${PRIV_KEY}/'"${PRIV_KEY}/g" xray/config.json
sed -i 's/${SHORT_ID}/'"${SHORT_ID}/g" xray/config.json
sudo docker compose up -d