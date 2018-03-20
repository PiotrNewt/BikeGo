//
//  AMapNaviDriveDataRepresentable.h
//  AMapNaviKit
//
//  Created by 刘博 on 16/1/13.
//  Copyright © 2016年 Amap. All rights reserved.
//

#import "AMapNaviCommonObj.h"

NS_ASSUME_NONNULL_BEGIN

@class AMapNaviInfo;
@class AMapNaviRoute;
@class AMapNaviLocation;
@class AMapNaviStatisticsInfo;
@class AMapNaviDriveManager;

/**
 * @brief AMapNaviDriveDataRepresentable协议.实例对象可以通过实现该协议,并将其通过 AMapNaviDriveManager 的addDataRepresentative:方法进行注册,便可获取导航过程中的导航数据更新.
 * 可以根据不同需求,选取使用特定的数据进行导航界面自定义. 
 * AMapNaviDriveView 即通过该协议实现导航过程展示.也可以依据导航数据的更新进行其他的逻辑处理.
 */
@protocol AMapNaviDriveDataRepresentable <NSObject>
@optional

/**
 * @brief 导航模式更新回调. 从5.3.0版本起,算路失败后导航SDK只对外通知算路失败,SDK内部不再执行停止导航的相关逻辑.因此,当算路失败后,不会收到 driveManager:updateNaviMode: 回调; AMapDriveManager.naviMode 不会切换到 AMapNaviModeNone 状态, 而是会保持在 AMapNaviModeGPS or AMapNaviModeEmulator 状态.
 * @param driveManager 驾车导航管理类
 * @param naviMode 导航模式,参考 AMapNaviMode 值
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviMode:(AMapNaviMode)naviMode;

/**
 * @brief 路径ID更新回调
 * @param driveManager 驾车导航管理类
 * @param naviRouteID 导航路径ID
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviRouteID:(NSInteger)naviRouteID;

/**
 * @brief 路径信息更新回调
 * @param driveManager 驾车导航管理类
 * @param naviRoute 路径信息,参考 AMapNaviRoute 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviRoute:(nullable AMapNaviRoute *)naviRoute;

/**
 * @brief 导航信息更新回调
 * @param driveManager 驾车导航管理类
 * @param naviInfo 导航信息,参考 AMapNaviInfo 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviInfo:(nullable AMapNaviInfo *)naviInfo;

/**
 * @brief 自车位置更新回调 (since 5.0.0，模拟导航和GPS导航的自车位置更新都会走此回调)
 * @param driveManager 驾车导航管理类
 * @param naviLocation 自车位置信息,参考 AMapNaviLocation 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation;

/**
 * @brief 需要显示路口放大图时的回调
 * @param driveManager 驾车导航管理类
 * @param crossImage 路口放大图Image(宽:高 = 25:16)
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager showCrossImage:(UIImage *)crossImage;

/**
 * @brief 需要隐藏路口放大图时的回调
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerHideCrossImage:(AMapNaviDriveManager *)driveManager;

/**
 * @brief 需要显示车道信息时的回调.可通过 UIImage *CreateLaneInfoImageWithLaneInfo(NSString *laneBackInfo, NSString *laneSelectInfo); 方法创建车道信息图片
 * 0-直行; 1-左转; 2-直行和左转; 3-右转;
 * 4-直行和右转; 5-左转掉头; 6-左转和右转; 7-直行和左转和右转;
 * 8-右转掉头; 9-直行和左转掉头; 10-直行和右转掉头; 11-左转和左转掉头;
 * 12-右转和右转掉头; 13-直行左侧道路变宽; 14-左转和左转掉头左侧变宽; 16-直行和左转和左掉头;
 * 17-右转和左掉头; 18-左转和左掉头和右转; 19-直行和右转和左掉头; 20-左转和右掉头; 21-公交车道; 23-可变车道;
 * 255-只会出现在laneSelectInfo，表示目前规划的路径，不可以走这个车道
 *
 * @param driveManager 驾车导航管理类
 * @param laneBackInfo 车道背景信息，例如：@"1|0|0|4"，表示当前道路有4个车道，分别为"左转|直行|直行|右转+直行"
 * @param laneSelectInfo 车道前景信息，其个数一定和车道背景信息一样，例如：@"255|0|0|0"，表示选择了当前道路的第2、3、4三个直行车道。
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager showLaneBackInfo:(NSString *)laneBackInfo laneSelectInfo:(NSString *)laneSelectInfo;

/**
 * @brief 需要隐藏车道信息时的回调
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerHideLaneInfo:(AMapNaviDriveManager *)driveManager;

/**
 * @brief 路况光柱信息更新回调
 * @param driveManager 驾车导航管理类
 * @param trafficStatus 路况光柱信息数组,参考 AMapNaviTrafficStatus 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTrafficStatus:(nullable NSArray<AMapNaviTrafficStatus *> *)trafficStatus;

/**
 * @brief 巡航道路设施信息更新回调.该更新回调只有在detectedMode开启后有效
 * @param driveManager 驾车导航管理类
 * @param trafficFacilities 道路设施信息数组,参考 AMapNaviTrafficFacilityInfo 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTrafficFacilities:(nullable NSArray<AMapNaviTrafficFacilityInfo *> *)trafficFacilities;

/**
 * @brief 巡航信息更新回调.该更新回调只有在detectedMode开启后有效
 * @param driveManager 驾车导航管理类
 * @param cruiseInfo 巡航信息,参考 AMapNaviCruiseInfo 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateCruiseInfo:(nullable AMapNaviCruiseInfo *)cruiseInfo;

/**
 * @brief 电子眼信息更新回调 since 5.0.0
 * @param driveManager 驾车导航管理类
 * @param cameraInfos 电子眼信息,参考 AMapNaviCameraInfo 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateCameraInfos:(nullable NSArray<AMapNaviCameraInfo *> *)cameraInfos;

/**
 * @brief 服务区和收费站信息更新回调 since 5.0.0
 * @param driveManager 驾车导航管理类
 * @param serviceAreaInfos 服务区信息,参考 AMapNaviServiceAreaInfo 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateServiceAreaInfos:(nullable NSArray<AMapNaviServiceAreaInfo *> *)serviceAreaInfos;

/**
 * @brief 平行道路信息更新回调. 当存在平行路时(AMapNaviParallelRoadStatus.flag != AMapNaviParallelRoadStatusFlagNone),可以调用AMapNaviDriveManager的switchParallelRoad:方法进行平行路切换. since 5.3.0
 * @param driveManager 驾车导航管理类
 * @param parallelRoadStatus 平行道路信息,参考 AMapNaviParallelRoadStatus 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateParallelRoadStatus:(nullable AMapNaviParallelRoadStatus *)parallelRoadStatus;

/**
 * @brief 区间电子眼信息更新回调 since 6.0.0
 * @param driveManager 驾车导航管理类
 * @param state 自车位置和区间测速电子眼路段的位置关系,参考 AMapNaviIntervalCameraPositionState 类
 * @param startInfo 电子眼信息,参考 AMapNaviCameraInfo 类
 * @param endInfo 电子眼信息,参考 AMapNaviCameraInfo 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateIntervalCameraWithPositionState:(AMapNaviIntervalCameraPositionState)state startInfo:(AMapNaviCameraInfo *)startInfo endInfo:(AMapNaviCameraInfo *)endInfo;

@end

NS_ASSUME_NONNULL_END
