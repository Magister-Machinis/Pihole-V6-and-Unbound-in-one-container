ARG VERSION
FROM pihole/pihole:${VERSION}
RUN apk add unbound wget
COPY unbound.conf /etc/unbound.conf.d/unbound.conf
RUN mkdir -p /var/log/unbound && touch /var/log/unbound/unbound.log && mkdir -p /backup && mkdir -p /conf && mkdir -p /var/lib/unbound/ && mkdir -p /backup
RUN wget https://www.internic.net/domain/named.root -qO /var/lib/unbound/root.hints

ENTRYPOINT [ "sh", "-c", "unbound -vv -c /etc/unbound.conf.d/unbound.conf && start.sh" ]
