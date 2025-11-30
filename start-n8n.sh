#!/bin/sh

if [ "$(docker ps -q -f name=n8n)" ]; then
    echo "n8n is already running"
else
    if [ "$(docker ps -aq -f status=exited -f name=n8n)" ]; then
        docker start n8n
    else
        docker volume create n8n_data
        sudo docker run -d  -it  \
            --restart unless-stopped  \
            --name n8n \
            --hostname n8n.abdullah-khwahir.me \
            -e WEBHOOK_URL=https://n8n.abdullah-khwahir.me \
            -e N8N_HOST=n8n.abdullah-khwahir.me \
            -e N8N_PORT=5678 \
            -e N8N_PROTOCOL=https \
            -e WEBHOOK_TUNNEL_URL=https://n8n.abdullah-khwahir.me/ \
            -e N8N_EDITOR_BASE_URL=https://n8n.abdullah-khwahir.me/ \
            -e VUE_APP_URL_BASE_API=https://n8n.abdullah-khwahir.me/ \
            -p 5678:5678 \
            -e GENERIC_TIMEZONE="Asia/Riyadh" \
            -e TZ="Asia/Riyadh" \
            -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
            -e N8N_RUNNERS_ENABLED=true \
            -e N8N_METRICS=true \
            -v n8n_data:/home/node/.n8n \
            docker.n8n.io/n8nio/n8n

    fi
fi
