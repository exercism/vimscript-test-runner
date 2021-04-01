FROM python:3.7-slim

RUN apt-get update && \
    apt-get install -y git jq vim-gtk && \
    apt-get purge --auto-remove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/junegunn/vader.vim.git /opt/test-runner/vader.vim

COPY . /opt/test-runner
WORKDIR /opt/test-runner

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
