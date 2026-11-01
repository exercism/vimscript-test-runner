FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

ARG VADER_REV=429b669e6158be3a9fc110799607c232e6ed8e29

RUN apk add --no-cache bash git jq vim \
    && git clone --revision="$VADER_REV" --depth=1 https://github.com/junegunn/vader.vim.git /opt/vader.vim \
    && rm -rf /opt/vader.vim/.git

COPY . /opt/test-runner
WORKDIR /opt/test-runner

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
