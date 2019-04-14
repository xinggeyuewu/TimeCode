//
//  TCNetworkService+UIViewController.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/14.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCNetworkService+UIViewController.h"
#import "TCBaseViewController.h"

@implementation TCNetworkService (UIViewController)
+ (void)getDataWithParameter:(NSDictionary *)param viewController:(TCBaseViewController *)controller notReachableFromeCache:(BOOL)fromeCache successBlock:(TCSuccessBlock)successBlock failureBlock:(TCFailureBlock)failureBlock {
    [self getDataWithParameter:param  notReachableFromeCache:fromeCache successBlock:^(id  _Nonnull responseObject) {
        controller ? [controller tc_handleRequestWithResponce:responseObject andError:nil] : nil;
        successBlock ? successBlock(responseObject) : nil;
    } failureBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        controller ? [controller tc_handleRequestWithResponce:responseObject andError:error] : nil;
        failureBlock ? failureBlock(responseObject,error) : nil;
    }];
    
}
@end
