//
//  LBMySalesmanListViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMySalesmanListViewController.h"
#import "LBMySalesmanListTableViewCell.h"
#import "LBMySalesmanListDeatilViewController.h"
#import "LBSaleManPersonInfoViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LBMySalesmanListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation LBMySalesmanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _page = 1;
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMySalesmanListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMySalesmanListTableViewCell"];
    
    //获取数据
    [self initdatasource];
    [self.tableview addSubview:self.nodataV];
    
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
}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/salerList" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token ,@"type":@"1"} finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
         if ([responseObject[@"code"] integerValue]==1) {
             
             if (_refreshType == NO) {
                 [self.dataarr removeAllObjects];
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
             }else{
                 
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
                 
             }
             
         }else if ([responseObject[@"code"] integerValue]==3){
             
             [MBProgressHUD showError:responseObject[@"message"]];
             
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

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self initdatasource];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataarr.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LBMySalesmanListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMySalesmanListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:self.dataarr[indexPath.row][@"saleman_headpic"]] placeholderImage:[UIImage imageNamed:@""]];
    cell.namelb.text=[NSString stringWithFormat:@"用户名: %@",self.dataarr[indexPath.row][@"saleman_name"]];
    cell.EngLishLb.text=[NSString stringWithFormat:@"手机号: %@",self.dataarr[indexPath.row][@"saleman_phone"]];
    cell.adressLb.text=[NSString stringWithFormat:@"身份: %@",self.dataarr[indexPath.row][@"saleman_address"]];
    cell.businessNum.text=[NSString stringWithFormat:@"推荐推广员人数:%@家",self.dataarr[indexPath.row][@"saleman_num"]];
    cell.shopnum.text=[NSString stringWithFormat:@"推荐商家总额:%@元",self.dataarr[indexPath.row][@"shop_mon"]];
    
    if ([cell.shopnum.text rangeOfString:@"null"].location != NSNotFound) {
        cell.shopnum.text  = @"推荐商家总额:0元";
    }
    
    if ([self.dataarr[indexPath.row][@"saleman_type"] integerValue] == 6) {
        cell.adressLb.text = @"身份: 副总";
    }else if ([self.dataarr[indexPath.row][@"saleman_type"] integerValue] == 7) {
        cell.adressLb.text = @"身份: 高级推广员";
        cell.businessNum.hidden = NO;
    }else if ([self.dataarr[indexPath.row][@"saleman_type"] integerValue] == 8) {
        cell.adressLb.text = @"身份: 推广员";
        cell.businessNum.hidden = YES;
    }
    
    __weak typeof(self) weakself =self;
    cell.returntapgestureimage = ^(NSInteger index){
    
//        if (weakself.returnpushinfovc) {
//            weakself.returnpushinfovc(index);
//        }
    
    };
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.returnpushvc) {
        self.returnpushvc(self.dataarr[indexPath.row]);
    }
    
}

-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
    
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
@end
