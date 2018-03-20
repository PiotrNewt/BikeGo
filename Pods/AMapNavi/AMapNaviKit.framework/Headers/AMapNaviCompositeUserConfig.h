//
//  AMapNaviCompositeUserConfig.h
//  AMapNaviKit
//
//  Created by eidan on 2017/6/23.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMapNaviCommonObj.h"

///导航组件的配置类 since 5.2.0
@interface AMapNaviCompositeUserConfig : NSObject

/**
 * @brief 设置起点、终点、途径点（最多支持三个途径点）来调起路线规划页面,自动完成算路. 如果不设置起点,默认使用的是“我的位置”.
 * @param type POI点的起终点类型,参考 AMapNaviRoutePlanPOIType .
 * @param locationPoint POI点的经纬度坐标,必填. SDK会使用该坐标点进行路径规划,参考 AMapNaviPoint .
 * @param name POI点的名字,选填. SDK会将该名字显示在搜索栏内. 如果不传将使用默认值,如“终点”、“途径点1”.
 * @param mid POI点的高德唯一标识ID,选填. 如果传入，SDK将会优先使用此ID对应的POI点的经纬度坐标、名字等信息进行算路和展示.
 * @return 是否设置成功
 */
- (BOOL)setRoutePlanPOIType:(AMapNaviRoutePlanPOIType)type location:(AMapNaviPoint *_Nonnull)locationPoint name:(NSString *_Nullable)name POIId:(NSString *_Nullable)mid;

/**
 * @brief 设置导航组件启动时，直接进入导航界面（跳过路径规划页面）进行算路并自动开始导航. since 5.3.0
 * @param directly 是否直接进入导航界面, 默认值为NO. 注意：如果为YES，为了保证算路成功，还需设置有效的终点，否则会报错
 */
- (void)setStartNaviDirectly:(BOOL)directly;

/**
 * @brief 设置导航组件的主题皮肤类型. since 5.4.0
 * @param themeType 主题皮肤类型，默认为 AMapNaviCompositeThemeTypeDefault（蓝色）,参考 AMapNaviCompositeThemeType .
 */
- (void)setThemeType:(AMapNaviCompositeThemeType)themeType;

/**
 * @brief 设置导航组件启动时，是否需要进行路径规划. 此设置只有在setStartNaviDirectly为YES时，才起作用. since 5.4.0
 * @param need 是否需要进行路径规划，默认为YES. 如果为NO，导航组件启动时将不再进行算路，直接使用 AMapNaviDriveManager 单例已经规划好的路径进行导航
 */
- (void)setNeedCalculateRouteWhenPresent:(BOOL)need;

/**
 * @brief 设置导航组件界面dismiss时，是否调用 [AMapNaviDriveManager destroyInstance] 来尝试销毁 AMapNaviDriveManager 的单例. since 5.4.0
 * @param need 是否尝试销毁 AMapNaviDriveManager 的单例，默认为YES.
 */
- (void)setNeedDestoryDriveManagerInstanceWhenDismiss:(BOOL)need;

/**
 * @brief 设置当退出GPS导航时，是否弹出“确认退出导航”的AlertView. since 5.5.0
 * @param need 是否弹出“确认退出导航”的AlertView，默认为YES.
 */
- (void)setNeedShowConfirmViewWhenStopGPSNavi:(BOOL)need;

/**
 * @brief 设置车辆信息. since 6.0.0
 * @param vehicleInfo 车辆信息，参考 AMapNaviVehicleInfo.
 */
- (void)setVehicleInfo:(nonnull AMapNaviVehicleInfo *)vehicleInfo;


@end
