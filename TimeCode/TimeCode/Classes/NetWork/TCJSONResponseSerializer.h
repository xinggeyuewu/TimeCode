//
//  TCJSONResponseSerializer.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//  扩展自AFHTTPResponseSerializer，用来处理AFNetworking处理服务器http错误时不将数据体传回的问题

#import "AFURLResponseSerialization.h"

static NSString * const responce_data = @"responce_data";
NS_ASSUME_NONNULL_BEGIN

/// 用来处理AFNetworking处理服务器http错误时不将数据体传回的问题
@interface TCJSONResponseSerializer : AFJSONResponseSerializer

@end

NS_ASSUME_NONNULL_END
