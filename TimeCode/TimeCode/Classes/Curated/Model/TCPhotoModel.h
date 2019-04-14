//
//  TCPhotoModel.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/14.
//  Copyright © 2019 星歌. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCPhotoUrlModel;

NS_ASSUME_NONNULL_BEGIN
/// 图片数据模型
@interface TCPhotoModel : NSObject
/// 图片id
@property (nonatomic, copy) NSString *photoId;
/// 创建时间
@property (nonatomic, copy) NSString *created_at;
/// 更新时间
@property (nonatomic, copy) NSString *updated_at;
/// 图片宽
@property (nonatomic, assign) CGFloat width;
/// 图片高
@property (nonatomic, assign) CGFloat height;
/// 颜色
@property (nonatomic, copy) NSString *color;
/// 图片描述
@property (nonatomic, copy) NSString *photoDescription;
/// url
@property (nonatomic, strong) TCPhotoUrlModel *urls;

/// 行高
@property (nonatomic, assign) CGFloat rowHeight;




@end

NS_ASSUME_NONNULL_END
