FROM alpine:3.23.5@sha256:fd791d74b68913cbb027c6546007b3f0d3bc45125f797758156952bc2d6daf40

ARG VADER_REV=429b669e6158be3a9fc110799607c232e6ed8e29

RUN apk add --no-cache bash git jq vim \
    && git clone --revision="$VADER_REV" --depth=1 https://github.com/junegunn/vader.vim.git /opt/vader.vim \
    && rm -rf /opt/vader.vim/.git

COPY . /opt/test-runner
WORKDIR /opt/test-runner

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
