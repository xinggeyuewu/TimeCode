//
//  TCPhotoCuratedListCell.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/14.
//  Copyright © 2019 星歌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class TCPhotoModel;

/// 编辑推荐列表控制器cell
@interface TCPhotoCuratedListCell : UITableViewCell

/// 数据模型
@property (nonatomic, strong) TCPhotoModel *model;
@end

NS_ASSUME_NONNULL_END
