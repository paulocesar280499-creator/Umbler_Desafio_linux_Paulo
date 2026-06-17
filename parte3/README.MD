#Parte 3 — Gerenciamento de Configuração com Puppet

## 1. Como organizar o manifest para garantir Nginx em toda a frota

A organização segue o padrão de módulo Puppet com separação de responsabilidades:

modules/
└── nginx/
    ├── manifests/
    │   ├── init.pp          # classe principal — ponto de entrada
    │   ├── install.pp       # garante pacote instalado
    │   ├── service.pp       # garante serviço ativo
    │   └── config.pp        # gerencia arquivos de configuração
    ├── templates/
    │   ├── nginx.conf.epp   # template da configuração principal
    │   └── vhost.conf.epp   # template de virtual host
    └── files/
        └── mime.types       # arquivo estático (não varia por nó)
```

**Separar em classes menores** tem duas vantagens práticas:
- cada classe pode ser testada e aplicada de forma independente
- facilita override por perfil de servidor (ex: um grupo pode incluir `nginx::install` mas usar `nginx::config` diferente)

**Fluxo de aplicação:**

site.pp (node classifier)
    └── include nginx
         ├── nginx::install  → package { 'nginx': ensure => installed }
         ├── nginx::config   → file { '/etc/nginx/nginx.conf': ... }


## 2. Como o Puppet garante idempotência

 A cada execução (agente roda a cada 30 minutos por padrão), ele:

1. Compila o catálogo no Puppet Server
2. Compara o estado atual do nó com o estado declarado
3. Aplica **apenas o que está diferente**

package { 'nginx':
  ensure => installed,
}


Se o Nginx já estiver instalado. Não chama o`apt-get install nginx` de novo.


service { 'nginx':
  ensure => running,
  enable => true,
}

Se o serviço já estiver ativo e habilitado. Não chama o systemctl restart nginx


file { '/etc/nginx/nginx.conf':
  ensure  => file,
  content => epp('nginx/nginx.conf.epp'),
}


Se o arquivo já tiver o conteúdo correto ele não gravar nada

**O que acontece se rodar duas vezes num servidor já configurado:

Entra a idempotência ele não adiciona nenhuma alteração

## 3. Como lidar com diferenças entre grupos de servidores

O Puppet resolve isso com Facts,Hiera,Roles e Profiles.
