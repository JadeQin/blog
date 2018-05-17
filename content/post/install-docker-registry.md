---
title: "安装Docker Registry"
date: 2015-06-11T15:07:59+08:00
---


# 镜像库搭建

docker在pull镜像的时候，默认是从docker.io的公共库里面去获取，一个是受限于网络，另一个是不便于公司内部使用，因此需要搭建自己的内部镜像库。
有两种方式

> 安装二进制包
```
yum install docker-registry
```

> 直接使用基于Docker的registry镜像
```
docker run -d -e SETTINGS_FLAVOR=dev -e STORAGE_PATH=/tmp/registry -v  ~/docker-registry/registry:/tmp/registry  -p 5000:5000 registry
```
这样会在`~/docker-registry/registry`下存放自己的镜像内容，同时开放5000端口供外部访问。

为了便于管理镜像，还可以安装一个公开的registry的管理界面，基于registry v1接口做的。
```
docker run -d
  -e ENV_DOCKER_REGISTRY_HOST=172.19.103.36
  -e ENV_DOCKER_REGISTRY_PORT=5000
  -p 8080:80
  konradkleine/docker-registry-frontend
```
这样可以很方便的查看镜像库里面的内容。

# 镜像库使用

Docker对于镜像地址的识别有点诡异，如果使用域名方式访问的时候，域名不能使用单个单词的方式，因为单个单词会被识别为docker.io上的Repositorie，必须要带`.`。

如果要把本地build的镜像上传到库里
```
docker push DOCKER_REGISTRY_HOST:DOCKER_REGISTRY_PORT/NAME
```

这样会导致本地使用的时候，镜像名字太长，所以可以本地对镜像打一个短名字的tag，方便使用
```
docker tag DOCKER_REGISTRY_HOST:DOCKER_REGISTRY_PORT/NAME SHORT_NAME
```

当要镜像库里面的镜像的时候
```
docker pull DOCKER_REGISTRY_HOST:DOCKER_REGISTRY_PORT/NAME
```
