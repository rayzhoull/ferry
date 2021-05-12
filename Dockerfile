FROM golang:latest AS builder
WORKDIR /opt/ferry
COPY ./ ./
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOPROXY="https://goproxy.cn"
ENV GOARCH="amd64"
RUN go build -mod vendor -ldflags="-s -w" -o ./bin/ferry ./main.go


FROM alpine:latest

ENV TZ=Asia/Shanghai
RUN echo "http://mirrors.aliyun.com/alpine/v3.13/main/" > /etc/apk/repositories \
    && apk update \
    && apk --no-cache add tzdata zeromq \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo '$TZ' > /etc/timezone
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

WORKDIR /ferry
ENV VUE_APP_BASE_API=http://115.231.27.114:8002/
COPY --from=builder /opt/ferry/ ./
CMD ["./bin/ferry", "server"]
