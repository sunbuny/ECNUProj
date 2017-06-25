# SpringCloud+Docker+Docker Comopose的微服务课程作业报告
## 成员：孙斌 蒋振斌 胡军 杨佩军
说明：由于能力有限，我们组作业是来自与github上的一个开源代码的修改。该项目为：https://github.com/ewolff/microservice.git。
## 第一部分 微服务构成
本项目中使用SpringCloud构建了三个微服务，构建了一个简单的网上商城。商城包含了用户注册功能，订单功能，商品浏览功能。这三个微服务分别是：


 - 用户服务 （microservice-demo-customer）
 - 商品目录服务 （microservice-demo-catalog ）
 - 订单处理服务 （microservice-demo-order ）

### 用户服务 （microservice-demo-customer）
用户服务用以提供添加/删除用户的功能。
### 商品目录服务 （microservice-demo-catalog ）
商品目录服务用以提供添加删除商品的功能。
### 订单处理服务 （microservice-demo-order ）
订单处理服务使用了microservice-demo-catalog和microservice-demo-customer。用来接受用户的订单并处理之。其中使用了Ribbon来做负载均衡，使用Hystrix作为熔断器。
## 第二部分 系统构成
系统由六个部分构成如下图所示：
![图片标题](https://github.com/sunbuny/ECNUProj/blob/master/pic/JIEGOU.png)
### API GATEWAY ZUUL
ZUUL作为系统的处理所有外部请求的前门，他是一个在云平台上提供动态路由的一个框架。它包含了对请求的路由和过滤两个功能，其中路由功能负责将外部请求转发到具体的微服务实例上，是实现外部访问统一入口的基础；而过滤器功能则负责对请求的处理过程进行干预，是实现请求校验、服务聚合等功能的基础。
也就是说用户的请求会被ZUUL转发到微服务实例上。
### RIBBON&HYSTRIX
值得注意的是本项目中的三个微服务均使用了Ribbon和Hystrix技术。Ribbon是一个基于HTTP和TCP客户端的负载均衡器。这里我们配置的ribbonServerList服务端列表去轮询访问以达到均衡负载的作用。
而Hystrix作为断路器。当某个服务单元发生故障（类似用电器发生短路）之后，通过断路器的故障监控（类似熔断保险丝），向调用方返回一个错误响应，而不是长时间的等待。这样就不会使得线程因调用故障服务被长时间占用不释放，避免了故障在分布式系统中的蔓延。
这两个工具提高了分布式微服务的鲁棒性。
### RUREKA
Eureka用来服务发现。它可以自动化的发现服务实例的网络地址。当微服务启动的时候，它会向Eureka服务器登录自己的信息。同时，Eureka也接收来自微服务的心跳包消息。
### TURBIN
每个有着断路器的微服务都会通过Spring Cloud总线向Turbine发送metrics消息。我们可以通过dashboard来实时的监控。
## 第三部分 运行
本项目可以编译运行和直接从dockerhub下载镜像运行。
### 编译运行：
从github clone这个项目后：
```
cd scripts
./createdemo.sh
```
这个脚本会自动创建一个本地的docker镜像。接下来运行：
```
cd docker
docker-compose up
```
就启动了本项目的所有微服务。
### dockerhub下载运行
在项目根目录下运行：
```
docker-compose up
```
这里docker-compose会读取在根目录下的docker-compose.yml，这个文件会告诉docker-compose去远端服务器下载我之前上传上去的docker镜像，并运行之。
### 访问
待docker-compose up 启动完成后。
打开浏览器访问http://127.0.0.1:8080/。可以看到整个项目的主页。
 - http://127.0.0.1:8761/是Eureka的dashboard主页
 - http://127.0.0.1:8989/hystrix 是turbine的主页
