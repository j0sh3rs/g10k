FROM golang:1.22-alpine as builder
WORKDIR /usr/src/g10k
COPY . /usr/src/g10k
RUN apk add --no-cache gcc make musl-dev git openssh bash && \
    make g10k

FROM puppet/r10k:3.15.2
COPY --from=builder /usr/src/g10k/g10k /usr/bin/
COPY Dockerfile /Dockerfile
LABEL org.label-schema.maintainer="Josh Simmonds <github@beholdthehurricane.com>" \
      org.label-schema.vendor="Captain Caveman" \
      org.label-schema.url="https://github.com/j0sh3rs/g10k" \
      org.label-schema.name="g10k" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.vcs-url="https://github.com/j0sh3rs/g10k" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/Dockerfile"
WORKDIR /code
USER root
RUN apk add --no-cache git openssh bash
USER puppet
ENTRYPOINT [ "/usr/bin/g10k" ]
CMD ["-help"]
