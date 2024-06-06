#!/bin/bash

# Diretório de saída
OUTPUT_DIR="/srv/nfs/guilherme"

# Nome do serviço
SERVICE_NAME="httpd"

# Data e Hora atuais
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Verificar status do serviço
if systemctl is-active --quiet $SERVICE_NAME; then
    STATUS="ONLINE"
    MESSAGE="$CURRENT_DATE - $SERVICE_NAME - Status: ONLINE - O serviço está em execução."
    echo "$MESSAGE" > "$OUTPUT_DIR/servico_online.txt"
else
    STATUS="OFFLINE"
    MESSAGE="$CURRENT_DATE - $SERVICE_NAME - Status: OFFLINE - O serviço não está em execução."
    echo "$MESSAGE" > "$OUTPUT_DIR/servico_offline.txt"
fi

