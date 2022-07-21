# kube-gitops

指定GitSource地址，自动clone仓库，并使用kubectl应用k8s yaml



#### 功能说明

kube-gitops主要提供业务Pod容器，需将构建好的镜像地址需和kube-httpserver中创建Pod时的Image地址一致

#### 构建镜像

1. 使用`docker build`打包镜像

   ```shell
   cd build
   cp ../cmd/gitops.sh ./
   docker build -t kubectl:v1.0 .  #此处镜像名为kubectl:v1.0，如需修改，需同时修改kube-httpserver pkg/core/pod/pod.go 中Image
   ```

2. 上传镜像至镜像仓库

   ```shell
   docker push kubectl:v1.0       #如上传至私有仓库，需注意和kube-httpserver pkg/core/pod/pod.go 中Image保持一致，以防拉取不到镜像
   ```

   