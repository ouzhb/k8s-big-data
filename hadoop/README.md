# HADOOP On Kubernetes

运行在Kubernetes上的Hadoop版本，基于Apache Hadoop 2.7.2 。

当前指支持运行hdfs，并且只能运行集群HDFS。

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

# Docker Image

基础镜像基于centos:7.5.1804， 镜像内的环境变量包括：

|KEY|VALUE|
|----|---|
|JAVA_HOME|/usr/java/default|
|JRE_HOME| $JAVA_HOME/jre|
|CLASSPATH| .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib|
|HADOOP_HOME| /usr/local/hadoop|
|HADOOP_PREFIX| $HADOOP_HOME|
|PATH| $PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin|

# 启动脚本
所有脚本通过ConfigMap挂载到Pod中，通过python命令运行。
## NN 启动控制脚本
NN-0 初次启动时，完成以下工作：
- 格式化metadata
- 格式化Zookeeper目录

NN-1 初次启动时，完成以下工作：
- 格式化metadata

所有NN启动时，完成以下工作：
- 启动zkfc
- 启动nn进程

## DN 状态监控脚本
参考使用 http://localhost:50075/jmx?qry=Hadoop:service=DataNode,name=DataNodeInfo 获取DN的状态信息
# 配置文件

通过ConfigMap以只读的方式挂载到容器，包括core-site.xml，hdfs-site.xml。

需要提取到helm中独立配置参数：

|KEY|VALUE|
|----|---|
|ha.zookeeper.quorum|zk地址|
|dfs.datanode.data.dir|考虑后续可能不止一块硬盘，目录可能有多个|

# 存储
除DN外，所有状态数据使用PVC申请存储。

当环境无共享存储时，使用本地目录作为PV后端，并且使用Kubernetes的亲和性将NN、JN的Pod固定在指定节点。

后续提供共享存储后，考虑将元数据放在共享存储上。