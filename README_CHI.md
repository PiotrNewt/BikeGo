# BikeDemo
一个自行车导航 iOS App，提供安全导航功能

![Xcode 10.0+](https://img.shields.io/badge/Xcode-10.0%2B-blue.svg)
![iOS 10.0+](https://img.shields.io/badge/iOS-10.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![License](https://img.shields.io/cocoapods/l/Hero.svg?style=flat)](https://github.com/lkzhao/Hero/blob/master/LICENSE?raw=true)

[English](https://github.com/Mclarenyang/BikeDemo/blob/Layout/README.md) | 简体中文

## 1. 介绍
---
### 1.1 最终效果（未录制）


### 1.2 项目说明
&emsp;本项目是一个原生iOS App实现，提供给骑行用户集导航、安全、数据和社交于一身的出行App。主要实现的功能如下：
1. 导航功能模块
    * 地图
        * 地图渲染选择
        * 地图选点
        * 地点查询
    * 骑行路线规划
    * 导航
2. 安全及仪表功能模块
    * 显示
        * 渐变色速度表盘
        * 速度、海拔、用时及平衡显示（设备屏幕向上时与水平面最大夹角）
    * 安全
        * 超速提醒
        * 摔倒检测及求助短信、电话触发
    * 其他 
        * 极速模式（不触发安全目录下功能）
        * 数据记录
3. 社区功能模块
    * 登陆登出/注册
    * 个人主页
    * 动态发表、查看、点赞、评论
    * 应急短信设置
    * 骑行数据图表

&emsp;项目使用iOS客户端作为传感设备，自设Matlab算法组合iOS设备测试产生安全阈值。

### 1.3 ToDo
- [x] UI布局
- [ ] 重写后台代码
- [ ] 传输加密
- [ ] Iwatch + HealKit
- [ ] Hybrid分支

## 2.技术栈
---
地图导航
- [x] [高德导航SDK](https://lbs.amap.com/)：Swift桥接Objective-C

数据交互及存储
- [x] [SwiftyJson](https://github.com/SwiftyJSON/SwiftyJSON) 解析库
- [x] [Alamofire](https://github.com/Alamofire/Alamofire) 网络请求库
- [x] [Realm](https://github.com/realm/realm-cocoa) 数据库

UI实现
- [x] [TextFieldEffects](https://github.com/raulriera/TextFieldEffects) 文本框库
- [x] [Hero](https://github.com/HeroTransitions/Hero) 过渡动画库
- [x] [ScrollableGraphView](https://github.com/philackm/ScrollableGraphView) 数据图表

UI设计
- [x] 静态原型：[Sketch](https://www.sketchapp.com/) 49.1

## 3.UI
---
&emsp;本人UI水平有限，在开发及设计过程中主要参照Dribbble社区优秀的设计作品，在此罗列给我提供了灵感或者设计参照的作品，并对设计者与分享者表达由衷的感谢。👍👏🙇‍♂️

| 作品 | 作者 |
|:---:|:------:|
|[Bike Assembly](https://dribbble.com/shots/1774057-Bike-Assembly)|Fraser Davidson|
|[Bike History](https://dribbble.com/shots/2656218-Bike-History)|Levani Ambokadze|
|[Navigation app - Night mode](https://dribbble.com/shots/3814971-Navigation-app-Night-mode)|Adrian Reznicek|
|[iPhone X - Todo Concept](https://dribbble.com/shots/3812962-iPhone-X-Todo-Concept)|Jae-seong, Jeong|
|[Add friends mascots](https://dribbble.com/shots/3677804-Add-friends-mascots)|Prakhar Neel Sharma|
|[Day 001 - Login Form](https://dribbble.com/shots/2125879-Day-001-Login-Form)|Paul Flavius Nechita|
|[Logo concept versions for Scooptrack / Search engine (unused)](https://dribbble.com/shots/3850614-Logo-concept-versions-for-Scooptrack-Search-engine-unused)| Vadim Carazan |
|[For the love of wine // Sauvignon Blanc](https://dribbble.com/shots/1735510-For-the-love-of-wine-Sauvignon-Blanc)|Studio–JQ|
|[GPS Speed for Android Wear](https://dribbble.com/shots/2099528-GPS-Speed-for-Android-Wear)|Alty|
|[Server iOS Screens](https://dribbble.com/shots/2032069-Server-iOS-Screens)|⋈ Sam Thibault ⋈|
|[Statistics (General trends)](https://dribbble.com/shots/1719845-Statistics-General-trends)| Mike / Creative Mints|



