//
//  AppDelegate+TCUtils.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "AppDelegate+TCUtils.h"

@implementation AppDelegate (TCUtils)
#pragma mark - 导航栏底线
- (void)tc_removeNavigationBarBottomLine {
    
    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
}


@end
