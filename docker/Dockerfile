FROM alpine:latest
LABEL maintainer "Bartek Antoniak <antoniaklja@gmail.com>"

EXPOSE 5182/udp

RUN apk add -U wireguard-tools bash iptables linux-headers --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY add_peer.sh /add_peer.sh
RUN chmod +x /add_peer.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["wg"]