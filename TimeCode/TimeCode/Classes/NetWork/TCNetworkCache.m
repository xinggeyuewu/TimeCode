//
//  TCNetworkCache.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCNetworkCache.h"

#import <YYCache/YYCache.h>

static NSString * const TCHTTPResponseCache = @"TCHTTPResponseCache";

static YYCache *_dataCache = nil;

@implementation TCNetworkCache
#pragma mark - 初始化
+ (void)initialize{
    
    //网络数据缓存
    _dataCache = [YYCache cacheWithName:TCHTTPResponseCache];
    
}
#pragma mark - 保存
+ (void)setCache:(id)data uniqueKey:(NSString *)uniqueKey{
    
    [_dataCache setObject:data forKey:uniqueKey withBlock:nil];
    
}
#pragma mark - 获取数据
+ (id)cacheForUniqueKey:(NSString *)uniqueKey{
    
    return [_dataCache objectForKey:uniqueKey];
    
}
@end
