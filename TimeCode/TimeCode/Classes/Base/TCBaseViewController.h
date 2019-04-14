//
//  TCBaseViewController.h
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
/**
 * 刷新头
 */
@property (nonatomic, strong) MJRefreshGifHeader *refreshHeader;
/**
 * 刷新尾
 */
@property (nonatomic, strong) MJRefreshAutoFooter *refreshFooter;

/// 表视图(需实现代理方法)
@property (nonatomic, strong) UITableView *tc_tableView;


/// 网络已连接
- (void)tc_netConnectSucceed ;
/// 网络未连接
- (void)tc_netConnectFailed ;

/// 加载新数据
- (void)tc_loadNewData;
/// 加载更多数据
- (void)tc_loadMoreData;

/// 处理通用网络请求事件
- (void)tc_handleRequestWithResponce:(nullable id)resp andError:(nullable NSError *)error;
@end

NS_ASSUME_NONNULL_END
