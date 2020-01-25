ARG TAG=3.10

FROM alpine:$TAG as nweb
ADD ./nweb24.c /nweb24.c
RUN apk add --update --no-cache gcc libc-dev \
    && cc -O2 nweb24.c -o nweb

FROM alpine:$TAG
WORKDIR /app
COPY --from=nweb /nweb /sbin/nweb
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD wget --quiet --tries=1 --no-check-certificate --spider \
  http://localhost:80 || exit 1
CMD ["nweb", "80", "/app"]