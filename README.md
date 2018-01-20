# nagios
Added speedtest-cli (https://github.com/sivel/speedtest-cli) to jasonrivers/nagios, so I can use speedtest-cli plugin (https://exchange.nagios.org/directory/Plugins/Network-Connections%2C-Stats-and-Bandwidth/check_speedtest-2Dcli/details)

I run with (obviously most of the options come from jasonrivers/nagios image

    docker run \
       -d \
       --restart=unless-stopped \
       --name nagios \
       -p 9280:80 \
       -v ${PWD}/etc/:/opt/nagios/etc/ \
       -v ${PWD}/graph_etc/:/opt/nagiosgraph/etc/ \
       -v ${PWD}/extra.d.${HOSTNAME}/:/opt/nagios/etc/extra.d/ \
       -v ${PWD}/custom-plugins:/opt/Custom-Nagios-Plugins/ \
       -v /mnt/docker/data/nagios/${HOSTNAME}/var/:/opt/nagios/var/ \
       -v /mnt/docker/data/nagios/${HOSTNAME}/rrd/:/opt/nagiosgraph/var/rrd \
       -e NAGIOSADMIN_USER="nagiosadmin" \
       -e NAGIOSADMIN_PASS="nagiospassword" \
       -e MAIL_RELAY_HOST="email.home" \
       martinjohn/nagios:latest
