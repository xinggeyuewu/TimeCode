//
//  TCPhotosCuratedListController.m
//  TimeCode
//
//  Created by 星歌 on 2019/4/13.
//  Copyright © 2019 星歌. All rights reserved.
//

#import "TCPhotosCuratedListController.h"
#import "TCPhotoModel.h"
#import "TCPhotoCuratedListCell.h"
#import "LargeImageDownsizingViewController.h"

@interface TCPhotosCuratedListController ()
/// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataArr;
/// 第几页
@property (nonatomic, assign) NSInteger page;
@end

@implementation TCPhotosCuratedListController
#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tc_layoutUI];
    [self tc_loadNewData];
}


#pragma mark - 私有方法
/// 布局界面
- (void)tc_layoutUI {
    self.title = @"编辑推荐";
    
    self.tc_tableView.mj_header = self.refreshHeader;
    self.tc_tableView.mj_footer = self.refreshFooter;
    [self.tc_tableView registerClass:[TCPhotoCuratedListCell class] forCellReuseIdentifier:NSStringFromClass([TCPhotoCuratedListCell class])];
    self.tc_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tc_tableView];
    [self.tc_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


#pragma mark - 网络请求
- (void)tc_getPhotosCuratedListDataNetWork {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    
    [TCNetworkService getDataWithParameter:param viewController:self  notReachableFromeCache:YES successBlock:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in responseObject) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    [arr addObject:[TCPhotoModel mj_objectWithKeyValues:dic]];
                }
            }
            
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:arr];
            
            [self.tc_tableView reloadData];
        }else {
            [MBProgressHUD showMessage:@"数据异常，请稍后再试" To:self.view];
        }
    } failureBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        [MBProgressHUD showMessage:@"请求失败，请稍后再试" To:self.view];
    }];
}

#pragma mark - 私有方法
/// 请求新数据
- (void)tc_loadNewData {
    self.page = 1;
    [self tc_getPhotosCuratedListDataNetWork];
}
/// 请求更多数据
- (void)tc_loadMoreData {
    self.page += 1;
    [self tc_getPhotosCuratedListDataNetWork];
    
}




#pragma mark - 表格代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArr.count) {
        TCPhotoModel *model = self.dataArr[indexPath.row];
        return model.rowHeight;
    }
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCPhotoCuratedListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TCPhotoCuratedListCell class]) forIndexPath:indexPath];
    if (indexPath.row < self.dataArr.count) {
        cell.model = self.dataArr[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArr.count) {
        TCdispatch_main_async_safe(^{
            LargeImageDownsizingViewController *vc = [[LargeImageDownsizingViewController alloc] init];
            TCPhotoCuratedListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                vc.thumbImage = cell.photoView.image;
            }
            vc.model = self.dataArr[indexPath.row];
            
            [self presentViewController:vc animated:NO completion:nil];
        });
        
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
