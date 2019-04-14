//
//  TCNetworkService+UIViewController.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/14.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCNetworkService.h"

NS_ASSUME_NONNULL_BEGIN

@class TCBaseViewController;

@interface TCNetworkService (UIViewController)
/**
 *  通过请求获取数据(可操作模式)
 *
 *  @param param         请求参数
 *  @param fromeCache    无网络时是否从缓存获取
 *  @param successBlock  成功响应
 *  @param failureBlock  失败响应
 */
+ (void)getDataWithParameter:(NSDictionary *)param
              viewController:(TCBaseViewController *)controller
      notReachableFromeCache:(BOOL)fromeCache
                successBlock:(TCSuccessBlock)successBlock
                failureBlock:(TCFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
