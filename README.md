# Wordpress LEMP Script Install

Untuk menginstal Wordpress dengan LEMP stack pada Ubuntu 20.04 LTS dengan HTTPS (SSL).

## Command untuk Ubuntu 20.04 LTS
Setelah SSH kepada server, run command di bawah:
```shell
cd /tmp
wget https://raw.githubusercontent.com/chronz/shiny-guacamole/main/wp-lemp-https-install-u20.04-v1.0.3.sh
chmod +x wp-lemp-https-install-u20.04-v1.0.3.sh
sudo ./wp-lemp-https-install-u20.04-v1.0.3.sh
```

## Versi non-HTTPS
Jika menginginkan instalasi Wordpress tanpa HTTPS atau Cloudflare bukalah halaman berikut
[Halaman Release](https://github.com/chronz/shiny-guacamole/releases/tag/v1.0.2)
[Ubuntu 20.04 LTS - HTTP](https://github.com/chronz/shiny-guacamole/releases/download/v1.0.2/wp-lemp-install-u20.04-v1.0.2.sh)
[Ubuntu 22.04 LTS - HTTP](https://github.com/chronz/shiny-guacamole/releases/download/v1.0.2/wp-lemp-install-u22.04-v1.0.2.sh)
