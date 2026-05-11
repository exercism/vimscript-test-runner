FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

RUN apk add --no-cache git bash jq vim && \
    rm -rf /var/cache/apk/*

RUN git clone https://github.com/junegunn/vader.vim.git /opt/test-runner/vader.vim

COPY . /opt/test-runner
WORKDIR /opt/test-runner

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
