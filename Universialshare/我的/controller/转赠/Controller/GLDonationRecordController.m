//
//  GLDonationRecordController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDonationRecordController.h"
#import "GLDonationRecordCell.h"
#import "GLDonationRecordModel.h"
#import "NetworkManager.h"
#import "NodataView.h"
#import <MJRefresh/MJRefresh.h>


@interface GLDonationRecordController()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
}

@property (strong, nonatomic)NodataView *nodataV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *models;

@property (nonatomic,assign)NSInteger page;


@end
static NSString *ID = @"GLDonationRecordCell";
@implementation GLDonationRecordController

//-(UITableView*)tableView {
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
//        self.tableView.showsVerticalScrollIndicator = NO;
//    }
//    return _tableView;
//}
- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"转赠记录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;

    [self.tableView registerNib:[UINib nibWithNibName:@"GLDonationRecordCell" bundle:nil] forCellReuseIdentifier:ID];
    
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    [self updateData:YES];
}
- (void)updateData:(BOOL)status {
    //    NSInteger page;
    if (status) {
        
        _page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dit = [NSMutableDictionary dictionary];
    dit[@"token"] = [UserModel defaultUser].token;
    dit[@"uid"] = [UserModel defaultUser].uid;
    dit[@"page"] = [NSString stringWithFormat:@"%ld",_page];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/give_list" paramDic:dit finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == 1) {
//            NSLog(@"%@",responseObject);
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLDonationRecordModel *model = [GLDonationRecordModel mj_objectWithKeyValues:dic];
                
                [_models addObject:model];
            }
//        }else if([responseObject[@"code"] intValue] == 3){
//            if (_models.count != 0) {
//                
//                [MBProgressHUD showError:@"已经没有更多数据了!"];
//            }
//            [MBProgressHUD showError:responseObject[@"message"]];
//            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        self.nodataV.hidden = NO;
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
#pragma  UITableviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_models.count <= 0 ) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLDonationRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40 * autoSizeScaleY;
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _nodataV;
    
}
@end
