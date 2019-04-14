//
//  TCJSONResponseSerializer.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCJSONResponseSerializer.h"

@implementation TCJSONResponseSerializer
#pragma mark - 重写基类方法，如果服务器返回错误代码，且带有业务数据体，则将数据体添加到错误对象中
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (*error != nil && data != nil) {
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:[*error userInfo]];
            [userInfo setValue:data forKey:responce_data];
            *error = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
        }
        
        return data;
    }
    
    return ([super responseObjectForResponse:response data:data error:error]);
}
@end
