//
//  TCNetworkService.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCNetworkService.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "TCNetworkCache.h"
#import "TCJSONResponseSerializer.h"


static NSString * const class_request = @"Request";
static NSString * const class_responce = @"Responce";

static NSString * const requestUrl = @"https://api.unsplash.com/photos/curated";

/// AFN
static AFHTTPSessionManager *_sessionManager;


@implementation TCNetworkService
+ (void)initialize{
    
    //请求管理者
    _sessionManager = [AFHTTPSessionManager manager];
    
    //设置默认值
    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _sessionManager.responseSerializer = [TCJSONResponseSerializer serializer];
    // 设置请求的超时时间(默认15秒)
    _sessionManager.requestSerializer.timeoutInterval = 15.f;
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 接口鉴权
    [_sessionManager.requestSerializer setValue:@"Client-ID 5050168bad91ad793c904f67342c33fff95a53545f8dc03030f25ded76a04858" forHTTPHeaderField:@"Authorization"];
    // 版本
    [_sessionManager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"Accept-Version"];

    
    
}

#pragma mark - 公共方法
+ (void)getDataWithParameter:(NSDictionary *)param notReachableFromeCache:(BOOL)fromeCache successBlock:(TCSuccessBlock)successBlock failureBlock:(TCFailureBlock)failureBlock {
    
        
        [_sessionManager GET:requestUrl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
            //成功回调
            successBlock ? successBlock(responseObject) : nil;
            //存到本地
            if (fromeCache) {
                [TCNetworkCache setCache:responseObject uniqueKey:[NSString stringWithFormat:@"%@?%@",requestUrl,[param mj_JSONString]]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 读取缓存
            if (![TCNetworkService isReachable] && fromeCache) {
                id responseObject = [TCNetworkCache cacheForUniqueKey:[NSString stringWithFormat:@"%@?%@",requestUrl,[param mj_JSONString]]];
                if (responseObject) {
                    successBlock ? successBlock(responseObject) : nil;
                    return ;
                }
            }
            // 失败回调
            failureBlock ? failureBlock([[error userInfo] valueForKey:responce_data],error) : nil;
                                
        }];
    
}

@end



NSString * const TCNotificationNetworkStatusUnknown      = @"TCNotificationNetworkStatusUnknown";       //未知网络
NSString * const TCNotificationNetworkStatusNotReachable = @"TCNotificationNetworkStatusNotReachable";  //无网络
NSString * const TCNotificationNetworkStatusViaWWAN      = @"TCNotificationNetworkStatusViaWWAN";       //蜂窝网络
NSString * const TCNotificationNetworkStatusViaWiFi      = @"TCNotificationNetworkStatusViaWiFi";       //WIFI

@implementation TCNetworkService (NetworkStatus)
#pragma mark - 开始监听网络
+ (void)startNetworkStatusWithBlock:(void(^)(TCNetworkStatus status))networkStatus{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status){
                case AFNetworkReachabilityStatusUnknown:{
                    networkStatus ? networkStatus(TCNetworkStatusUnknown) : nil;
                    //发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationNetworkStatusUnknown object:nil];
                    NSLog(@"未知网络");
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:{
                    networkStatus ? networkStatus(TCNetworkStatusNotReachable) : nil;
                    //发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationNetworkStatusNotReachable object:nil];
                    NSLog(@"无网络");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    networkStatus ? networkStatus(TCNetworkStatusViaWWAN) : nil;
                    //发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationNetworkStatusViaWWAN object:nil];
                    NSLog(@"蜂窝网络");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    networkStatus ? networkStatus(TCNetworkStatusViaWiFi) : nil;
                    //发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationNetworkStatusViaWiFi object:nil];
                    NSLog(@"WIFI");
                }
                    break;
            }
        }];
        
        [reachabilityManager startMonitoring];
    });
}
#pragma mark - 是否有网
+ (BOOL)isReachable{
    
    return [AFNetworkReachabilityManager sharedManager].reachable;
    
}
#pragma mark - 是否是蜂窝网络
+ (BOOL)isWWANNetwork{
    
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
    
}
#pragma mark - 是否是WIFI
+ (BOOL)isWiFiNetwork{
    
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
    
}

@end

