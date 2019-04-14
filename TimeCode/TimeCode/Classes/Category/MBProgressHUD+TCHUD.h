//
//  MBProgressHUD+TCHUD.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN


#define kDefaultShowDuration  1.f // 默认显示时间

/// 主线程安全 ，确保在主队列执行
#ifndef TCdispatch_queue_async_safe
#define TCdispatch_queue_async_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef TCdispatch_main_async_safe
#define TCdispatch_main_async_safe(block) TCdispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

@interface MBProgressHUD (TCHUD)
/// 添加文字提醒到指定view，并在默认时间内自动隐藏（2s）
+ (void)showMessage:(NSString *)msg To:(UIView *)view;

/// 添加文字提醒到Window上，并在默认时间内自动隐藏（2s）
+ (void)showMessageToWindow:(NSString *)msg;

/// 添加旋转菊花到指定view，不会自动隐藏
+ (void)showActivityIndicatorTo:(UIView *)view;
/// 添加旋转菊花到window上，不会自动隐藏
+ (void)showActivityIndicatorToWindow;
/// 隐藏指定view上的旋转菊花
+ (void)hiddenActivityIndicatorFor:(UIView *)view;
/// 隐藏window上的旋转菊花
+ (void)hiddenActivityIndicatorForWindow;
@end

NS_ASSUME_NONNULL_END
