#!/bin/bash

htpasswd -b -c /usr/local/nagios/etc/htpasswd.users $NAGIOSADMIN_USER $NAGIOSADMIN_PASS

service apache2 restart
service nagios restart

sleep inf

