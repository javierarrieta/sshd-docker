FROM alpine:3.23.2

RUN apk add --no-cache openssh
# --no-cache added here: the first RUN had it, this one did not, so the apk
# index was left behind in the layer for no reason.
RUN apk add --no-cache \
    kubectl \
    k9s \
    openssl \
    jq \
    screen \
    bash \
    curl \
    age \
    sops \
    postgresql18-client \
    ncurses \
    bind-tools \
    nmap \
    nmap-scripts

RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh

# The sshd options used to be a chain of `-o` flags inside the CMD string, which
# nobody could review. They now live in sshd_config.
COPY sshd_config /etc/ssh/sshd_config

# Fail the BUILD rather than crashloop a WAN-exposed pod. `sshd -t` refuses to
# pass unless at least one host key loads (verified: rc=1 with none, rc=0 with
# them present), and the real host keys are mounted at runtime, so generate
# throwaways purely to satisfy the check.
RUN mkdir -p /run/sshd /tmp/hostkeycheck \
 && for k in ed25519 ecdsa rsa; do \
      ssh-keygen -q -t "$k" -f "/tmp/hostkeycheck/ssh_host_${k}_key" -N ''; \
    done \
 && sed 's|/etc/ssh/hostKeys|/tmp/hostkeycheck|' /etc/ssh/sshd_config \
      > /tmp/hostkeycheck/sshd_config \
 && sshd -t -f /tmp/hostkeycheck/sshd_config \
 && rm -rf /tmp/hostkeycheck

# ENTRYPOINT ["sh","-c"] is upstream's design (testcontainers/sshd-docker): it
# lets a consumer override CMD with an arbitrary shell command. Kept as-is.
ENTRYPOINT ["sh", "-c"]
CMD ["/usr/sbin/sshd -D -e -f /etc/ssh/sshd_config"]
