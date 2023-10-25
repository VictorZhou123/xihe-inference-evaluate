FROM openeuler/openeuler:23.03 as BUILDER
RUN dnf update -y && \
    dnf install -y golang && \
    go env -w GOPROXY=https://goproxy.cn,direct
# build binary
COPY . /go/src/github.com/opensourceways/xihe-inference-evaluate
RUN cd /go/src/github.com/opensourceways/xihe-inference-evaluate && GO111MODULE=on CGO_ENABLED=0 go build -buildmode=pie --ldflags "-s -linkmode 'external' -extldflags '-Wl,-z,now'"

# copy binary config and utils
FROM openeuler/openeuler:22.03
RUN dnf -y update && \
    dnf in -y shadow && \
    groupadd -g 5000 mindspore && \
    useradd -u 5000 -g mindspore -s /bin/bash -m mindspore

USER mindspore
WORKDIR /opt/app/

COPY  --chown=mindspore ./template ./template
COPY  --chown=mindspore --from=BUILDER /go/src/github.com/opensourceways/xihe-inference-evaluate/xihe-inference-evaluate /opt/app

RUN chmod 750 ./template && \
    for file in ./template/*; do if [ -f "$file" ]; then chmod 640 "$file"; fi; done
RUN chmod 550 /opt/app/xihe-inference-evaluate

ENTRYPOINT ["/opt/app/xihe-inference-evaluate"]
