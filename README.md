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

- <font color=red>当前版本：1.1.1 </font>



### 2. Demo快速体验 

- **克隆/下载本项目到本地，进入Demo目录，在此目录中打开终端，然后执行 ```pod install``` 下载第三方依赖库。**
- 确保已在容联服务端开通并申请了一键登录服务，获取到了相应的appId（即子账号）。 
- 替换 **_ArgsDefine.h_** 文件中 **_APPID_** 宏的值为申请的appId（即子账号），并确保 appId（即子账号） 和 bundleID 相对应。
- 如只是调起授权界面，则进行上面的修改即可。如果想验证是否能登录成功，则需要自行完善 **NetworkManager.m** 中的以下方法： 

  - requestMobileLoginQuery: token: completion: 
  - requestMobileVerify: token: mobile: completion: 
- 或者根据您的服务器请求自行编写
- demo包含的功能：一键登录、号码验证、手机号验证码登录（v1.1.0新增）





### 3. 接入SDK配置、接口说明、授权界面设计、常见问题、返回码等

详见 [说明文档](./Document/OnekeyLogin_iOS_README.pdf)





### 4. 版本历史

#### v1.1.1

- 解决一个SDK偶现崩溃

#### v1.1.0

- 修复获取SIM卡失败的bug
- Demo增加手机号验证码登录界面
- 增加一些SDK错误码，一些log调整

#### v1.0.6

- 统一三网运营商授权界面未勾选弹窗

#### v1.0.5

- 增加客户端的状态码；授权界面可配置项与Android统一；
- 第三方登录添加Apple登录(去掉新浪微博)；

#### v1.0.3

- 集成三网运营商一键登录&号码验证功能

