//
//  TCPhotoModel.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/14.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCPhotoModel.h"
#import "TCPhotoUrlModel.h"

@implementation TCPhotoModel

+ (NSDictionary<NSString *,NSString *> *)replacedKeyFromPropertyName{
    
    return @{@"photoId":@"id",
             @"photoDescription":@"description"
             };
}


- (CGFloat)rowHeight {
    if (_rowHeight > 0) {
        return _rowHeight;
    }else {
        if (self.width > 0 && self.height > 0) {
            _rowHeight = (self.height / self.width ) * (UI_SCREEN_WIDTH-10) + 10.f;
            return _rowHeight;
        }
       
    }
    return 0.f;
}
@end
