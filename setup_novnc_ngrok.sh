#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Install ngrok
sudo wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
sudo unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/local/bin/
sudo rm ngrok-stable-linux-amd64.zip

# Create Dockerfile
echo "FROM dorowu/ubuntu-desktop-lxde-vnc\n\
RUN apt-get update && apt-get install -y novnc\n\
EXPOSE 8080\n\
CMD [\"bash\", \"-c\", \"Xtightvnc :1 -desktop VNC-1 -geometry 1280x720 -depth 24 -rfbauth /root/.vnc/passwd & novnc --listen 8080\"]" > Dockerfile

# Build Docker image
sudo docker build -t novnc-ngrok .

# Run Docker container
sudo docker run -d -p 127.0.0.1:5901:5901 -p 127.0.0.1:8080:8080 novnc-ngrok

# Authenticate ngrok
echo "Please enter your ngrok authentication token:"
read -r NGROK_AUTH_TOKEN
ngrok authtoken "$NGROK_AUTH_TOKEN"

# Create ngrok Tunnel
ngrok http 127.0.0.1:8080
