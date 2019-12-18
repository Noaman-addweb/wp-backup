#!/bin/bash

BKPDIR=/home/
WEBROOT=/home/

DBUSER=$(grep DB_USER $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBNAME=$(grep DB_NAME $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBPASSWORD=$(grep DB_PASSWORD $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBDUMP="$BKPDIR""$DBNAME"_$(date +"%Y-%m-%d-%H-%M").sql

mysqldump -u $DBUSER -p$DBPASSWORD $DBNAME > $DBDUMP

tar -czvf "$BKPDIR"wpbackup_$(date +"%Y-%m-%d").tar.gz $WEBROOT $DBDUMP


aws s3 cp "$BKPDIR"wpbackup_$(date +"%Y-%m-%d").tar.gz s3://bradleysfish.com/SiteBackupWithDB/

rm -rf "$BKPDIR"wpbackup_$(date +"%Y-%m-%d").tar.gz
