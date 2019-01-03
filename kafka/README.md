# Kafka Helm

## Kubernetes资源

参考GitHub上[Yolean](https://github.com/Yolean/kubernetes-kafka)的Kafka on Kubernetes,在原有功能上进行了相关精简。

该项目下的 Kafka 设计不以 Helm 作为打包发布工具，而是直接通过 yaml 文件发布。

chart/incubator 目录下提供了 Helm 包版本。

## 参考文档

[Configuration](http://kafka.apache.org/11/documentation.html)

|配置项|说明|备注|
|-----|-----|-----|
|listeners|Broker 用来创建 socket 进程的地址| 对于复杂的环境，如果Kafka需要区分内外网络。那么可能需要配置 listeners、advertised.listeners 、listener.security.protocol.map |
|advertised.listeners|暴露给Client使用地址，Client从Zookeeper上得到地址即是该地址|advertised.listeners不指定时，使用listeners值作为默认值|