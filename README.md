# BikeDemo

![Xcode 10.0+](https://img.shields.io/badge/Xcode-10.0%2B-blue.svg)
![iOS 10.0+](https://img.shields.io/badge/iOS-10.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![License](https://img.shields.io/cocoapods/l/Hero.svg?style=flat)](https://github.com/lkzhao/Hero/blob/master/LICENSE?raw=true)

English | [简体中文](https://github.com/Mclarenyang/BikeDemo/blob/Layout/README_CHI.md)

## 1. Introduction
-----
### 1.1 Final Result (2Do)


### 1.2 Project Instruction
 This project is a native iOS app implementation that provides ride users with navigation, security, data and social travel apps. The main functions implemented are as follows:
1. Navigation module
    * Map
        * Map rendering options
        * Map point selection
        * Location inquiry
    * Cycling route planning
    * Navigation
2. Safety and instrument modules
    * display
        * Gradient speed dial
        * Speed, altitude, time and balance display (the maximum angle between the device screen and the horizontal plane)
    * Safety
        * Speed reminder
        * Fall detection and help SMS, phone trigger
    * Other
        * Extreme speed mode (does not trigger the function under the security directory)
        * Data record
3. Community module
    * Login to logout / registration
    * Homepage
    * Dynamically post, view, like, comment
    * Emergency SMS settings
    * Cycling data chart

 The project uses the iOS client as a sensing device, and the Matlab algorithm is combined with the iOS device test to generate a security threshold.

### 1.3 ToDo
- [x] UI layout
- [ ] Rewrite the servers code
- [ ] transmission encryption
- [ ] Iwatch + HealKit
- [ ] Hybrid branch

## 2.Technology stack
-----
Navigation
- [x] [Amap SDK](https://lbs.amap.com/)：Swift bridging Objective-C

Data interaction and storage
- [x] [SwiftyJson](https://github.com/SwiftyJSON/SwiftyJSON) 
- [x] [Alamofire](https://github.com/Alamofire/Alamofire) 
- [x] [Realm](https://github.com/realm/realm-cocoa) 

UI implementation
- [x] [TextFieldEffects](https://github.com/raulriera/TextFieldEffects) 
- [x] [Hero](https://github.com/HeroTransitions/Hero) 
- [x] [ScrollableGraphView](https://github.com/philackm/ScrollableGraphView) 

UI design
- [x] [Sketch](https://www.sketchapp.com/) 49.1

## 3.UI
-----
I have a limited level of UI. In the development and design process, I mainly refer to the excellent design works of the Dribbble community. Here I have provided me with inspiration or design reference works, and I would like to express my sincere gratitude to the designers and sharers.👍👏🙇‍♂️

| Design work | Designers |
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



