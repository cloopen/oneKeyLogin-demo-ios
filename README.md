# 容联云·一键登录iOS_Demo

此项目为容联云一键登录功能的体验Demo，其中包含 号码一键登录 和 号码验证功能。



### 1. 概述

**容联云一键登录SDK 为移动应用提供完善的三网（移动、联通、电信）一键登录&号码验证功能开发框架，屏蔽其** 

**内部复杂细节，对外提供较为简洁的 API 接口，方便第三方应用快速集成一键登录功能。** 

<font color=red>注意事项: </font>

- <font color=red>网络取号时候请务必开启手机蜂窝网络 </font>

- <font color=red>1.  电信只支持4G网络取号 </font>
  <font color=red>2.  移动, 联通支持4G, 3G, 2G网络取号，但在非4G网络情况下容易取号失败 </font>

- <font color=red>针对双卡双待手机只取当前流量卡号</font>

- <font color=red>SDK包含一键登录和本机号码校验两个不同的功能，使用场景不一样，无需一起使用。 </font>

- <font color=red>当前版本：1.0.6 </font>



### 2. Demo快速体验 

- **克隆/下载本项目到本地，进入Demo目录，在此目录中打开终端，然后执行 ```pod install``` 下载第三方依赖库。**

- 确保已在容联服务端开通并申请了一键登录服务，获取到了相应的appID。 

- 替换 **_ArgsDefine.h_** 文件中 **_APPID_** 宏的值为申请的appID，并确保 appID 和 bundleID 相对应。

- 如只是调起授权界面，则进行上面的修改即可。如果想验证是否能登录成功，则需要自行完善 **NetworkManager.m** 中的以下方法： 

  - requestMobileLoginQuery: token: completion: 
  - requestMobileVerify: token: mobile: completion: 

- 或者根据您的服务器请求自行编写





### 接入SDK配置、接口说明、授权界面设计、常见问题、返回码等

### 详见 [说明文档](./Document/OnekeyLogin_iOS_README.pdf)

