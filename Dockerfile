FROM rust:1.75-slim AS builder

ENV GITHUB_API_VERSION=2022-11-28
ARG STDLIB_VERSION=1.9.0
ENV STDLIB_VERSION=${STDLIB_VERSION}
ENV STDLIB_URL=https://api.github.com/repos/aiken-lang/stdlib/tarball/${STDLIB_VERSION}
ARG AIKEN_VERSION=1.1.5

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    tar \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN cargo install aiken --version ${AIKEN_VERSION}

WORKDIR /app

RUN curl -fSL \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: ${GITHUB_API_VERSION}" \
    "${STDLIB_URL}" \
    -o stdlib.tar

RUN mkdir -p stdlib && \
    tar -xvf stdlib.tar --strip-components 1 -C stdlib && \
    rm stdlib.tar

FROM python:3.11-slim

WORKDIR /app/stdlib

COPY --from=builder /usr/local/cargo/bin/aiken /usr/local/bin/aiken
COPY --from=builder /app/stdlib /app/stdlib
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

CMD ["/entrypoint.sh"]
