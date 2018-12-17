# Spark1.6 On Kubernetes

在Kubernetes上以Standalone集群方式运行Spark 1.6.3。

该Chart主要针对 Spark1.6 版本的任务对于Spark 2.3即以上版本，请参考Spark官方Kubernetes调度方案，以及其他开源Spark Operator。

## Chart

Chart 包安装后包含以下Kubernetes对象。

|对象|类型|说明|备注|
|----|----|----|----|
|spark-master|StatefulSet|单点Master|状态信息存放在Zookeeper中|
|spark-worker|Deployment|工作节点||
|spark-jobhistory|Deployment|日志服务|依赖HDFS|
|spark-master|Service|7077端口代理||
|spark-webui|Service|master webui 代理||

##  备注

- Master：http://{IP}:32030/
- 日志目录：{{ .Values.localdir }}/logs
