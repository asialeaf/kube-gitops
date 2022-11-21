FROM alpine:3.14
LABEL maintainers="yeyazhou@harmonycloud.cn"
LABEL description="Base image,add git、kubectl、curl"
# ENV
ENV TZ="Asia/Shanghai"

# Copy from build directory
COPY /cmd/gitops.sh /gitops.sh

# Update Repo
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Update && Add tools
RUN set -x \
    && apk update \
    && apk add --no-cache \
    bash bash-doc bash-completion \
    curl git busybox-extras \
    tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone  \
    && apk del tzdata \
    && /bin/rm -rf /tmp/* /var/cache/apk/*

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.22.10/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && chmod +x /gitops.sh

# Define default command
#ENTRYPOINT [""]

# Run the executable