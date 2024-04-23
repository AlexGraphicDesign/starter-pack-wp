#!/bin/bash

ln -snf /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo 'Europe/Paris' > /etc/timezone

chmod 644 /usr/local/share/ca-certificates/*.crt && update-ca-certificates

#On start Apache
source /etc/apache2/envvars
exec apache2 -D FOREGROUND
