# Umbler_Desafio_linux_Paulo

Paulo Cesar santos De Jesus Junior

 README.md                        # Este arquivo
 parte1
    resolucao.md                 # Diagnóstico Nginx 502 + 3 causas + diferenciação por camada
     checagem.sh              # Script bônus de health check

 parte2
   cria_vhost.sh             # Script de criação de ambiente de hospedagem

 parte3
   resolucao.md                 # Puppet — organização, idempotência, manifest completo

 parte4
   resolucao.md                 # Email/Exim — logs, DNS, blacklists, comunicação
   
 diferencial
   optionA
docker-compose.yml       # Nginx + PHP-FPM + MariaDB
app
index.php            # phpinfo() + teste de conexão com DB
docker
nginx
default.conf   # Configuração do Nginx
php
Dockerfile       # PHP-FPM com extensões MySQL
  optionB

deploy.yml               # GitHub Actions CI/CD pipeline
