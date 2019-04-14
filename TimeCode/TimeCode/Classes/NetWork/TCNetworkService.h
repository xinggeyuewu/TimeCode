//
//  TCNetworkService.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^TCSuccessBlock)(id responseObject);
typedef void(^TCFailureBlock)(id responseObject,NSError *error);


/// 网络请求管理类
@interface TCNetworkService : NSObject
/**
 *  通过请求获取数据(可操作模式)
 *
 *  @param param         请求参数
 *  @param fromeCache    无网络时是否从缓存获取
 *  @param successBlock  成功响应
 *  @param failureBlock  失败响应
 */
+ (void)getDataWithParameter:(NSDictionary *)param
        notReachableFromeCache:(BOOL)fromeCache
                  successBlock:(TCSuccessBlock)successBlock
                  failureBlock:(TCFailureBlock)failureBlock;
@end


#pragma mark - 网络状态枚举
/**
 *  网络状态枚举
 */
typedef NS_ENUM(NSUInteger, TCNetworkStatus) {
    /**
     *  未知网络
     */
    TCNetworkStatusUnknown,
    /**
     *  无网络
     */
    TCNetworkStatusNotReachable,
    /**
     *  手机网络
     */
    TCNetworkStatusViaWWAN,
    /**
     * WIFI网络
     */
    TCNetworkStatusViaWiFi,
};

#pragma mark - 网络状态通知

FOUNDATION_EXTERN  NSString *const TCNotificationNetworkStatusUnknown;       //未知网络
FOUNDATION_EXTERN  NSString *const TCNotificationNetworkStatusNotReachable;  //无网络
FOUNDATION_EXTERN  NSString *const TCNotificationNetworkStatusViaWWAN;       //蜂窝网络
FOUNDATION_EXTERN  NSString *const TCNotificationNetworkStatusViaWiFi;       //WIFI

#pragma mark - 网络情况监测
/**
 网络情况
 */
@interface TCNetworkService (NetworkStatus)
/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)startNetworkStatusWithBlock:(void(^)(TCNetworkStatus status))networkStatus;
/**
 * 是否有网
 */
+ (BOOL)isReachable;
/**
 * 是否是蜂窝网络
 */
+ (BOOL)isWWANNetwork;
/**
 * 是否是WIFI
 */
+ (BOOL)isWiFiNetwork;
@end
NS_ASSUME_NONNULL_END

