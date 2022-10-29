#!/bin/bash
echo "Type the domain names with www"
read -p "Please type old domain: " OLDDOMAIN
read -p "Please type a new domain: " NEWDOMAIN
read -p "Please enter database name: " dbname

mysql $dbname <<EOFMYSQL

-- categories
UPDATE cats SET site=CONCAT(site,',$NEWDOMAIN') WHERE site LIKE '%$OLDDOMAIN%'
-- products
UPDATE products SET site=CONCAT(site,',$NEWDOMAIN') WHERE site LIKE '%$OLDDOMAIN%'
-- prices
UPDATE prices SET site=CONCAT(site,',$NEWDOMAIN') WHERE site LIKE '%$OLDDOMAIN%';

-- links
UPDATE titles SET rule=REPLACE(rule,'$OLDDOMAIN','$NEWDOMAIN')
-- replace in page
UPDATE `titles` SET Page=REPLACE(Page,'$OLDDOMAIN','$NEWDOMAIN')

UPDATE `titles` SET title=REPLACE(title,'$OLDDOMAIN','$NEWDOMAIN')
UPDATE `titles` SET Description=REPLACE(Description,'$OLDDOMAIN','$NEWDOMAIN')
UPDATE `titles` SET Keywords=REPLACE(Keywords,'$OLDDOMAIN','$NEWDOMAIN')

-- fix links in products
UPDATE `products` SET ShortDesc=REPLACE(ShortDesc,'$OLDDOMAIN','$NEWDOMAIN')
UPDATE `products` SET FullDesc=REPLACE(FullDesc,'$OLDDOMAIN','$NEWDOMAIN')

EOFMYSQL
	

#template corection
find /var/www/html/$NEWDOMAIN/ -type f -exec sed -i 's/$OLDDOMAIN/${NEWDOMAIN}/g' {} +

#delete cashe
rm -rf /var/www/html/$NEWDOMAIN/swap/*.php
rm -rf /var/www/html/$NEWDOMAIN/swap/en/*.php
rm -rf /var/www/html/$NEWDOMAIN/swap/fr/*.php
rm -rf /var/www/html/$NEWDOMAIN/swap/sp/*.php
rm -rf /var/www/html/$NEWDOMAIN/swap/de/*.php
rm -rf /var/www/html/$NEWDOMAIN/swap/uk/*.php