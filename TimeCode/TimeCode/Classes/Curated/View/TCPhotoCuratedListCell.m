//
//  TCPhotoCuratedListCell.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/14.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCPhotoCuratedListCell.h"
#import "TCPhotoModel.h"
#import "TCPhotoUrlModel.h"


@interface TCPhotoCuratedListCell ()


@end

@implementation TCPhotoCuratedListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self tc_layoutUI];
    }
    return self;
}

- (void)tc_layoutUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoView.layer.cornerRadius = 4.f;
    self.photoView.layer.masksToBounds = YES;
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
        make.left.equalTo(self.contentView.mas_left).offset(5.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-5.f);
    }];
}

- (void)setModel:(TCPhotoModel *)model {
    _model = model;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.urls.thumb] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}

@end
