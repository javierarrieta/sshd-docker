FROM alpine:3.20
RUN apk add --no-cache openssh
RUN apk add kubectl k9s openssl jq screen bash curl age sops

RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh

ENTRYPOINT ["sh", "-c"]
CMD ["/usr/sbin/sshd -D -e -o LogLevel=VERBOSE -o PasswordAuthentication=no -o PermitRootLogin=yes -o AddressFamily=inet -o GatewayPorts=yes -o AllowAgentForwarding=yes -o AllowTcpForwarding=yes -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostkeyAlgorithms=+ssh-rsa -o HostKey=/etc/ssh/hostKeys/ssh_host_dsa_key -o HostKey=/etc/ssh/hostKeys/ssh_host_ecdsa_key -o HostKey=/etc/ssh/hostKeys/ssh_host_ed25519_key  -o HostKey=/etc/ssh/hostKeys/ssh_host_rsa_key"]
