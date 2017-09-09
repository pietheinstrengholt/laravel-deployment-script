# Laravel 5 deployment scripts

### deploy.sh

The deploy.sh is a script I use in many projects to quickly bring down, pull and deploy the latest code.

### htaccess

The htaccess included contains a nice redirect so that the website url always has www and https

### letsencrypt

To rerun letsencrypt:

```
/opt/letsencrypt/letsencrypt-auto certonly --webroot -w /var/www/html -d example.org -d www.example.org --agree-tos
```

### httpd.conf

Add the following to the /etc/httpd/conf/httpd.conf when using letsencrypt:

```
<VirtualHost *:443>
    ServerName www.meet-alex.org
    DocumentRoot "/var/www/html/public"
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/example.org/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/example.org/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/example.org/fullchain.pem
    SSLProtocol All -SSLv2 -SSLv3
    SSLHonorCipherOrder on
    SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA !RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS"
</VirtualHost>
```