//
//  MBProgressHUD+TCHUD.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "MBProgressHUD+TCHUD.h"
#import "AppDelegate.h"

@implementation MBProgressHUD (TCHUD)
/// 添加文字提醒到指定view，并在默认时间内自动隐藏（1s）
+ (void)showMessage:(NSString *)msg To:(UIView *)view {
    TCdispatch_main_async_safe(^{
        [MBProgressHUD hideHUDForView:view animated:NO];
        if (msg.length==0) {
            return ;
        }
        MBProgressHUD *progressHUD = [[self alloc] initWithView:view];
        progressHUD.userInteractionEnabled = NO;
        progressHUD.removeFromSuperViewOnHide = YES;
        progressHUD.mode = MBProgressHUDModeText;
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        progressHUD.bezelView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
        progressHUD.bezelView.layer.cornerRadius = 8.f;
        progressHUD.bezelView.layer.masksToBounds = YES;
        progressHUD.offset = CGPointMake(0, - (UI_NAVIGATIONBAR_HEIGHT + UI_STATUSBAR_HEIGHT)/2.f);
        progressHUD.label.text = msg;
        progressHUD.label.font = [UIFont systemFontOfSize:14.f];
        progressHUD.label.textColor = [UIColor whiteColor];
        progressHUD.label.numberOfLines = 0;
        progressHUD.margin = 10.f;
        [view addSubview:progressHUD];
        [progressHUD showAnimated:YES];
        [progressHUD hideAnimated:NO afterDelay:kDefaultShowDuration];
    });
}

/// 添加文字提醒到Window上，并在默认时间内自动隐藏（2s）
+ (void)showMessageToWindow:(NSString *)msg {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *view  =  appDelegate.window;
    [self showMessage:msg To:view];
}

/// 添加旋转菊花到指定view，不会自动隐藏
+ (void)showActivityIndicatorTo:(UIView *)view {
    TCdispatch_main_async_safe((^{
        [MBProgressHUD hideHUDForView:view animated:NO];
        MBProgressHUD *progressHUD = [[self alloc] initWithView:view];
        progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        progressHUD.userInteractionEnabled = NO;
        progressHUD.bezelView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
        progressHUD.bezelView.layer.cornerRadius = 8.f;
        progressHUD.bezelView.layer.masksToBounds = YES;
        progressHUD.removeFromSuperViewOnHide = YES;
        progressHUD.offset = CGPointMake(0, - (UI_NAVIGATIONBAR_HEIGHT + UI_STATUSBAR_HEIGHT)/2.f);
        [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
        [view addSubview:progressHUD];
        [progressHUD showAnimated:YES];
    }));
    
}

/// 添加旋转菊花到window上，不会自动隐藏
+ (void)showActivityIndicatorToWindow {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *view  =  appDelegate.window;
    [self showActivityIndicatorTo:view];
}

/// 隐藏指定view上的旋转菊花
+ (void)hiddenActivityIndicatorFor:(UIView *)view {
    TCdispatch_main_async_safe(^{
        [MBProgressHUD hideHUDForView:view animated:NO];
    });
}

/// 隐藏window上的旋转菊花
+ (void)hiddenActivityIndicatorForWindow {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *view  =  appDelegate.window;
    [self hiddenActivityIndicatorFor:view];
}
@end
