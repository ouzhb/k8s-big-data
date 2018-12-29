# 关于容器化ES的资料

## Docker安装

```bash
docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.5.4
```
## Helm

Helm项目下可以找到多个ES相关Helm包(均在stable目录下)：

|组件|说明|
|----|----|
|[stable](https://github.com/helm/charts/tree/master/stable/elasticsearch)|只部署ES|
|[ELK](https://github.com/helm/charts/tree/master/stable/elastic-stack)|包括elasticsearch、kibana、logstash在内的整套日志解决方案。|
|[Elasticsearch Curator](https://github.com/helm/charts/tree/master/incubator/elasticsearch-curator)|Curator是ES的Index管理工具|
|[Elasticsearch Exporter](https://github.com/helm/charts/tree/master/stable/elasticsearch-exporter)|这个Chart主要用来向Prometheus导入es的监控信息|
|[elastalert](https://github.com/helm/charts/tree/master/stable/elastalert)|用于告警的es中间件|
|[Elastabot](https://github.com/helm/charts/tree/master/stable/elastabot)|？？？母鸡到是干啥的|

### ES Chart

- 当前由于在容器环境中jvm无法local内存，所以要求运行ES服务的物理机关闭内存。否者，大数据量时ES的性能会受到很大的影响。

- Chart 包含以下内容：

|资源名称|资源类型|说明|存储|
|-----|-----|-----|-----|
|rj-elasticsearch|ConfigMap|包含以下配置文件： elasticsearch.yml、log4j2.properties、pre-stop-hook.sh、post-start-hook.sh|
|rj-elasticsearch-master|StatefulSet|单个Node只会运行一个master容器。每个Master启动时会运行一系列initContainers，负责修改pod环境下的系统变量、修改环境变量等|/usr/share/elasticsearch/data目录使用共享存储|
|rj-elasticsearch-data|StatefulSet|单个Node只会运行一个data容器|Data和Master的结构类似，但是需要在生命周期中进行|
|rg-elasticsearch-client|Deployment|单个Node只会运行一个Client，||

## 参考：

[官方说明](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)

[官方镜像](https://www.docker.elastic.co/#)

[配置文件说明](https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html)

[JVM配置](https://www.elastic.co/guide/en/elasticsearch/reference/current/jvm-options.html)

[Logging配置](https://www.elastic.co/guide/en/elasticsearch/reference/current/logging.html#logging)

## ES的基本操作

```shell
# 当前节点、集群、版本等信息
curl -XGET 'http://elasticsearch-client.default.svc.cluster.local.:9200/_cluster/health?pretty'

# 创建Index
curl -XPUT 'http://elasticsearch-client.default.svc.cluster.local.:9200/testindex'

# 查看所有Index
curl -XGET 'http://elasticsearch-client.default.svc.cluster.local.:9200/_cat/indices?v'

# 插入Doc
curl -XPUT 'http://elasticsearch-client.default.svc.cluster.local.:9200/testindex/person/1'  -H "Content-Type: application/json"  -d '{"user": "张三", "title": "工程师", "desc": "数据库管理"}' 
curl -XPUT 'http://elasticsearch-client.default.svc.cluster.local.:9200/testindex/person/2'  -H "Content-Type: application/json"  -d '{"user": "李四", "title": "测试", "desc": "数据库管理"}' 
curl -XPUT 'http://elasticsearch-client.default.svc.cluster.local.:9200/testindex/person/3'  -H "Content-Type: application/json"  -d '{"user": "王五", "title": "产品", "desc": "数据库管理"}' 

# 查询Doc
curl -XPOST "http://elasticsearch-client.default.svc.cluster.local.:9200/testindex/person/_search?pretty" -H "Content-Type: application/json"  -d '{"query":{ "multi_match":{"query":"张三","fields":["user","desc"]}}}'

```