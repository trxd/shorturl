FROM golang:1-alpine AS builder

WORKDIR ${GOPATH}/src/github.com/prologic/shorturl

RUN apk --no-cache -U add build-base git; \
    git clone https://github.com/prologic/shorturl.git .; \
    make build; \
    mv shorturl /go/bin/

FROM alpine

WORKDIR /data

COPY --from=builder /go/bin/shorturl /usr/local/bin/shorturl

EXPOSE 8000

CMD ["/usr/local/bin/shorturl", "-dbpath", "/data/urls.db"]
