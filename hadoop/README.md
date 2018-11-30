# HADOOP On Kubernetes

运行在Kubernetes上的Hadoop版本，基于Apache Hadoop 2.7.2 。

当前指支持运行hdfs。

# 架构

Helm 包运行后包含以下对象：

|名称|类型|备注|
|----|----|----|
|hdfs-namenode|StatefulSet|主机网络，元数据存放在PV上，考虑集群环境PV可以是共享存储、或者本地存储|
|hdfs-datanode|DaemonSet|主机网络，数据存放在本地磁盘上|
|hdfs-journalnode|StatefulSet|元数据的存放参考nn|
|hdfs-client|Deployment|HDFS客户端工具|
|hdfs-namenode-svc|Service|headless Service 暴露8020、50070端口|
|hdfs-journalnode-svc|Service|headless Service 暴露8485、8480端口|
|hdfs-namenode-scripts|ConfigMap|NN启动控制脚本|
|hdfs-datanode-scripts|ConfigMap|DN保活脚本|
|hdfs-config|ConfigMap|core-site.xml、hdfs-site.xml配置文件|
|hdfs-namenode-pdb/hdfs-journalnode-pdb|PodDisruptionBudget|可选暂时不配置|


