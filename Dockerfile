FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

ARG VADER_REV=429b669e6158be3a9fc110799607c232e6ed8e29

RUN apk add --no-cache bash git jq vim \
    && git clone --revision="$VADER_REV" --depth=1 https://github.com/junegunn/vader.vim.git /opt/vader.vim \
    && rm -rf /opt/vader.vim/.git

COPY . /opt/test-runner
WORKDIR /opt/test-runner

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
