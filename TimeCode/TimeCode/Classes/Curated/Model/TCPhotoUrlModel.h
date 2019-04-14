//
//  TCPhotoUrlModel.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/14.
//  Copyright © 2019 星歌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 保存图片url的数据模型
@interface TCPhotoUrlModel : NSObject
/// 原图链接
@property (nonatomic, copy) NSString *raw;
/// 大图链接
@property (nonatomic, copy) NSString *full;
/// 正常图片链接
@property (nonatomic, copy) NSString *regular;
/// 小图链接
@property (nonatomic, copy) NSString *small;
/// 缩略图链接
@property (nonatomic, copy) NSString *thumb;

@end

NS_ASSUME_NONNULL_END
