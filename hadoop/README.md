# HADOOP On Kubernetes

运行在Kubernetes上的Hadoop版本，基于Apache Hadoop 2.7.7 。

当前仅仅支持运行集群hdfs，单机hdfs或yarn占时不支持运行。

该Helm安装包设计参考该项目：[kubernetes-HDFS](https://github.com/apache-spark-on-k8s/kubernetes-HDFS)

## 架构

Helm 包运行后包含以下对象：

|名称|类型|备注|
|----|----|----|
|hdfs-namenode|StatefulSet|固定运行在1、2节点，使用主机网络，持久化元数据目录|
|hdfs-datanode|DaemonSet|主机网络，持久化元数据目录|
|hdfs-journalnode|StatefulSet|固定运行在1、2、3节点，使用容器网络，持久化数据目录|
|hdfs-client|Deployment|HDFS客户端工具|
|hdfs-namenode-svc|Service|headless Service 暴露8020、50070端口|
|hdfs-journalnode-svc|Service|headless Service 暴露8485、8480端口|
|hdfs-namenode-scripts|ConfigMap|NN启动控制脚本|
|hdfs-datanode-scripts|ConfigMap|DN保活脚本|
|hdfs-config|ConfigMap|core-site.xml、hdfs-site.xml配置文件|
|hdfs-namenode-pdb/hdfs-journalnode-pdb|PodDisruptionBudget|可选暂时不配置|

## Docker Image

基础镜像基于centos:7.5.1804镜像内只包含Hadoop-2.7.7、JDK-1.8以及基础环境变量。

镜像内的环境变量包括：

|KEY|VALUE|
|----|---|
|JAVA_HOME|/usr/java/default|
|JRE_HOME| $JAVA_HOME/jre|
|CLASSPATH| .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib|
|HADOOP_HOME| /usr/local/hadoop|
|HADOOP_PREFIX| $HADOOP_HOME|
|PATH| $PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin|

## 数据持久化

由于平台缺少共享存储，目前元数据信息保存在本地目录下（通过volumes，而非pv/pvc）。这样的设计使namenode、journalnode被固定在指定节点运行（比如namenode被固定在1、2节点运行）。

当前版本namenode、journalnode均通过StatefulSet实现。后续平台提供共享存储后，计划使用pv/pvc申请存储资源。


## Roles启动控制
所有脚本通过ConfigMap挂载到Pod中。
### NameNode
NameNode通过/nn-scripts/format-and-run.sh启动NN，启动逻辑如下：
```yaml
NN-0 初次启动时，完成以下工作：
- 格式化metadata
- 格式化Zookeeper目录

NN-1 初次启动时，完成以下工作：
- 格式化metadata

所有NN启动时，完成以下工作：
- 启动zkfc
- 启动nn进程
```

### JouralNode

JournalNode通过以下命令启动roles：
```bash
$HADOOP_PREFIX/bin/hdfs --config /etc/hadoop journalnode
```
PS：NameNode启动时需要连接JournalNode，因此JournalNode需要比NameNode先启动，但是Kubernetes的机制无法保证这一点。所以安装时可能出现nn容器重启的情况，请不要担心不会影响使用！

### DataNode
DataNode通过以下命令启动roles：
```bash
$HADOOP_PREFIX/bin/hdfs --config /etc/hadoop datanode
```

## 配置文件

通过ConfigMap以只读的方式挂载到容器，包括core-site.xml，hdfs-site.xml。

当其他容器需要连接HDFS时，需要挂载ConfigMap到/etc/hadoop目录，并且配置环境变量HADOOP_CONF_DIR=/etc/hadoop


## 其他设计

### 环境变量

|Key|Value|
|----|----|
|HADOOP_CONF_DIR|/etc/hadoop|
|HADOOP_HOME|/usr/local/hadoop|
|HADOOP_PREFIX|$HADOOP_HOME|

### 目录挂载

|Role|容器内|容器外|备注|
|----|----|----|----|
|所有POD|/dn-scripts|ConfigMap：hdfs-config||
|NN|/nn-scripts|ConfigMap：hdfs-namenode-scripts||
|DN|/dn-scripts|ConfigMap：hdfs-datanode-scripts||
|NN|/hadoop/dfs/name|/ibnsdata/hadoop-k8s/dfs/nn||
|DN|hdfs-data-0|/ibnsdata/hadoop-k8s/dfs/hdfs-data-0||
|JN|/hadoop/dfs/journal|/ibnsdata/hadoop-k8s/dfs/jn|

### 容器CPU & Mem

默认场景下HDFS的Java 堆区内存为1000m，通过环境变量HADOOP_HEAPSIZE，在hadoop-env.sh中配置。

因此在Kubernetes中pod的resources请求应该大于hadoop-env.sh中配置的值（建议应该预留30%，尤其是NN）

HDFS对CPU不是强需求，因此配置500m即可。

### 排除宿主机成为DN节点
|功能点|实现|备注|
|----|----|----|
|排除宿主机成为DN节点|为DN添加key=hdfs-datanode-exclude的标签|如果驱逐一个已经部署了DN的NN，那么需要加label后手工删除pod|
