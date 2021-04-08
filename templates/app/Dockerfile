FROM golang:latest

MAINTAINER Eric Wagner <eric@attict.net>


COPY ./server/*.go ./
COPY ./server/core_module ./core_module
COPY ./server/dnd_module ./dnd_module
COPY ./server/public ./public
COPY ./server/templates ./templates
COPY ./server/styles ./styles
COPY ./server/images ./images

RUN go get -v -d . && go build -o /main *.go
CMD ["/main"]

