#!/bin/bash

FILE=/etc/lucee/web/.cfconfig.json
if [ -f $FILE ]; then
    box cfconfig import from=$FILE to=/opt/lucee/web/ toFormat=luceeWeb@5.2
fi

FILE=/etc/lucee/server/.cfconfig.json
if [ -f $FILE ]; then
    box cfconfig import from=$FILE to=/opt/lucee/server/lucee-server/context/ toFormat=luceeServer@5.2
fi

if [ -n "$LUCEE_ADMIN" ]; then
    mv /etc/nginx/location.d/deny_lucee_admin.conf /etc/nginx/location.d/deny_lucee_admin.conf.off
fi

# Start supervisord and services
exec supervisord -n -c /etc/supervisor/supervisord.conf
# tail -f /dev/null