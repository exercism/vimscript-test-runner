FROM alpine:3.23.2

RUN apk add --no-cache git bash jq vim && \
    rm -rf /var/cache/apk/*

RUN git clone https://github.com/junegunn/vader.vim.git /opt/test-runner/vader.vim

COPY . /opt/test-runner
WORKDIR /opt/test-runner

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
