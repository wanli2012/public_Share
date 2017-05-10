//
//  LBMerchantcreditViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMerchantcreditViewController.h"
#import "LBMerchantcreditTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LBMerchantcreditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@property (assign, nonatomic)NSUInteger allCount;//总条数

@end

@implementation LBMerchantcreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家信用";
    self.navigationController.navigationBar.hidden = NO;
    self.tableview.tableFooterView=[UIView new];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _page=1;
    _allCount=0;
    _refreshType=NO;
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMerchantcreditTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMerchantcreditTableViewCell"];
    
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerrefresh];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];

    
    // 设置文字
    
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
    
    [self loadData];//加载数据
}

-(void)loadData{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Index/shop_credi" paramDic:@{@"page":[NSNumber numberWithInteger:_page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==0) {
            _allCount = [responseObject[@"data"][@"blackListCount"]integerValue];
            if (_refreshType == NO) {
                [self.dataArr removeAllObjects];
                self.blackcountLb.text =[NSString stringWithFormat:@"不良商家信用合计 %@",responseObject[@"data"][@"blackListCount"]];
                [self.dataArr addObjectsFromArray:responseObject[@"data"][@"rows"]];
                
                [self.tableview reloadData];
            }else{
                self.blackcountLb.text =[NSString stringWithFormat:@"不良商家信用合计 %@",responseObject[@"data"][@"blackListCount"]];
                [self.dataArr addObjectsFromArray:responseObject[@"data"][@"rows"]];
                
                [self.tableview reloadData];
            
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMerchantcreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMerchantcreditTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.Headimage sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row][@"picture"]] placeholderImage:[UIImage imageNamed:@"no_pictures"]];
    
     cell.companyLb.text=[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"companyname"]];
     cell.positionLb.text=[NSString stringWithFormat:@"%@%@",self.dataArr[indexPath.row][@"provinceid"],self.dataArr[indexPath.row][@"cityid"]];
     cell.IDStr.text=[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"usernumber"]];
    if ([cell.IDStr.text rangeOfString:@"null"].location != NSNotFound) {
        cell.IDStr.text = @"";
    }
     cell.adressLb.text=[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"companyaddress"]];
    
    return cell;
    
    
}
//下拉刷新
-(void)loadNewData{

    _refreshType = NO;
    _page=1;

    [self loadData];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    if (self.dataArr.count == _allCount) {
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD showError:@"数据已加载完成"];
        return;
    }
    [self loadData];
}

-(NSMutableArray*)dataArr{

    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;

}

@end
