
Docker-compose example:

.. code-block::

    version: '2.4'
    services:

      nginx:
        restart: always
        image: "nginx"
        volumes:
          - ./conf/nginx/conf.d:/etc/nginx/conf.d:ro
          - ./conf/nginx/ssl:/etc/nginx/ssl:ro
          - ./data/nginx/log/:/var/log/nginx/
        ports:
          - "80:80"
          - "443:443"
        command: [ 'nginx-debug', '-g', 'daemon off;']

      logrotate:
        build: https://github.com/Nekmo/docker-logrotate.git
        volumes:
          - "/var/run/docker.sock:/var/run/docker.sock"
          - "/usr/bin/docker:/usr/bin/docker:ro"
          - "./conf/logrotate:/etc/logrotate.d"
          - "./data/nginx/log/:/var/log/nginx/"

Nginx *logrotate* configuration example (put in ``./conf/logrotate/nginx``):

.. code-block::

    /var/log/nginx/*log {
        daily
        rotate 30
        missingok
        notifempty
        sharedscripts
        compress
        delaycompress
        postrotate
            docker kill -s USR1 <nginx container name> >/dev/null 2>&1
        endscript
    }


