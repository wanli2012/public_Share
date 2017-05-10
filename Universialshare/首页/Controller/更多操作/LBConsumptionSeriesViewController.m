//
//  LBConsumptionSeriesViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBConsumptionSeriesViewController.h"
#import "LBConsumptionSeriesViewTableViewCell.h"

@interface LBConsumptionSeriesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSArray *imageArr;

@property (strong, nonatomic)NSArray *dataDic;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBConsumptionSeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.title=@"消费系列";
    
    self.tableview.tableFooterView=[UIView new];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.bounces=NO;
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"LBConsumptionSeriesViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBConsumptionSeriesViewTableViewCell"];
    
    [self loadData];//加载数据
    
}
-(NSArray*)imageArr{
    
    if (!_imageArr) {
        _imageArr=[NSArray arrayWithObjects:@"5xilie",@"10xilie",@"20xilie", nil];
    }
    
    return _imageArr;
}
-(void)loadData{
   
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"index/index_alert" paramDic:@{@"type":@4} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            self.dataDic = responseObject[@"data"][@"head"];
            
            [self.tableview reloadData];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ADAPT(100);
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBConsumptionSeriesViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBConsumptionSeriesViewTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageV.image=[UIImage imageNamed:self.imageArr[indexPath.row]];

        if (indexPath.row == 0) {
            cell.xiaoFLb.text=[NSString stringWithFormat:@"消费金额: %@元",self.dataDic[indexPath.row][@"money"]];
            cell.heartLb.text=[NSString stringWithFormat:@"善心总数: %@颗",self.dataDic[indexPath.row][@"love"]];
            cell.beanLB.text=[NSString stringWithFormat:@"总善行豆: %@颗",self.dataDic[indexPath.row][@"love"]];
             cell.timeLb.text = [NSString stringWithFormat:@"%@",self.dataDic[indexPath.row][@"time"]];
        }else if (indexPath.row == 1){
        
        cell.xiaoFLb.text=[NSString stringWithFormat:@"消费金额: %@元",self.dataDic[indexPath.row][@"money"]];
        cell.heartLb.text=[NSString stringWithFormat:@"善心总数: %@颗",self.dataDic[indexPath.row][@"love"]];
        cell.beanLB.text=[NSString stringWithFormat:@"总善行豆: %@颗",self.dataDic[indexPath.row][@"love"]];
        cell.timeLb.text = [NSString stringWithFormat:@"%@",self.dataDic[indexPath.row][@"time"]];
    
    }else if (indexPath.row == 2){
        
        cell.xiaoFLb.text=[NSString stringWithFormat:@"消费金额: %@元",self.dataDic[indexPath.row][@"money"]];
        cell.heartLb.text=[NSString stringWithFormat:@"善心总数: %@颗",self.dataDic[indexPath.row][@"love"]];
        cell.beanLB.text=[NSString stringWithFormat:@"总善行豆: %@颗",self.dataDic[indexPath.row][@"love"]];
        cell.timeLb.text = [NSString stringWithFormat:@"%@",self.dataDic[indexPath.row][@"time"]];
        
    }
//    NSDate * date = [NSDate date];//当前时间
//    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
//    dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
//    NSString *datestr=[dateFormatter stringFromDate:lastDay];
//    
//    cell.timeLb.text=datestr;
    
    return cell;
    
    
}



-(NSArray*)dataDic{
    
    if (!_dataDic) {
        _dataDic=[[NSArray alloc]init];
    }
    
    return _dataDic;
    
}

@end
