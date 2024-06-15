FROM alpine:3.19.1
RUN apk add --no-cache openssh && ssh-keygen -A
RUN apk add kubectl k9s

RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh && touch /root/.ssh/.dummy && chmod 0600 /root/.ssh/.dummy

ENTRYPOINT ["sh", "-c"]
CMD ["/usr/sbin/sshd -D -e -o LogLevel=VERBOSE -o PasswordAuthentication=no -o PermitRootLogin=yes -o AddressFamily=inet -o GatewayPorts=yes -o AllowAgentForwarding=yes -o AllowTcpForwarding=yes -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostkeyAlgorithms=+ssh-rsa"]
