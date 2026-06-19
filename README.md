# Umbler_Desafio_linux_Paulo

Paulo Cesar santos De Jesus Junior

 README.md                        # Este arquivo
 parte1
    resolucao.md                 # Diagnóstico Nginx 502 + 3 causas + diferenciação por camada
               # Script bônus de health check

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

Dificuldades

No bonus tomei algum erro por reutilizar um arquivo yaml de estudo e tive que ir tratando com os requisitos, deixei registrado no log.

Se tivesse mais tempo adicionaria comentario em cada etapa dos scripts

adicionaria na parte2 para que o serviço do nginx e php-fpm ser iniciado quando falha ou estiver parado

Com tempo tambem fazeria um scripts em ansible com mais opção para criar vhost em varios hosts da frotas
