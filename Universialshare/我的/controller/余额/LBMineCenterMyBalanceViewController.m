//
//  LBMineCenterMyBalanceViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/5.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMyBalanceViewController.h"
#import "LBMineCenterMyBalabceTableViewCell.h"
#import "LBMineCenterDetailedView.h"
#import "HWCalendar.h"
#import "LBMineCenterBalanceRechargeViewController.h"

@interface LBMineCenterMyBalanceViewController ()<UITableViewDelegate,UITableViewDataSource,HWCalendarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *balanceLb;
@property (weak, nonatomic) IBOutlet UIButton *cashBt;
@property (weak, nonatomic) IBOutlet UIButton *RechargeBt;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UIButton *typeBt;

@property (weak, nonatomic) IBOutlet UIButton *time1Lb;

@property (weak, nonatomic) IBOutlet UIButton *timeToLb;

@property (weak, nonatomic) IBOutlet UIButton *checkBt;
@property (strong, nonatomic)LBMineCenterDetailedView *viewa;
@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;

@property (assign, nonatomic)NSInteger timeBtIndex;//判断选择的按钮时哪一个
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashBtW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reChargeBtW;


@end

@implementation LBMineCenterMyBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    if (self.vcIndex == 1) {
        self.navigationItem.title = @"我的余额";
    }else if (_vcIndex == 2){
        self.navigationItem.title = @"我的返利";
    }else if (_vcIndex == 3){
        self.navigationItem.title = @"我的积分";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterMyBalabceTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterMyBalabceTableViewCell"];
    
    _viewa=[[LBMineCenterDetailedView alloc]initWithFrame:CGRectMake(85, 156, 100, 200)];
    [self.view addSubview:_viewa];
    [_viewa.expenditureBt addTarget:self action:@selector(expenditureEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_viewa.rwchargeBt addTarget:self action:@selector(viewarechargeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_viewa.dividendBt addTarget:self action:@selector(dividendEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _viewa.hidden = YES;
    
    [self.view addSubview:self.CalendarView];
    
    self.CalendarView.hidden = YES;
    
    [self.CalendarView addSubview:self.Calendar];
    
    __weak typeof(self) weakself = self;
    _Calendar.returnCancel = ^(){
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.CalendarView.hidden = YES;
        });
    };
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY.MM.dd"];
    
    [self.timeToLb setTitle:[formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCenterMyBalabceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterMyBalabceTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        
        if (self.vcIndex == 1) {
            cell.timeLb.text = @"时间";
            cell.integralLb.text = @"金额";
            cell.OrderNumberLb.text = @"订单号";
            cell.OrderIntegral.text = @"订单金额";
        }else if (_vcIndex == 2){
            cell.timeLb.text = @"时间";
            cell.integralLb.text = @"返利金额";
            cell.OrderNumberLb.text = @"订单号";
            cell.OrderIntegral.text = @"订单返利";
        }else if (_vcIndex == 3){
            cell.timeLb.text = @"时间";
            cell.integralLb.text = @"积分";
            cell.OrderNumberLb.text = @"订单号";
            cell.OrderIntegral.text = @"订单积分";
        }

        cell.timeLb.font = [UIFont systemFontOfSize:12 * autoSizeScaleX];
        cell.integralLb.font = [UIFont systemFontOfSize:12* autoSizeScaleX];
        cell.OrderNumberLb.font = [UIFont systemFontOfSize:12* autoSizeScaleX];
        cell.OrderIntegral.font = [UIFont systemFontOfSize:12* autoSizeScaleX];
        
        cell.view1.backgroundColor=YYSRGBColor(168, 168, 168, 1);
        cell.view2.backgroundColor=YYSRGBColor(168, 168, 168, 1);
        cell.view3.backgroundColor=YYSRGBColor(168, 168, 168, 1);
        cell.view4.backgroundColor=YYSRGBColor(168, 168, 168, 1);
        
    }else{
        //cell.timeLb.text = @"时间";
        cell.timeLb.font = [UIFont systemFontOfSize:10 * autoSizeScaleX];
        //cell.integralLb.text = @"积分";
        cell.integralLb.font = [UIFont systemFontOfSize:10 * autoSizeScaleX];
        //cell.OrderNumberLb.text = @"订单号";
        cell.OrderNumberLb.font = [UIFont systemFontOfSize:10 * autoSizeScaleX];
        //cell.OrderIntegral.text = @"订单积分";
        cell.OrderIntegral.font = [UIFont systemFontOfSize:10 * autoSizeScaleX];
        
        if (indexPath.row % 2 == 1) {
            
            cell.view1.backgroundColor=YYSRGBColor(222, 222, 222, 1);
            cell.view2.backgroundColor=YYSRGBColor(222, 222, 222, 1);
            cell.view3.backgroundColor=YYSRGBColor(222, 222, 222, 1);
            cell.view4.backgroundColor=YYSRGBColor(222, 222, 222, 1);
            
        }else{
        
            cell.view1.backgroundColor=YYSRGBColor(235, 235, 235, 1);
            cell.view2.backgroundColor=YYSRGBColor(235, 235, 235, 1);
            cell.view3.backgroundColor=YYSRGBColor(235, 235, 235, 1);
            cell.view4.backgroundColor=YYSRGBColor(235, 235, 235, 1);
        
        }
    
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
//提现
- (IBAction)cashEvent:(UIButton *)sender {
    
    if (self.vcIndex == 1) {
        self.hidesBottomBarWhenPushed=YES;
        LBMineCenterBalanceRechargeViewController *vc=[[LBMineCenterBalanceRechargeViewController alloc]init];
        vc.vcindex = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.vcIndex ==2){
    
    }else if (self.vcIndex ==3){
        
    }
    
}
//充值
- (IBAction)rechageEvent:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    LBMineCenterBalanceRechargeViewController *vc=[[LBMineCenterBalanceRechargeViewController alloc]init];
    vc.vcindex = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)choseTypeEvent:(UIButton *)sender {

    if (_viewa.hidden == YES) {
        
       _viewa.hidden = NO;
        
    }else{
    
       _viewa.hidden = YES;
    }
    
}

- (IBAction)timeForm:(UIButton *)sender {
    
    _timeBtIndex = 1;
    self.CalendarView.hidden = NO;
    [_Calendar show];
    
}
- (IBAction)timeTo:(UIButton *)sender {
    
    _timeBtIndex = 2;
    self.CalendarView.hidden = NO;
    [_Calendar show];
    
}

- (IBAction)checkEvent:(UIButton *)sender {
    
    if ([self.time1Lb.titleLabel.text isEqualToString:@"选择日期"]) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *date1 = [dateFormatter dateFromString:self.time1Lb.titleLabel.text];
    NSDate *date2 = [dateFormatter dateFromString:self.timeToLb.titleLabel.text];
    if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"1"]) {
        NSLog(@"date1 > date2");
    }else if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"-1"]){
        NSLog(@"date1 < date2");
    }else{
        NSLog(@"date1 = date2");
    }
    
}
//支出明细
-(void)expenditureEvent:(UIButton*)sender{

    self.typeLb.text = @"支出";
    _viewa.hidden = YES;

}
//充值明细
-(void)viewarechargeEvent:(UIButton*)sender{
    
    self.typeLb.text = @"充值";
    _viewa.hidden = YES;
    
}
//分红明细
-(void)dividendEvent:(UIButton*)sender{
    
    self.typeLb.text = @"分红";
    _viewa.hidden = YES;
    
}

#pragma mark - HWCalendarDelegate
- (void)calendar:(HWCalendar *)calendar didClickSureButtonWithDate:(NSString *)date
{
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.CalendarView.hidden = YES;
    });
    
    if (_timeBtIndex == 1) {
        
        [self.time1Lb setTitle:date forState:UIControlStateNormal];
        
    }else if (_timeBtIndex == 2){
     [self.timeToLb setTitle:date forState:UIControlStateNormal];
    
    }
}

#pragma mark - 时间比较大小
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //oneDay > anotherDay
        return 1;
    }
    else if (result == NSOrderedAscending){
        //oneDay < anotherDay
        return -1;
    }
    //oneDay = anotherDay
    return 0;
}


-(void)updateViewConstraints{

    [super updateViewConstraints];
    
    self.RechargeBt.layer.cornerRadius = 4;
    self.RechargeBt.clipsToBounds = YES;
    
    self.cashBt.layer.cornerRadius = 4;
    self.cashBt.clipsToBounds = YES;
    
    self.checkBt.layer.cornerRadius = 4;
    self.checkBt.clipsToBounds = YES;
    
    if (self.vcIndex == 1) {
        self.balanceLb.text=@"当前余额:";
    }else if (_vcIndex == 2){
        self.balanceLb.text=@"当前返利:";
        self.RechargeBt.hidden = YES;
        self.reChargeBtW.constant = 0;
        self.cashBtW.constant = 80;
        [self.cashBt setTitle:@"返利商城" forState:UIControlStateNormal];
    }else if (_vcIndex == 3){
        self.balanceLb.text=@"当前积分:";
        self.balanceLb.text=@"当前返利:";
        self.RechargeBt.hidden = YES;
        self.reChargeBtW.constant = 0;
        self.cashBtW.constant = 80;
        [self.cashBt setTitle:@"积分商城" forState:UIControlStateNormal];
    }
    
}



-(HWCalendar*)Calendar{

    if (!_Calendar) {
        _Calendar=[[HWCalendar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH , (SCREEN_WIDTH * 0.8)/7 * 9.5)];
        _Calendar.delegate = self;
        _Calendar.showTimePicker = YES;
    }
    return _Calendar;
}

-(UIView*)CalendarView{

    if (!_CalendarView) {
        _CalendarView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _CalendarView.backgroundColor=YYSRGBColor(0, 0, 0, 0.2);
    }
    return _CalendarView;
}

@end
