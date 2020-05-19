FROM debian:10

RUN apt update && apt install -y logrotate cron

VOLUME ["/etc/logrotate.d"]

ENTRYPOINT chown root:root /etc/logrotate.d/* && cron -f
