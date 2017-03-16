FROM resin/rpi-raspbian:jessie

RUN apt-get update
RUN apt-get install wget sed iptables openvpn

WORKDIR /tmp
RUN wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.0-rc2/EasyRSA-3.0.0-rc2.tgz

RUN mkdir -p /etc/openvpn/ovpn
ADD ./template/template.ovpn /etc/openvpn/ovpn/template.ovpn
ADD ./conf/server.conf /etc/openvpn/server.conf
RUN cp -ar /etc/openvpn /tmp/

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

RUN sed -ien "s/.*net\.ipv4\.ip_forward.*$/net.ipv4.ip_forward = 1/g" /etc/sysctl.conf

EXPOSE 1194/udp
EXPOSE 443/tcp

VOLUME ["/etc/openvpn", "/usr/local/EasyRSA"]

CMD ["ovpn_run"]
