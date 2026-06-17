#!/bin/bash

set -e

DOMAIN="$1"

if [ -z "$DOMAIN" ]; then
    echo "Uso: $0 dominio.com"
    exit 1
fi

# Remove caracteres inválidos para criar usuário Linux
USER="cliente_$(echo "$DOMAIN" | sed 's/\..*$//' | tr '-' '_')"

HOME_DIR="/home/$USER"
WEB_DIR="$HOME_DIR/public_html"
NGINX_AVAILABLE="/etc/nginx/sites-available/$DOMAIN"
NGINX_ENABLED="/etc/nginx/sites-enabled/$DOMAIN"
LOG_FILE="/var/log/hosting_setup.log"

log() {
    echo "$(date '+%F %T') - $1" | tee -a "$LOG_FILE"
}

log "Iniciando criação do ambiente para $DOMAIN"

# Criar usuário se não existir
if id "$USER" &>/dev/null; then
    log "Usuário $USER já existe."
else
    useradd -m -s /bin/bash "$USER"
    log "Usuário $USER criado."
fi

# Criar estrutura de diretórios
mkdir -p "$WEB_DIR"

# Ajustar permissões
chown -R "$USER:$USER" "$HOME_DIR"
chmod 755 "$HOME_DIR"
chmod 755 "$WEB_DIR"

log "Estrutura de diretórios criada."

# Criar página inicial caso não exista
if [ ! -f "$WEB_DIR/index.html" ]; then
    cat > "$WEB_DIR/index.html" <<EOF
<html>
<head><title>$DOMAIN</title></head>
<body>
<h1>Site $DOMAIN criado com sucesso!</h1>
</body>
</html>
EOF

    chown "$USER:$USER" "$WEB_DIR/index.html"
fi

# Criar Virtual Host do Nginx
if [ ! -f "$NGINX_AVAILABLE" ]; then
    cat > "$NGINX_AVAILABLE" <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    root $WEB_DIR;
    index index.php index.html;

    access_log /var/log/nginx/${DOMAIN}_access.log;
    error_log  /var/log/nginx/${DOMAIN}_error.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

    log "Virtual Host criado."
else
    log "Virtual Host já existe."
fi

# Habilitar site
if [ ! -L "$NGINX_ENABLED" ]; then
    ln -s "$NGINX_AVAILABLE" "$NGINX_ENABLED"
    log "Site habilitado."
fi

# Validar configuração
if nginx -t >> "$LOG_FILE" 2>&1; then
    systemctl reload nginx
    log "Nginx validado e recarregado."
else
    log "ERRO: Configuração inválida do Nginx."
    exit 1
fi

log "Provisionamento finalizado com sucesso."
