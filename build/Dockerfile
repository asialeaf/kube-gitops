FROM alpine:3.14
LABEL maintainers="yeyazhou@harmonycloud.cn"
LABEL description="Base image,add git、kubectl、curl"
# ENV
ENV TZ="Asia/Shanghai"

# Copy from build directory
COPY ../cmd/gitops.sh /gitops.sh

# Update && Add toolsß
RUN apk add --update -t deps git curl \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone  \
    && apk del tzdata

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.22.10/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl

RUN apk del --purge deps \
  && rm /var/cache/apk/*

# Define default command
#ENTRYPOINT [""]

# Run the executable
