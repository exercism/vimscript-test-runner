FROM alpine:3.23.5@sha256:fd791d74b68913cbb027c6546007b3f0d3bc45125f797758156952bc2d6daf40

RUN apk add --no-cache git bash jq vim && \
    rm -rf /var/cache/apk/*

RUN git clone https://github.com/junegunn/vader.vim.git /opt/test-runner/vader.vim

COPY . /opt/test-runner
WORKDIR /opt/test-runner

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
