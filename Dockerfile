FROM golang:1-alpine AS builder

RUN apk update && apk --no-cache add build-base git

ENV GO111MODULE=off

RUN go get github.com/GeertJohan/go.rice/rice
RUN go get github.com/prologic/shorturl
RUN cd /go/src/github.com/prologic/shorturl && \
    rice embed-go && \
    go build -trimpath -ldflags "-s -w -buildid="

FROM alpine

ENV GOPATH=/go
WORKDIR /go/src/github.com/prologic/shorturl
COPY --from=builder /go/bin/shorturl /usr/local/bin/shorturl
COPY --from=builder /go/src/github.com/prologic/shorturl/static ./static
COPY --from=builder /go/src/github.com/prologic/shorturl/templates ./templates

WORKDIR /data
EXPOSE 8000

CMD ["/usr/local/bin/shorturl", "-dbpath", "/data/urls.db"]
