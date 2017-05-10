//
//  LBMineCenterBalanceRechargeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterBalanceRechargeViewController.h"
#import "LBMineCenterRechargeBankCardView.h"
#import "LBMineCenterAddBankCardViewController.h"
#import "LBMineCenterRechargeCashView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LBMineCenterBalanceRechargeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cardBt;

@property (weak, nonatomic) IBOutlet UITextField *cardTf;
@property (weak, nonatomic) IBOutlet UITextField *moneyLb;

@property (weak, nonatomic) IBOutlet UIButton *nextbt;

@property (strong, nonatomic)LBMineCenterRechargeBankCardView *MineCenterRechargeBankCardView;
@property (strong, nonatomic)LBMineCenterRechargeCashView *MineCenterRechargeCashView;

@property (strong, nonatomic)UIView *maskview;
@property (strong, nonatomic)UIView *maskview1;

@property (strong, nonatomic)NSMutableArray *cardArr;
@property (strong, nonatomic)NSMutableArray *cardB;
@property (assign, nonatomic)NSInteger selctIndex;

@property (assign, nonatomic)CGFloat CardViewH;
@property (strong, nonatomic)NSString *sixSecret;

@end

@implementation LBMineCenterBalanceRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    
    if (self.vcindex == 1) {
        self.navigationItem.title = @"充值";
        [self.nextbt setTitle:@"充值" forState:UIControlStateNormal];
        self.MineCenterRechargeCashView.titileLb.text = @"请输入充值密码";
    }else if (self.vcindex == 2){
        self.navigationItem.title = @"提现";
         [self.nextbt setTitle:@"提现" forState:UIControlStateNormal];
         self.MineCenterRechargeCashView.titileLb.text = @"请输入提现密码";
        self.MineCenterRechargeBankCardView.titllb.text = @"请选择提现卡号";
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _selctIndex = -1;
    
    [self.view addSubview:self.maskview];
    [self.maskview addSubview:self.MineCenterRechargeBankCardView];
    
    [self.view addSubview:self.maskview1];
    [self.maskview1 addSubview:self.MineCenterRechargeCashView];
    
    self.maskview.hidden = YES;
    self.maskview1.hidden = YES;
    
    _cardArr = [NSMutableArray arrayWithObjects:@"", nil];
    _cardB = [NSMutableArray array];
    
    for (int i = 0; i<_cardArr.count; i++) {
        [_cardB addObject:@NO];
    }
    
    UITapGestureRecognizer *tapCardview=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureCardView)];
    [self.maskview addGestureRecognizer:tapCardview];
    
    UITapGestureRecognizer *tapCardview1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureCardView1)];
    [self.maskview1 addGestureRecognizer:tapCardview1];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectCardpay:) name:@"LBMineCenterRechargeBankCardTableViewCell" object:nil];
    
    [[self.MineCenterRechargeCashView.secretTf rac_textSignal] subscribeNext:^(id x) {
    
        if (_sixSecret.length > 6) {
            _sixSecret = [_sixSecret substringToIndex:6];
        }else{
            _sixSecret = [NSString stringWithFormat:@"%@",x];
        }
        
        if (_sixSecret.length == 0) {
            
            [self showimageone:@"" imagetwo:@"" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 1){
            
            [self showimageone:@"XRPlaceholder" imagetwo:@"" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 2){
            
            [self showimageone:@"XRPlaceholder" imagetwo:@"XRPlaceholder" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 3){
            
            [self showimageone:@"XRPlaceholder" imagetwo:@"XRPlaceholder" imagethree:@"XRPlaceholder" imagefour:@"" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 4){
            
            [self showimageone:@"XRPlaceholder" imagetwo:@"XRPlaceholder" imagethree:@"XRPlaceholder" imagefour:@"XRPlaceholder" imagefive:@"" imagesix:@""];
            
        }else if (_sixSecret.length == 5){
            
            [self showimageone:@"XRPlaceholder" imagetwo:@"XRPlaceholder" imagethree:@"XRPlaceholder" imagefour:@"XRPlaceholder" imagefive:@"XRPlaceholder" imagesix:@""];
            
        }else if (_sixSecret.length == 6){
            
            [self showimageone:@"XRPlaceholder" imagetwo:@"XRPlaceholder" imagethree:@"XRPlaceholder" imagefour:@"XRPlaceholder" imagefive:@"XRPlaceholder" imagesix:@"XRPlaceholder"];
            
        }
        
    }];

    
}

-(void)showimageone:(NSString*)imageone imagetwo:(NSString*)imagetwo imagethree:(NSString*)imagethree imagefour:(NSString*)imagefour imagefive:(NSString*)imagefive imagesix:(NSString*)imagesix{
    
    self.MineCenterRechargeCashView.image1.image = [UIImage imageNamed:imageone];
    self.MineCenterRechargeCashView.image2.image = [UIImage imageNamed:imagetwo];
    self.MineCenterRechargeCashView.image3.image = [UIImage imageNamed:imagethree];
    self.MineCenterRechargeCashView.image4.image = [UIImage imageNamed:imagefour];
    self.MineCenterRechargeCashView.image5.image = [UIImage imageNamed:imagefive];
    self.MineCenterRechargeCashView.image6.image = [UIImage imageNamed:imagesix];
    
    
}

- (IBAction)nextEventBt:(UIButton *)sender {
    
    self.maskview1.hidden = NO;
    self.sixSecret = @"";
    [self showimageone:@"" imagetwo:@"" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.MineCenterRechargeCashView.frame = CGRectMake(30, (SCREEN_HEIGHT - 270)/2, SCREEN_WIDTH - 60, 270);
    } completion:^(BOOL finished) {
        [self.MineCenterRechargeCashView.secretTf becomeFirstResponder];
    }];
}


- (IBAction)chooseCard:(UIButton *)sender {
    
    self.maskview.hidden = NO;
    
    [self countCardViewHeigt];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.MineCenterRechargeBankCardView.frame = CGRectMake(30, (SCREEN_HEIGHT - _CardViewH)/2, SCREEN_WIDTH - 60, _CardViewH);
    }];
   
    
}


//计算cardView的高度
-(void)countCardViewHeigt{

    if (_cardArr.count <= 0) {
        _CardViewH = 160;
        self.MineCenterRechargeBankCardView.tableH.constant = 0;
    }else{
        
        if (_cardArr.count <= 3) {
            
            _CardViewH = 160 + 35*_cardArr.count;
            self.MineCenterRechargeBankCardView.tableH.constant = 35*_cardArr.count;
            
        }else{
            
            _CardViewH = 160 + 35*3;
            self.MineCenterRechargeBankCardView.tableH.constant = 35*3;
        }
        
    }
    
    self.MineCenterRechargeBankCardView.dataarr = _cardArr;
    self.MineCenterRechargeBankCardView.selctB = _cardB;
    [self.MineCenterRechargeBankCardView.tableview reloadData];

}


//添加银行卡

-(void)addbankCard{

    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterAddBankCardViewController *vc=[[LBMineCenterAddBankCardViewController alloc]init];
    vc.retrunAddcard = ^(){
    
        for (int i =0; i < 1; i++) {
            [_cardArr addObject:@""];
            [_cardB addObject:@NO];
        }
        
        [self countCardViewHeigt];
        
         self.MineCenterRechargeBankCardView.frame = CGRectMake(30, (SCREEN_HEIGHT - _CardViewH)/2, SCREEN_WIDTH - 60, _CardViewH);
    
    
    };
    [self.navigationController pushViewController:vc animated:YES];

}
//确定选中某银行卡
-(void)sureEvent{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.MineCenterRechargeBankCardView.frame = CGRectMake(30, SCREEN_HEIGHT , SCREEN_WIDTH - 60, 0);
    } completion:^(BOOL finished) {
        self.maskview.hidden = YES;
    }];

}
//点击maskview
-(void)tapgestureCardView{

    [UIView animateWithDuration:0.3 animations:^{
        self.MineCenterRechargeBankCardView.frame = CGRectMake(30, SCREEN_HEIGHT , SCREEN_WIDTH - 60, 0);
    } completion:^(BOOL finished) {
        self.maskview.hidden = YES;
    }];

}
//点击maskview1
-(void)tapgestureCardView1{
    
     [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.MineCenterRechargeCashView.frame = CGRectMake(30, SCREEN_HEIGHT, SCREEN_WIDTH - 60, 270);
    } completion:^(BOOL finished) {
        self.maskview1.hidden = YES;
    }];

}
//点击选中按钮发出的通知
-(void)selectCardpay:(NSNotification*)info{
 
     int a =[info.userInfo[@"index"] intValue];
    
    if (_selctIndex == -1) {
        [_cardB replaceObjectAtIndex:a withObject:@YES];
    }else{
        [_cardB replaceObjectAtIndex:_selctIndex withObject:@NO];
        [_cardB replaceObjectAtIndex:a withObject:@YES];
    }
   
  
    _selctIndex = a;
    self.MineCenterRechargeBankCardView.selctB = _cardB;
    [self.MineCenterRechargeBankCardView.tableview reloadData];
    

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.moneyLb && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    if (textField == self.MineCenterRechargeCashView.secretTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;

}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.nextbt.layer.cornerRadius = 4;
    self.nextbt.clipsToBounds =YES;


}

-(void)MineCenterRechargeCashViewSureButton:(UIButton*)sender{


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}

-(LBMineCenterRechargeBankCardView*)MineCenterRechargeBankCardView{

    if (!_MineCenterRechargeBankCardView) {
        _MineCenterRechargeBankCardView = [[LBMineCenterRechargeBankCardView alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT, SCREEN_WIDTH - 60, 0)];
        
        [_MineCenterRechargeBankCardView.addbt addTarget:self action:@selector(addbankCard) forControlEvents:UIControlEventTouchUpInside];
        [_MineCenterRechargeBankCardView.surebutton addTarget:self action:@selector(sureEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _MineCenterRechargeBankCardView;


}

-(LBMineCenterRechargeCashView*)MineCenterRechargeCashView{
    
    if (!_MineCenterRechargeCashView) {
        _MineCenterRechargeCashView = [[LBMineCenterRechargeCashView alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT, SCREEN_WIDTH - 60, 270)];
        
        [_MineCenterRechargeCashView.surebutton addTarget:self action:@selector(MineCenterRechargeCashViewSureButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _MineCenterRechargeCashView.secretTf.delegate = self;
        
    }
    
    return _MineCenterRechargeCashView;
    
    
}

-(UIView*)maskview{

    if (!_maskview) {
        _maskview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskview.backgroundColor=YYSRGBColor(0, 0, 0, 0.2);
    }
    
    return _maskview;

}

-(UIView*)maskview1{
    
    if (!_maskview1) {
        _maskview1=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskview1.backgroundColor=YYSRGBColor(0, 0, 0, 0.2);
    }
    
    return _maskview1;
    
}

@end
