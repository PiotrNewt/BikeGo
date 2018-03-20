//
//  AMapNaviCommonObj.h
//  AMapNaviKit
//
//  Created by AutoNavi on 14-7-1.
//  Copyright (c) 2014年 Amap. All rights reserved.
//

#import <UIKit/UIKit.h>

///AMapNavi的错误Domain
extern NSString * const AMapNaviErrorDomain;

///AMapNavi的错误信息
typedef NS_ENUM(NSInteger, AMapNaviError)
{
    AMapNaviUnknowError = -1,                   ///< 未知错误
    AMapNaviErrorNoGPSPermission = -2,          ///< 没有GPS权限
};

///导航模式
typedef NS_ENUM(NSInteger, AMapNaviMode)
{
    AMapNaviModeNone = 0,                       ///< 没有开始导航
    AMapNaviModeGPS,                            ///< GPS导航
    AMapNaviModeEmulator,                       ///< 模拟导航
};

///导航界面跟随模式
typedef NS_ENUM(NSInteger, AMapNaviViewTrackingMode)
{
    AMapNaviViewTrackingModeMapNorth = 0,      ///< 0 地图朝北
    AMapNaviViewTrackingModeCarNorth,          ///< 1 车头朝北
};

///驾车路径规划策略
typedef NS_ENUM(NSInteger, AMapNaviDrivingStrategy)
{
    AMapNaviDrivingStrategySingleDefault = 0,                               ///< 0 单路径: 默认,速度优先(常规最快)
    AMapNaviDrivingStrategySingleAvoidCost = 1,                             ///< 1 单路径: 避免收费
    AMapNaviDrivingStrategySinglePrioritiseDistance = 2,                    ///< 2 单路径: 距离优先
    AMapNaviDrivingStrategySingleAvoidExpressway = 3,                       ///< 3 单路径: 不走快速路
    AMapNaviDrivingStrategySingleAvoidCongestion = 4,                       ///< 4 单路径: 躲避拥堵
    AMapNaviDrivingStrategySingleAvoidHighway = 6,                          ///< 6 单路径: 不走高速
    AMapNaviDrivingStrategySingleAvoidHighwayAndCost = 7,                   ///< 7 单路径: 不走高速 & 避免收费
    AMapNaviDrivingStrategySingleAvoidCostAndCongestion = 8,                ///< 8 单路径: 避免收费 & 躲避拥堵
    AMapNaviDrivingStrategySingleAvoidHighwayAndCostAndCongestion = 9,      ///< 9 单路径: 不走高速 & 避免收费 & 躲避拥堵
    
    AMapNaviDrivingStrategyMultipleDefault = 10,                            ///< 10 多路径: 默认,速度优先(常规最快)
    AMapNaviDrivingStrategyMultipleAvoidCongestion = 12,                    ///< 12 多路径: 躲避拥堵
    AMapNaviDrivingStrategyMultipleAvoidHighway = 13,                       ///< 13 多路径: 不走高速
    AMapNaviDrivingStrategyMultipleAvoidCost = 14,                          ///< 14 多路径: 避免收费
    AMapNaviDrivingStrategyMultipleAvoidHighwayAndCongestion = 15,          ///< 15 多路径: 不走高速 & 躲避拥堵
    AMapNaviDrivingStrategyMultipleAvoidHighwayAndCost = 16,                ///< 16 多路径: 不走高速 & 避免收费
    AMapNaviDrivingStrategyMultipleAvoidCostAndCongestion = 17,             ///< 17 多路径: 避免收费 & 躲避拥堵
    AMapNaviDrivingStrategyMultipleAvoidHighwayAndCostAndCongestion = 18,   ///< 18 多路径: 不走高速 & 避免收费 & 躲避拥堵
    AMapNaviDrivingStrategyMultiplePrioritiseHighway = 19,                  ///< 19 多路径: 高速优先
    AMapNaviDrivingStrategyMultiplePrioritiseHighwayAvoidCongestion = 20,   ///< 20 多路径: 高速优先 & 躲避拥堵
    
    ///Deprecated
    AMapNaviDrivingStrategyDefault __attribute__ ((deprecated("use AMapNaviDrivingStrategySingleDefault instead"))) = AMapNaviDrivingStrategySingleDefault ,
    AMapNaviDrivingStrategySaveMoney __attribute__ ((deprecated("use AMapNaviDrivingStrategySingleAvoidCost instead"))) = AMapNaviDrivingStrategySingleAvoidCost,
    AMapNaviDrivingStrategyShortDistance __attribute__ ((deprecated("use AMapNaviDrivingStrategySinglePrioritiseDistance instead"))) = AMapNaviDrivingStrategySinglePrioritiseDistance,
    AMapNaviDrivingStrategyNoExpressways __attribute__ ((deprecated("use AMapNaviDrivingStrategySingleAvoidExpressway instead"))) = AMapNaviDrivingStrategySingleAvoidExpressway,
    AMapNaviDrivingStrategyFastestTime __attribute__ ((deprecated("use AMapNaviDrivingStrategySingleAvoidCongestion instead"))) = AMapNaviDrivingStrategySingleAvoidCongestion,
    AMapNaviDrivingStrategyDefaultAndFastest __attribute__ ((deprecated("use AMapNaviDrivingStrategyMultipleAvoidCongestion instead"))) = AMapNaviDrivingStrategyMultipleAvoidCongestion,
    AMapNaviDrivingStrategyDefaultAndShort __attribute__ ((deprecated("use AMapNaviDrivingStrategyMultipleDefault instead"))) = AMapNaviDrivingStrategyMultipleDefault,
    AMapNaviDrivingStrategyAvoidCongestion __attribute__ ((deprecated("use AMapNaviDrivingStrategySingleAvoidCostAndCongestion instead"))) = AMapNaviDrivingStrategySingleAvoidCostAndCongestion,
    AMapNaviDrivingStrategyDefaultAndFastestAndShort __attribute__ ((deprecated("use AMapNaviDrivingStrategyMultipleAvoidCongestion instead"))) = AMapNaviDrivingStrategyMultipleAvoidCongestion,
};

///路径计算状态
typedef NS_ENUM(NSInteger, AMapNaviCalcRouteState)
{
    AMapNaviCalcRouteStateEnvFailed = 0,                ///< 0 环境初始化错误
    AMapNaviCalcRouteStateSucceed = 1,                  ///< 1 路径计算成功
    AMapNaviCalcRouteStateNetworkError = 2,             ///< 2 网络失败
    AMapNaviCalcRouteStateParamInvalid = AMapNaviCalcRouteStateNetworkError,///< 2 Push数据包含无效参数、不合理参数
    AMapNaviCalcRouteStateStartPointError = 3,          ///< 3 起点错误
    AMapNaviCalcRouteStateProtocolError = 4,            ///< 4 协议解析错误
    AMapNaviCalcRouteStateCallCenterError = 5,          ///< 5 呼叫中心错误
    AMapNaviCalcRouteStateEndPointError = 6,            ///< 6 终点错误
    AMapNaviCalcRouteStateEncodeFalse = 7,              ///< 7 服务端编码错误
    AMapNaviCalcRouteStateLackPreview = 8,              ///< 8 数据缺乏预览数据
    AMapNaviCalcRouteStateDataBufError = 9,             ///< 9 数据格式错误
    AMapNaviCalcRouteStateStartRouteError = 10,         ///< 10 没有找到通向起点的道路
    AMapNaviCalcRouteStateEndRouteError = 11,           ///< 11 没有找到通向终点的道路
    AMapNaviCalcRouteStatePassRouteError = 12,          ///< 12 没有找到通向途经点的道路
    AMapNaviCalcRouteStateRouteFail = 13,               ///< 13 算路失败（未知错误）
    AMapNaviCalcRouteStateDistanceTooLong = 19,         ///< 19 起点/终点/途经点的距离太长(距离＞6000km)
    AMapNaviCalcRouteStatePassPointError = 21,          ///< 21 途经点错误
    AMapNaviCalcRouteStateForbid = 100,                 ///< 100 Push数据操作执行时机不当
    
};

///导航段转向图标类型
typedef NS_ENUM(NSInteger, AMapNaviIconType)
{
    AMapNaviIconTypeNone = 0,                       ///< 0 无定义
    AMapNaviIconTypeDefault,                        ///< 1 车图标
    AMapNaviIconTypeLeft,                           ///< 2 左转图标
    AMapNaviIconTypeRight,                          ///< 3 右转图标
    AMapNaviIconTypeLeftFront,                      ///< 4 左前方图标
    AMapNaviIconTypeRightFront,                     ///< 5 右前方图标
    AMapNaviIconTypeLeftBack,                       ///< 6 左后方图标
    AMapNaviIconTypeRightBack,                      ///< 7 右后方图标
    AMapNaviIconTypeLeftAndAround,                  ///< 8 左转掉头图标
    AMapNaviIconTypeStraight,                       ///< 9 直行图标
    AMapNaviIconTypeArrivedWayPoint,                ///< 10 到达途经点图标
    AMapNaviIconTypeEnterRoundabout,                ///< 11 进入环岛图标
    AMapNaviIconTypeOutRoundabout,                  ///< 12 驶出环岛图标
    AMapNaviIconTypeArrivedServiceArea,             ///< 13 到达服务区图标
    AMapNaviIconTypeArrivedTollGate,                ///< 14 到达收费站图标
    AMapNaviIconTypeArrivedDestination,             ///< 15 到达目的地图标
    AMapNaviIconTypeArrivedTunnel,                  ///< 16 进入隧道图标
    AMapNaviIconTypeEntryLeftRing,                  ///< 17 进入环岛图标，左侧通行地区的顺时针环岛
    AMapNaviIconTypeLeaveLeftRing,                  ///< 18 驶出环岛图标，左侧通行地区的顺时针环岛
    AMapNaviIconTypeUTurnRight,                     ///< 19 右转掉头图标，左侧通行地区的掉头
    AMapNaviIconTypeSpecialContinue,                ///< 20 顺行图标(和直行有区别，顺行图标带有虚线)
    AMapNaviIconTypeEntryRingLeft,                  ///< 21 标准小环岛 绕环岛左转，右侧通行地区的逆时针环岛
    AMapNaviIconTypeEntryRingRight,                 ///< 22 标准小环岛 绕环岛右转，右侧通行地区的逆时针环岛
    AMapNaviIconTypeEntryRingContinue,              ///< 23 标准小环岛 绕环岛直行，右侧通行地区的逆时针环岛
    AMapNaviIconTypeEntryRingUTurn,                 ///< 24 标准小环岛 绕环岛调头，右侧通行地区的逆时针环岛
    AMapNaviIconTypeEntryLeftRingLeft,              ///< 25 标准小环岛 绕环岛左转，左侧通行地区的顺时针环岛
    AMapNaviIconTypeEntryLeftRingRight,             ///< 26 标准小环岛 绕环岛右转，左侧通行地区的顺时针环岛
    AMapNaviIconTypeEntryLeftRingContinue,          ///< 27 标准小环岛 绕环岛直行，左侧通行地区的顺时针环岛
    AMapNaviIconTypeEntryLeftRingUTurn,             ///< 28 标准小环岛 绕环岛调头，左侧通行地区的顺时针环岛
    AMapNaviIconTypeCrosswalk,                      ///< 29 通过人行横道图标
    AMapNaviIconTypeFlyover,                        ///< 30 通过过街天桥图标
    AMapNaviIconTypeUnderpass,                      ///< 31 通过地下通道图标
    AMapNaviIconTypeSquare,                         ///< 32 通过广场图标
    AMapNaviIconTypePark,                           ///< 33 通过公园图标
    AMapNaviIconTypeStaircase,                      ///< 34 通过扶梯图标
    AMapNaviIconTypeLift,                           ///< 35 通过直梯图标
    AMapNaviIconTypeCableway,                       ///< 36 通过索道图标
    AMapNaviIconTypeOverheadPassage,                ///< 37 通过空中通道图标
    AMapNaviIconTypePassage,                        ///< 38 通过建筑物穿越通道图标
    AMapNaviIconTypeWalks,                          ///< 39 通过行人道路图标
    AMapNaviIconTypeCruises,                        ///< 40 通过游船路线图标
    AMapNaviIconTypeSightseeingbus,                 ///< 41 通过观光车路线图标
    AMapNaviIconTypeSlip,                           ///< 42 通过滑道图标
    AMapNaviIconTypeStair,                          ///< 43 通过阶梯图标
    AMapNaviIconTypeSlope,                          ///< 44 通过斜坡图标
    AMapNaviIconTypeBridge,                         ///< 45 通过桥图标
    AMapNaviIconTypeFerryboat,                      ///< 46 通过渡轮图标
    AMapNaviIconTypeSubway,                         ///< 47 通过地铁图标
    AMapNaviIconTypeEnterBuilding,                  ///< 48 进入建筑物图标
    AMapNaviIconTypeLeaveBuilding,                  ///< 49 离开建筑物图标
    AMapNaviIconTypeByElevator,                     ///< 50 电梯换层图标
    AMapNaviIconTypeByStair,                        ///< 51 楼梯换层图标
    AMapNaviIconTypeEscalator,                      ///< 52 扶梯换层图标
    AMapNaviIconTypeLowTrafficCross,                ///< 53 非导航段通过红绿灯路口图标
    AMapNaviIconTypeLowCross,                       ///< 54 非导航段通过普通路口图标
};

///导航播报类型. since 6.0.0 AMapNaviSoundType 只返回 AMapNaviSoundTypeDefault
typedef NS_ENUM(NSInteger, AMapNaviSoundType)
{
    AMapNaviSoundTypeDefault = -1,                  ///< 默认播报(导航播报)
};

///非导航状态电子眼播报类型
typedef NS_ENUM(NSInteger,AMapNaviDetectedMode)
{
    AMapNaviDetectedModeNone = 0,                   ///< 0 关闭所有
    AMapNaviDetectedModeCamera,                     ///< 1 仅电子眼
    AMapNaviDetectedModeSpecialRoad,                ///< 2 仅特殊道路设施
    AMapNaviDetectedModeCameraAndSpecialRoad,       ///< 3 电子眼和特殊道路设施
};

///AMapNaviLink的道路类型
typedef NS_ENUM(NSInteger, AMapNaviRoadClass)
{
    AMapNaviRoadClassHighWay = 0,                   ///< 0 高速公路
    AMapNaviRoadClassNationalRoad,                  ///< 1 国道
    AMapNaviRoadClassProvincialRoad,                ///< 2 省道
    AMapNaviRoadClassCountyRoad,                    ///< 3 县道
    AMapNaviRoadClassVillageRoad,                   ///< 4 乡公路
    AMapNaviRoadClassCountyInternalRoad,            ///< 5 县乡村内部道路
    AMapNaviRoadClassMainStreet,                    ///< 6 主要大街、城市快速道
    AMapNaviRoadClassMainRoad,                      ///< 7 主要道路
    AMapNaviRoadClassMinorRoad,                     ///< 8 次要道路
    AMapNaviRoadClassNormalRoad,                    ///< 9 普通道路
    AMapNaviRoadClassNotNaviRoad,                   ///< 10 非导航道路
};

///AMapNaviLink的主辅路信息
typedef NS_ENUM(NSInteger, AMapNaviFormWay)
{
    AMapNaviFormWayNone = -1,                       ///< -1 无效
    AMapNaviFormWayMainRoad = 1,                    ///<  1 主路
    AMapNaviFormWayInternalRoad,                    ///<  2 路口内部道路
    AMapNaviFormWayJCT,                             ///<  3 JCT道路
    AMapNaviFormWayRoundabout,                      ///<  4 环岛
    AMapNaviFormWayRestArea,                        ///<  5 服务区
    AMapNaviFormWayRamp,                            ///<  6 匝道
    AMapNaviFormWaySideRoad,                        ///<  7 辅路
    AMapNaviFormWayRampAndJCT,                      ///<  8 匝道与JCT
    AMapNaviFormWayExit,                            ///<  9 出口
    AMapNaviFormWayEntrance,                        ///< 10 入口
    AMapNaviFormWayTurnRightRoadA,                  ///< 11 A类右转专用道
    AMapNaviFormWayTurnRightRoadB,                  ///< 12 B类右转专用道
    AMapNaviFormWayTurnLeftRoadA,                   ///< 13 A类左转专用道
    AMapNaviFormWayTurnLeftRoadB,                   ///< 14 B类左转专用道
    AMapNaviFormWayNormalRoad,                      ///< 15 普通道路
    AMapNaviFormWayTurnLeftAndRightRoad,            ///< 16 左右转专用道
    AMapNaviFormWayRestAreaAndJCT = 53,             ///< 53 服务区与JCT
    AMapNaviFormWayRestAreaAndRamp = 56,            ///< 56 服务区与匝道
    AMapNaviFormWayRestAreaRampJCT = 58,            ///< 58 服务区与匝道以及JCT
};

///电子眼类型
typedef NS_ENUM(NSInteger, AMapNaviCameraType)
{
    AMapNaviCameraTypeSpeed = 0,                        //!< 0 测速摄像
    AMapNaviCameraTypeSurveillance = 1,                 //!< 1 监控摄像
    AMapNaviCameraTypeTrafficLight = 2,                 //!< 2 闯红灯拍照
    AMapNaviCameraTypeBreakRule = 3,                    //!< 3 违章拍照
    AMapNaviCameraTypeBusway = 4,                       //!< 4 公交专用道摄像头
    AMapNaviCameraTypeEmergencyLane = 5,                //!< 5 应急车道摄像头
    AMapNaviCameraTypeIntervalVelocityStart = 8,        //!< 8 区间测速起始
    AMapNaviCameraTypeIntervalVelocityEnd = 9,          //!< 9 区间测速终止
};

///播报模式
typedef NS_ENUM(NSInteger, AMapNaviBroadcastMode)
{
    AMapNaviBroadcastModeConcise = 1,               ///< 1 经典简洁播报(建议老司机使用)
    AMapNaviBroadcastModeDetailed,                  ///< 2 新手详细播报
};

///道路状态
typedef NS_ENUM(NSInteger, AMapNaviRouteStatus)
{
    AMapNaviRouteStatusUnknow = 0,                  ///< 0 未知状态
    AMapNaviRouteStatusSmooth,                      ///< 1 通畅
    AMapNaviRouteStatusSlow,                        ///< 2 缓行
    AMapNaviRouteStatusJam,                         ///< 3 阻塞
    AMapNaviRouteStatusSeriousJam,                  ///< 4 严重阻塞
};

///路径规划时POI点的起终点类型
typedef NS_ENUM(NSInteger, AMapNaviRoutePlanPOIType)
{
    AMapNaviRoutePlanPOITypeStart = 0,              ///< 0 起点
    AMapNaviRoutePlanPOITypeEnd,                    ///< 1 终点
    AMapNaviRoutePlanPOITypeWay,                    ///< 2 途径点
};

///可切换到的平行路类型 since 5.3.0
typedef NS_ENUM(NSInteger, AMapNaviParallelRoadStatusFlag)
{
    AMapNaviParallelRoadStatusFlagNone = 0,         ///< 0 无主辅路可切换
    AMapNaviParallelRoadStatusFlagAssist = 1,       ///< 1 可切换到辅路
    AMapNaviParallelRoadStatusFlagMain = 2,         ///< 2 可切换到主路
};

///导航组件主题皮肤类型 since 5.4.0
typedef NS_ENUM(NSInteger, AMapNaviCompositeThemeType)
{
    AMapNaviCompositeThemeTypeDefault = 0,          ///< 0 蓝色系
    AMapNaviCompositeThemeTypeLight = 1,            ///< 1 浅色系
    AMapNaviCompositeThemeTypeDark = 2,             ///< 2 暗色系
};

///导航过程中提示音的类型 since 5.4.0
typedef NS_ENUM(NSInteger, AMapNaviRingType)
{
    AMapNaviRingTypeNULL = 0,                       ///< 0 无
    AMapNaviRingTypeReroute = 1,                    ///< 1 偏航重算的提示音
    AMapNaviRingTypeDing = 100,                     ///< 100 即将到达转向路口时的提示音
    AMapNaviRingTypeDong = 101,                     ///< 101 导航状态下通过测速电子眼的提示音
    AMapNaviRingTypeElecDing = 102,                 ///< 102 巡航状态下通过电子眼（所有类型）的提示音
};

///GPS信号强度类型 since 5.5.0
typedef NS_ENUM(NSInteger, AMapNaviGPSSignalStrength)
{
    AMapNaviGPSSignalStrengthUnknow = 0,    //0 信号强度未知
    AMapNaviGPSSignalStrengthStrong = 1,    //1 信号强
    AMapNaviGPSSignalStrengthWeak = 2,      //2 信号弱
};

///导航组件页面回退的动作类型 since 5.5.0
typedef NS_ENUM(NSInteger, AMapNaviCompositeVCBackwardActionType)
{
    AMapNaviCompositeVCBackwardActionTypeDismiss = 0,    //0 退出了整个导航组件
    AMapNaviCompositeVCBackwardActionTypeNaviPop = 1,    //1 退出了导航组件中的导航界面
};

///路径规划类型 since 5.5.0
typedef NS_ENUM(NSInteger, AMapNaviRoutePlanType)
{
    AMapNaviRoutePlanTypeYaw = 2,                   ///< 2 偏航重算
    AMapNaviRoutePlanTypeTMC = 5,                   ///< 5 躲避拥堵重算
};

///自车位置和区间测速电子眼路段的位置关系 since 6.0.0
typedef NS_ENUM(NSInteger, AMapNaviIntervalCameraPositionState)
{
    AMapNaviIntervalCameraPositionStateNULL = 0,         ///< 0 无
    AMapNaviIntervalCameraPositionStateReady = 1,        ///< 1 即将进入区间测速路段(还未进入)
    AMapNaviIntervalCameraPositionStateIn = 2,           ///< 2 在区间测速路段内
    AMapNaviIntervalCameraPositionStateOut = 3,          ///< 3 已离开区间测速路段（包括：已经过了测速路段终点 和 中途从区间中离开了）
};

///道路设施信息类型 since 6.0.0
typedef NS_ENUM(NSInteger, AMapNaviRoadFacilityType)
{
    AMapNaviRoadFacilityTypeNULL                = 0,        ///< 0 无
    AMapNaviRoadFacilityTypeLeftInterflow       = 1,        ///< 左侧合流
    AMapNaviRoadFacilityTypeRightInterflow      = 2,        ///< 右侧合流
    AMapNaviRoadFacilityTypeSharpTurn           = 3,        ///< 急转弯
    AMapNaviRoadFacilityTypeReverseTurn         = 4,        ///< 反向转弯
    AMapNaviRoadFacilityTypeLinkingTurn         = 5,        ///< 连续转弯
    AMapNaviRoadFacilityTypeAccidentArea        = 6,        ///< 事故多发地
    AMapNaviRoadFacilityTypeFallingRocks        = 7,        ///< 注意落石
    AMapNaviRoadFacilityTypeFailwayCross        = 8,        ///< 铁路道口
    AMapNaviRoadFacilityTypeSlippery            = 9,        ///< 易滑
    AMapNaviRoadFacilityTypeMaxSpeedLimit       = 10,       ///< 最大限速标志
    AMapNaviRoadFacilityTypeMinSpeedLimit       = 11,       ///< 最小限速标志
    AMapNaviRoadFacilityTypeVillage             = 12,       ///< 村庄
    AMapNaviRoadFacilityTypeLeftNarrow          = 13,       ///< 左侧变窄
    AMapNaviRoadFacilityTypeRightNarrow         = 14,       ///< 右侧变窄
    AMapNaviRoadFacilityTypeDoubleNarrow        = 15,       ///< 两侧变窄
    AMapNaviRoadFacilityTypeCrosswindArea       = 16,       ///< 横风区
    AMapNaviRoadFacilityTypeTruckHeightLimit    = 81,       ///< 货车限高
    AMapNaviRoadFacilityTypeTruckWidthLimit     = 82,       ///< 货车限宽
    AMapNaviRoadFacilityTypeTruckWeightLimit    = 83,       ///< 货车限重
    AMapNaviRoadFacilityTypeCheckPoint          = 91,       ///< 货车检查站
};

#pragma mark - LaneInfo Image

/**
 * @brief 创建车道信息图片
 * @param laneBackInfo 车道背景信息
 * @param laneSelectInfo 车道选择信息
 * @return 车道信息图片
 */
FOUNDATION_EXTERN UIImage *CreateLaneInfoImageWithLaneInfo(NSString *laneBackInfo, NSString *laneSelectInfo);

/**
 * @brief 将驾车路线规划的偏好设置转换为驾车路径规划策略.注意：当prioritiseHighway为YES时，将忽略avoidHighway和avoidCost的设置
 * @param multipleRoute 是否多路径规划
 * @param avoidCongestion 是否躲避拥堵
 * @param avoidHighway 是否不走高速
 * @param avoidCost 是否避免收费
 * @param prioritiseHighway 是否高速优先
 * @return AMapNaviDrivingStrategy路径规划策略
 */
FOUNDATION_EXTERN AMapNaviDrivingStrategy ConvertDrivingPreferenceToDrivingStrategy(BOOL multipleRoute,
                                                                                    BOOL avoidCongestion,
                                                                                    BOOL avoidHighway,
                                                                                    BOOL avoidCost,
                                                                                    BOOL prioritiseHighway);

#pragma mark - AMapNaviPoint

@interface AMapNaviPoint : NSObject<NSCopying,NSCoding>

///纬度
@property (nonatomic, assign) CGFloat latitude;

///经度
@property (nonatomic, assign) CGFloat longitude;

/**
 * @brief AMapNaviPoint类对象的初始化函数
 * @param lat 纬度
 * @param lon 经度
 * @return AMapNaviPoint类对象id
 */
+ (AMapNaviPoint *)locationWithLatitude:(CGFloat)lat longitude:(CGFloat)lon;

/**
 * @brief 判断点是否与当前点相同
 * @param aPoint 需要判断的点
 * @return 两个点是否相同
 */
- (BOOL)isEqualToNaviPoint:(AMapNaviPoint *)aPoint;

@end

#pragma mark - AMapNaviPointBounds

@interface AMapNaviPointBounds : NSObject<NSCopying,NSCoding>

///东北角坐标
@property (nonatomic, strong) AMapNaviPoint *northEast;

///西南角坐标
@property (nonatomic, strong) AMapNaviPoint *southWest;

/**
 * @brief AMapNaviPointBounds类对象的初始化函数
 * @param northEast 东北角经纬度
 * @param southWest 西南角经纬度
 * @return AMapNaviPointBounds类对象id
 */
+ (AMapNaviPointBounds *)pointBoundsWithNorthEast:(AMapNaviPoint *)northEast southWest:(AMapNaviPoint *)southWest;

@end

#pragma mark - AMapNaviGuide

///导航段信息类
@interface AMapNaviGuide : NSObject<NSCopying,NSCoding>

///导航段名称
@property (nonatomic, strong) NSString *name;

///导航段长度
@property (nonatomic, assign) NSInteger length;

///导航段时间
@property (nonatomic, assign) NSInteger time;

///导航段转向类型
@property (nonatomic, assign) AMapNaviIconType iconType;

///导航段路口点的坐标
@property (nonatomic, strong) AMapNaviPoint *coordinate;

@end

#pragma mark - AMapNaviGroupSegment

///聚合段信息类 since 5.1.0
@interface AMapNaviGroupSegment : NSObject<NSCopying>

///聚合段名称
@property (nonatomic, strong) NSString *groupName;

///聚合段长度,单位:米
@property (nonatomic, assign) NSInteger distance;

///聚合段收费金额,单位:元
@property (nonatomic, assign) NSInteger toll;

///聚合段包含的起始导航段下标
@property (nonatomic, assign) NSInteger startSegmentID;

///聚合段包含导航段个数
@property (nonatomic, assign) NSInteger segmentCount;

///聚合段是否到达途径点
@property (nonatomic, assign) BOOL isArriveWayPoint;

@end

#pragma mark - AMapNaviTrafficStatus

///前方交通路况信息类
@interface AMapNaviTrafficStatus : NSObject<NSCopying>

///道路状态
@property (nonatomic, assign) AMapNaviRouteStatus status;

///该交通状态的路段长度
@property (nonatomic, assign) NSInteger length;

@end

#pragma mark - AMapNaviIntervalCameraDynamicInfo

///区间测速电子眼的动态信息 since 6.0.0
@interface AMapNaviIntervalCameraDynamicInfo : NSObject <NSCopying>

///区间测速路段的总长度
@property (nonatomic, assign) NSInteger length;

///进入区间测速路段后实时的区间路段剩余长度
@property (nonatomic, assign) NSInteger remainDistance;

///进入区间测速路段后的实时平均车速
@property (nonatomic, assign) NSInteger averageSpeed;

///进入区间测速路段后的剩余路段的合理车速
@property (nonatomic, assign) NSInteger reasonableSpeedInRemainDist;

@end

#pragma mark - AMapNaviCameraInfo

///电子眼信息类
@interface AMapNaviCameraInfo : NSObject <NSCopying>

///电子眼类型
@property (nonatomic, assign) AMapNaviCameraType cameraType;

///电子眼限速，-2表示没有采集到限速数据，-1表示该车道禁行，0表示没有限速
@property (nonatomic, assign) NSInteger cameraSpeed;

///电子眼经纬度
@property (nonatomic, strong) AMapNaviPoint *coordinate;

///到电子眼的距离，-1表示没有剩余距离信息。
@property (nonatomic, assign) NSInteger distance;

///区间测速电子眼的动态信息. 注意：只有在导航的过程中且 cameraType 为 AMapNaviCameraTypeIntervalVelocityEnd 的时候才有. since 6.0.0
@property (nonatomic, strong) AMapNaviIntervalCameraDynamicInfo *intervalCameraDynamicInfo;

@end

#pragma mark - AMapNaviServiceAreaInfo


///服务区域信息 since 5.0.0
@interface AMapNaviServiceAreaInfo : NSObject <NSCopying>

///到服务区域的距离
@property (nonatomic, assign) NSInteger remainDistance;

///服务区域类型(0服务区,1收费站)
@property (nonatomic, assign) NSInteger type;

///服务区域名称
@property (nonatomic, strong) NSString *name;

///服务区域经纬度
@property (nonatomic, strong) AMapNaviPoint *coordinate;

@end

#pragma mark - AMapNaviCruiseInfo

///巡航模式信息类
@interface AMapNaviCruiseInfo : NSObject

///连续启用时间(单位:秒)
@property (nonatomic, assign) NSInteger cruisingDriveTime;

///连续行驶距离(单位:米)
@property (nonatomic, assign) NSInteger cruisingDriveDistance;

@end

#pragma mark - AMapNaviTrafficFacilityInfo

/**
 * 获取道路设施类型
 * 0：未知道路设施
 * 4：测速拍照
 * 5：违章拍照
 * 12：铁路道口
 * 13：左侧落石
 * 14：事故易发地段
 * 15：路段易滑
 * 16：村庄
 * 18：学校
 * 19：有人看管的铁路道口
 * 20：无人看管的铁路道口
 * 21：道路两侧变窄
 * 22：向左急弯路
 * 23：向右急弯路
 * 24：反向弯路
 * 25：连续弯路
 * 26：左侧车辆交汇处
 * 27：右侧车辆交汇处
 * 28：监控摄像
 * 29：公交专用道拍照
 * 31：禁止超车
 * 36：右侧变窄
 * 37：左侧变窄
 * 38：窄桥
 * 39：左右绕行
 * 40：左侧绕行
 * 41：右侧绕行
 * 42：右侧落石
 * 43：左侧靠山险路
 * 44：右侧靠山险路
 * 47：上陡坡
 * 48：下陡坡
 * 49：过水路面
 * 50：路面不平
 * 52：慢行
 * 53：事故多发,注意危险
 * 54：横风区
 * 58：隧道
 * 59：渡口
 * 92:闯红灯拍照
 * 93:应急车道拍照
 * 94:非机动车道拍照
 * 100：违章高发地
 */

///道路交通设施类
@interface AMapNaviTrafficFacilityInfo : NSObject

///经纬度
@property (nonatomic, strong) AMapNaviPoint *coordinate;

///类型
@property (nonatomic, assign) NSInteger boardcastType;

///距离设施的剩余距离(单位:米)
@property (nonatomic, assign) NSInteger distance;

///限速值(单位:公里/小时)
@property (nonatomic, assign) NSInteger limitSpeed;

@end

#pragma mark - AMapNaviRouteLabel

///道路标签信息 since 5.0.0
@interface AMapNaviRouteLabel : NSObject <NSCopying>

///标签类型
@property (nonatomic, assign) NSInteger type;

///标签内容
@property (nonatomic, strong) NSString *content;

@end

#pragma mark - AMapNaviRestrictionInfo

///路径限行信息 since 5.0.0
@interface AMapNaviRestrictionInfo : NSObject <NSCopying>

///该字段已废弃,请使用 titleType . since 6.0.0
@property (nonatomic, assign) NSInteger type __attribute__((deprecated("该字段已废弃,请使用 titleType . since 6.0.0"))) ;

///-1:无效值; 0:外地车限行,建议设置车牌; 1:外地车限行,建议开启限行; 2:已避开限行区域; 3:起点在限行区域内; 4:终点在限行区域内; 5:途经点在限行区域内; 6:途经限行区域
@property (nonatomic, assign) NSInteger titleType;

///标题
@property (nonatomic, strong) NSString *title;

///描述 该字段已废弃，since 6.0.0
@property (nonatomic, strong) NSString *desc __attribute__((deprecated("该字段已废弃，since 6.0.0")));

///城市代码
@property (nonatomic, assign) NSInteger cityCode;

///tips描述，titleType为0或1时才有描述
@property (nonatomic, strong) NSString *tips;

@end

#pragma mark - AMapNaviParallelRoadStatus

///平行路状态信息 since 5.3.0
@interface AMapNaviParallelRoadStatus : NSObject

///主辅路标识(存在平行路时,可切换到的平行路类型)
@property (nonatomic, assign) AMapNaviParallelRoadStatusFlag flag;

///切换状态: 0:非平行路切换过程中; 1:处于平行路切换过程之中(此时不可以进行平行路切换操作);
@property (nonatomic, assign) NSInteger status;

@end

#pragma mark - AMapNaviVehicleInfo

///车辆信息 since 6.0.0
@interface AMapNaviVehicleInfo : NSObject <NSCopying,NSCoding>

///车牌号,如"京H1N11"
@property (nonatomic, strong) NSString *vehicleId;

///是否开启ETA请求的躲避车辆限行, 默认为YES. 注意：只有设置为YES, 且设置了车牌号才能躲避车辆限行.
@property (nonatomic, assign) BOOL isETARestriction;

///设置车辆类型,0:小车; 1:货车. 默认0(小车). 注意:只有设置了货车，其他关于货车的属性设置才会生效
@property (nonatomic, assign) NSInteger type;

///设置货车的类型(大小),1:微型货车; 2:轻型/小型货车; 3:中型货车; 4:重型货车
@property (nonatomic, assign) NSInteger size;

///设置货车的轴数（用来计算过路费及限重）
@property (nonatomic, assign) NSInteger axisNums;

///设置货车的宽度,范围:(0,5],单位：米
@property (nonatomic, assign) CGFloat width;

///设置货车的高度,范围:(0,10],单位：米
@property (nonatomic, assign) CGFloat height;

///设置货车的长度,范围:(0,25],单位：米
@property (nonatomic, assign) CGFloat length;

///设置货车的核定载重,范围:(0,100],单位：吨. 注意:核定载重应小于总重量
@property (nonatomic, assign) CGFloat load;

///设置货车的总重量,范围:(0,100],单位：吨. 注意:核定载重应小于总重量
@property (nonatomic, assign) CGFloat weight;

@end

#pragma mark - AMapNaviNotAvoidFacilityAndForbiddenInfo

///导航过程中的没有避开的设施、禁行标志等信息 since 6.0.0
@interface AMapNaviNotAvoidFacilityAndForbiddenInfo : NSObject <NSCopying,NSCoding>

///类型,1:限高; 2:限宽; 3:限重; 4:禁行
@property (nonatomic, assign) NSInteger type;

///禁行类型,-1:无效; 0:禁止左转; 1:禁止右转; 2:禁止左掉头; 3:禁止右掉头; 4:禁止直行
@property (nonatomic, assign) NSInteger forbiddenType;

///自车到设施的距离，-1表示没有剩余距离信息。
@property (nonatomic, assign) NSInteger distance;

///设施的经纬度
@property (nonatomic, strong) AMapNaviPoint *coordinate;

@end

#pragma mark - AMapNaviRouteForbiddenInfo

/** 车型
 *  第1位：全部车型
 *  第2位：小车
 *  第3位：微型货车
 *  第4位：轻型货车
 *  第5位：中型货车
 *  第6位：重型货车
 *  第7位：拖挂
 *  第8位：保留
 */
///路线上的禁行标示信息 since 6.0.0
@interface AMapNaviRouteForbiddenInfo : NSObject <NSCopying>

///类型, 0:禁止左转; 1:禁止右转; 2:禁止左掉头; 3:禁止右掉头; 4:禁止直行
@property (nonatomic, assign) NSInteger type;

///车型, 用一个长度为8的字符串表示，每一位上的数字如果为1, 表示该车型禁行，如果为0, 表示该车型不禁行. 如 '00001110' 表示'中型货车、重型货车、拖挂'禁行
@property (nonatomic, strong) NSString *vehicleType;

///禁行标示所在的位置
@property (nonatomic, strong) AMapNaviPoint *coordinate;

///禁行相关的时间信息
@property (nonatomic, strong) NSString *timeDescription;

///禁行标示所在的道路名
@property (nonatomic, strong) NSString *roadName;

@end

#pragma mark - AMapNaviRoadFacilityInfo

///道路设施信息 since 6.0.0
@interface AMapNaviRoadFacilityInfo : NSObject <NSCopying>

///设施类型
@property (nonatomic, assign) AMapNaviRoadFacilityType type;

///设施所在的位置
@property (nonatomic, strong) AMapNaviPoint *coordinate;

///设施所在的道路名
@property (nonatomic, strong) NSString *roadName;

@end


