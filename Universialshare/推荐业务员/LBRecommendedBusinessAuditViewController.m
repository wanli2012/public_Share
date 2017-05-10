//
//  LBRecommendedBusinessAuditViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRecommendedBusinessAuditViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LBRecommendedBusinessAuditTableViewCell.h"
#import "LBRecommendedBusinessAuditOneTableViewCell.h"
#import "LBRecommendedSalesmanViewController.h"

@interface LBRecommendedBusinessAuditViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@property (strong, nonatomic)NSMutableArray *messageArr;
@property (strong, nonatomic)UIButton *buttonedt;
@property (strong, nonatomic)UIPickerView *pickerView;
@property (strong, nonatomic)UIView *pickerViewMask;
@property (strong, nonatomic)NodataView *nodataV;

@property (strong, nonatomic)NSString *typeStr;//0 审核 1成功 2失败
@end

@implementation LBRecommendedBusinessAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.typeStr = @"0";
    _page = 1;
    self.navigationItem.title = @"推荐业务员";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.messageArr = [NSMutableArray arrayWithObjects:@"审核中",@"未通过审核", nil];
    self.tableview.tableFooterView = [UIView new];
    self.tableview.estimatedRowHeight = 90;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerNib:[UINib nibWithNibName:@"LBRecommendedBusinessAuditTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBRecommendedBusinessAuditTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBRecommendedBusinessAuditOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBRecommendedBusinessAuditOneTableViewCell"];

    //获取数据
    [self initdatasource];
    [self.tableview addSubview:self.nodataV];
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setTitle:@"筛选" forState:UIControlStateNormal];
    [_buttonedt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(edtingInfo) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
    
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

-(void)updateViewConstraints{

    [super updateViewConstraints];
    
    self.addButton.layer.cornerRadius = 4;
    self.addButton.clipsToBounds = YES;

}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/salerList" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token ,@"type":self.typeStr} finish:^(id responseObject)
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
            [MBProgressHUD showError:responseObject[@"message"]];
            
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
//筛选
-(void)edtingInfo{
    [self.view addSubview:self.pickerViewMask];
    [self.pickerViewMask addSubview:self.pickerView];
    
    
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
    
    
    return UITableViewAutomaticDimension;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //if ([self.typeStr isEqualToString:@"0"]) {
        LBRecommendedBusinessAuditOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBRecommendedBusinessAuditOneTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.namelb.text  = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"saleman_name"]];
        cell.phonelb.text  = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"saleman_phone"]];
        cell.adresslb.text  = [NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"saleman_address"]];
        
        if ([cell.namelb.text rangeOfString:@"null"].location != NSNotFound) {
            cell.namelb.text  = @"";
            
        }
        if ([cell.phonelb.text rangeOfString:@"null"].location != NSNotFound) {
            cell.phonelb.text  = @"";
        }
        if ([cell.adresslb.text rangeOfString:@"null"].location != NSNotFound) {
            cell.adresslb.text  = @"";
        }
    
    
        if ([self.typeStr isEqualToString:@"0"]) {
            
            cell.statuesLb.text = @"审核中";
            
        }
        if ([self.typeStr isEqualToString:@"1"]) {
            
            cell.statuesLb.text = @"未通过审核";
            
        }

    
        return cell;

//    }else if ([self.typeStr isEqualToString:@"2"]){
//        LBRecommendedBusinessAuditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBRecommendedBusinessAuditTableViewCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        return cell;
//
//    }
//    
//    return [[UITableViewCell alloc]init];
    
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.messageArr.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    
    return SCREEN_WIDTH -20;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.typeStr = [NSString stringWithFormat:@"%ld",(long)row];
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.messageArr[row];
}

////重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -20 , 50)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}



#pragma mark ---添加业务员
- (IBAction)addSalesManEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBRecommendedSalesmanViewController *vc=[[ LBRecommendedSalesmanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
    
}

//点击pickerViewMask
-(void)tapgestureMask{
    
    [self.pickerView removeFromSuperview];
    [self.pickerViewMask removeFromSuperview];
    //重新刷新
    _refreshType = NO;
    _page=1;
    [self.dataarr removeAllObjects];
    
    [self initdatasource];
    
}

-(UIPickerView*)pickerView{
    
    if (!_pickerView) {
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(10, (SCREEN_HEIGHT - 200)/2, SCREEN_WIDTH - 20, 200)];
        _pickerView.dataSource=self;
        _pickerView.delegate=self;
        _pickerView.backgroundColor=[UIColor whiteColor];
    }
    return _pickerView;
    
}

-(UIView*)pickerViewMask{
    
    if (!_pickerViewMask) {
        _pickerViewMask=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _pickerViewMask.backgroundColor= YYSRGBColor(0, 0, 0, 0.2);
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureMask)];
        [_pickerViewMask addGestureRecognizer:tap];
    }
    
    return _pickerViewMask;
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}

@end
