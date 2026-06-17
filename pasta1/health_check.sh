#!/bin/bash

LOG="/var/log/health_check.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

log_msg() {
    echo "[$DATE] $1" | tee -a "$LOG"
}

log_msg "===== Iniciando Health Check ====="

# Verifica Nginx
if systemctl is-active --quiet nginx; then
    log_msg "OK: Nginx está ativo."
else
    log_msg "ALERTA: Nginx está parado."
fi

# Verifica PHP-FPM
if systemctl is-active --quiet php8.4-fpm; then
    log_msg "OK: PHP-FPM está ativo."
else
    log_msg "ALERTA: PHP-FPM está parado."
fi

# Testa configuração do Nginx
if nginx -t >/dev/null 2>&1; then
    log_msg "OK: Configuração do Nginx válida."
else
    log_msg "ERRO: Configuração do Nginx inválida."
fi

# Verifica se a porta 80 está escutando
if ss -lnt | grep -q ":80 "; then
    log_msg "OK: Porta 80 em escuta."
else
    log_msg "ALERTA: Porta 80 não está em escuta."
fi

# Verifica socket do PHP-FPM
if [ -S /run/php/php8.4-fpm.sock ]; then
    log_msg "OK: Socket do PHP-FPM encontrado."
else
    log_msg "ALERTA: Socket do PHP-FPM não encontrado."
fi

# Testa resposta HTTP local
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

if [ "$HTTP_CODE" = "200" ]; then
    log_msg "OK: Site respondeu HTTP 200."
else
    log_msg "ALERTA: Site respondeu HTTP $HTTP_CODE."
fi

log_msg "===== Fim do Health Check ====="
