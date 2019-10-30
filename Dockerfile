FROM golang:alpine as builder


RUN apk --no-cache add git libc-dev gcc
RUN go get github.com/mjibson/esc

RUN mkdir /go/src/github.com/mailslurper \
    && cd /go/src/github.com/mailslurper \
    && git clone https://github.com/mailslurper/mailslurper.git 

WORKDIR /go/src/github.com/mailslurper/mailslurper/cmd/mailslurper

RUN go get
RUN go generate
RUN go build

FROM alpine:3.6
LABEL maintainer="Alphyron <admin@dragon-labs.de>"

COPY --from=builder /go/src/github.com/mailslurper/mailslurper/cmd/mailslurper/mailslurper mailslurper
ADD config.json ./

EXPOSE 8080 8085 25

CMD ["./mailslurper"]
