//
//  TCNetworkCache.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 缓存网络请求返回数据管理类
@interface TCNetworkCache : NSObject
/**
 *  缓存网络数据,根据请求体的uniqueKey
 *
 *  @param data   服务器返回的数据
 *  @param uniqueKey  唯一键值(业务参数)
 */
+ (void)setCache:(id)data uniqueKey:(NSString *)uniqueKey;
/**
 *  根据请求的 URL与parameters 取出缓存数据
 *
 *  @param uniqueKey  唯一键值(业务参数)
 *
 *  @return 缓存的服务器数据
 */
+ (id)cacheForUniqueKey:(NSString *)uniqueKey;
@end

NS_ASSUME_NONNULL_END
