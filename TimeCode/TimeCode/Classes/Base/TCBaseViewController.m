//
//  TCBaseViewController.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCBaseViewController.h"

@interface TCBaseViewController ()

@end

@implementation TCBaseViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 通用设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    UIColor *tintColor = [UIColor colorWithHexString:@"0x474747"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:tintColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.tintColor = tintColor;
    
}





#pragma mark - 处理公共网络请求
- (void)tc_handleRequestWithResponce:(id)resp andError:(NSError *)error {
    (_refreshHeader && _refreshHeader.isRefreshing) ? [self.refreshHeader endRefreshing] : nil;
    
    (_refreshFooter && _refreshFooter.isRefreshing) ? [self.refreshFooter endRefreshing] :nil;
}

#pragma mark - 子类需要实现的方法
- (void)tc_loadNewData {
    
}

- (void)tc_loadMoreData {
    
}


#pragma mark - 默认表格代理
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - 懒加载
- (UITableView *)tc_tableView {
    if (_tc_tableView == nil) {
        _tc_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tc_tableView.dataSource = self;
        _tc_tableView.delegate = self;
        _tc_tableView.tableFooterView = [[UIView alloc] init];
        _tc_tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tc_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tc_tableView.estimatedSectionHeaderHeight = 0;
            _tc_tableView.estimatedSectionFooterHeight = 0;
            _tc_tableView.estimatedRowHeight = 0;
        }
    }
    
    return _tc_tableView;
}

- (MJRefreshGifHeader *)refreshHeader{
    
    if (_refreshHeader == nil) {
        _refreshHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(tc_loadNewData)];
        
    }
    return _refreshHeader;
}
- (MJRefreshAutoFooter *)refreshFooter{
    
    if (_refreshFooter == nil) {
        _refreshFooter = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(tc_loadMoreData)];
    }
    return _refreshFooter;
    
}

@end
