FROM golang:1.10-alpine

ARG VERSION=498b9eecd5

RUN apk add --update git vim curl wget gcc g++ bash musl-dev linux-headers

RUN mkdir -p $GOPATH/src/github.com/ethereum && \
    cd $GOPATH/src/github.com/ethereum && \
    git clone https://github.com/ethersphere/go-ethereum && \
    cd $GOPATH/src/github.com/ethereum/go-ethereum && \
    git checkout ${VERSION} && \
    go get github.com/ethereum/go-ethereum && \
    go get . && go get ./cmd/geth && go get ./cmd/swarm && \
    cd $GOPATH/src/github.com/ethereum/go-ethereum && \
    go install -ldflags "-X main.gitCommit=${VERSION}" ./cmd/swarm && \
    go install -ldflags "-X main.gitCommit=${VERSION}" ./cmd/geth && \
    go install ./cmd/bootnode && \
    cp $GOPATH/bin/swarm /swarm && cp $GOPATH/bin/geth /geth && cp $GOPATH/bin/bootnode /bootnode && \
    apk del git go make gcc musl-dev g++ libc-dev && \
    rm -rf $GOPATH && rm -rf /var/cache/apk/*

ADD run.sh /run.sh
RUN chmod a+x /*.sh

ENTRYPOINT ["/run.sh"]
