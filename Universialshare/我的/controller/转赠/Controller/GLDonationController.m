//
//  GLDonationController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDonationController.h"
#import "GLDonationRecordController.h"
#import "GLSet_MaskVeiw.h"
#import "GLNoticeView.h"
#import "LBXScanViewStyle.h"
#import "SubLBXScanViewController.h"


@interface GLDonationController ()<UITextFieldDelegate>
{
    GLSet_MaskVeiw *_maskView;
    LoadWaitView *_loadV;
    BOOL _isHaveDian;//是否有小数点
}
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UITextField *donationIDF;
@property (weak, nonatomic) IBOutlet UITextField *beanNumF;
@property (weak, nonatomic) IBOutlet UITextField *idCodeF;
@property (weak, nonatomic) IBOutlet UITextField *secondPwdF;

@property (weak, nonatomic) IBOutlet UILabel *useableBeanLabel;
@property (weak, nonatomic) IBOutlet UILabel *userableBeanStyleLabel;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation GLDonationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转赠";
//    self.navigationController.navigationBar.hidden = NO;
    self.getCodeBtn.layer.cornerRadius = 5.f;
    self.ensureBtn.layer.cornerRadius = 5.f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //可转赠善行豆
    self.useableBeanLabel.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].mark];
    self.userableBeanStyleLabel.text = @"可转赠米券:";
//    NSString *userType;
//    if ([[UserModel defaultUser].groupId isEqualToString:OrdinaryUser]) {
//        userType = @"米家";
//    }else{
//        userType = @"米商";
//    }
    self.noticeLabel.text = [NSString stringWithFormat:@"*您可以将您的米券转赠给您的会员朋友,或者需要帮助的会员.\n*转赠只能平级才可以转(会员只能给会员转,商户只能给商户转)"];

    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = SCREEN_HEIGHT - 50;
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
    
    //设置键盘return键
    self.donationIDF.returnKeyType = UIReturnKeyNext;
    self.beanNumF.returnKeyType = UIReturnKeyNext;
    self.idCodeF.returnKeyType = UIReturnKeyNext;
    self.secondPwdF.returnKeyType = UIReturnKeyDone;
    self.donationIDF.delegate = self;
    self.beanNumF.delegate = self;
    self.idCodeF.delegate = self;
    self.secondPwdF.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.donationIDF){
        [self.beanNumF becomeFirstResponder];
        
    }else if(textField == self.beanNumF){
        [self.idCodeF becomeFirstResponder];
        
    }else if(textField == self.idCodeF){
        [self.secondPwdF becomeFirstResponder];
  
    }else if(textField == self.secondPwdF){
        [self.secondPwdF resignFirstResponder];
   
    }
    return YES;
}

- (IBAction)getCodeBtnClick:(id)sender {
    [self startTime];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"phone"] = [UserModel defaultUser].phone;

//    NSLog(@"%@",dict);
    [NetworkManager requestPOSTWithURLStr:@"user/get_yzm" paramDic:dict finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"验证码已发送！"];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

//扫码
- (IBAction)scanning:(id)sender {
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    
    style.animationImage = imgFullNet;
    
    
    [self openScanVCWithStyle:style];
}
- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;

    //vc.isOpenInterestRect = YES;
    vc.retureCode = ^(NSString *codeStr){
        
        self.donationIDF.text = codeStr;
        
    };

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//确定按钮事件
- (IBAction)ensureBtnClick:(id)sender {
    
//    GLPlatformDonationController *platVC = [[GLPlatformDonationController alloc] init];
//    [self.navigationController pushViewController:platVC animated:YES];
    
    //输入判断
    if (self.donationIDF.text == nil||self.donationIDF.text.length == 0) {
        [MBProgressHUD showError:@"请输入获赠人ID"];
        return;
    }
    if (self.beanNumF.text == nil||self.beanNumF.text.length == 0) {
        [MBProgressHUD showError:@"请输入转赠数量"];
        return;
    }else if(![self isPureNumandCharacters:self.beanNumF.text]){
        [MBProgressHUD showError:@"转赠数量只能是正整数"];
        return;
    }
    if ([self.beanNumF.text integerValue] >[[UserModel defaultUser].mark integerValue]) {
        [MBProgressHUD showError:@"余额不足"];
        return;
    }
    if (self.idCodeF.text == nil||self.idCodeF.text.length == 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }else if (![self isPureNumandCharacters:self.idCodeF.text]){
        [MBProgressHUD showError:@"验证码是数字"];
        return;
    }
    if (self.secondPwdF.text == nil||self.secondPwdF.text.length == 0) {
        [MBProgressHUD showError:@"请输入二级密码"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = self.donationIDF.text;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/get_give_id" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            
            CGFloat contentViewH = 200;
            CGFloat contentViewW = SCREEN_WIDTH - 40;
            _maskView = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            _maskView.bgView.alpha = 0.4;
            
            GLNoticeView *contentView = [[NSBundle mainBundle] loadNibNamed:@"GLNoticeView" owner:nil options:nil].lastObject;
            contentView.frame = CGRectMake(20, (SCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
            contentView.layer.cornerRadius = 4;
            contentView.layer.masksToBounds = YES;
            [contentView.cancelBtn addTarget:self action:@selector(cancelDonation) forControlEvents:UIControlEventTouchUpInside];
            [contentView.ensureBtn addTarget:self action:@selector(ensureDonation) forControlEvents:UIControlEventTouchUpInside];
            contentView.contentLabel.text = [NSString stringWithFormat:@"您是否要将米券转赠给%@",responseObject[@"data"][@"count"]];
            [_maskView showViewWithContentView:contentView];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];

}
- (void)cancelDonation{
    [UIView animateWithDuration:0.2 animations:^{
        
        _maskView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        
    }];
    
}
//确认捐赠

-(void)ensureDonation{
 
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"number"] = self.beanNumF.text;
    dict[@"DonationID"] = self.donationIDF.text;
    dict[@"yzm"] = self.idCodeF.text;
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.secondPwdF.text publicKey:public_RSA];
    dict[@"password"] = encryptsecret;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/give_to" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            
            [UIView animateWithDuration:0.2 animations:^{
                _maskView.alpha = 0;
            }completion:^(BOOL finished) {
                
                [_maskView removeFromSuperview];
            }];
    
            [MBProgressHUD showError:responseObject[@"message"]];
            
            self.secondPwdF.text = nil;
            self.donationIDF.text = nil;
            self.idCodeF.text = nil;
            self.beanNumF.text = nil;
            
//            NSString *useableNum = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].mark floatValue] - [self.beanNumF.text floatValue]];
//            
//            self.useableBeanLabel.text = useableNum;
//            self.userableBeanStyleLabel.text = @"可转赠米券:";
//            [MBProgressHUD showSuccess:@"转赠成功"];

            [self refreshDataSource];
        }else{
            [_loadV removeloadview];
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
//刷新数据
-(void)refreshDataSource{
    
    [NetworkManager requestPOSTWithURLStr:@"user/refresh" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            [UserModel defaultUser].mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].loveNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lovenum"]];
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"common"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"taxes"]];
            [UserModel defaultUser].giveMeMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"give_me_bean"]];
            [UserModel defaultUser].lastFanLiTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lasttime"]];
            [UserModel defaultUser].recommendMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"tjtc"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].shop_address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_address"]];
            [UserModel defaultUser].shop_type = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_type"]];
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].headPic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pic"]];
            [UserModel defaultUser].AudiThrough = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"status"]];
            
            if ([[UserModel defaultUser].idcard rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].idcard = @"";
            }
            if ([[UserModel defaultUser].shop_type rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].shop_type = @"";
            }
            if ([[UserModel defaultUser].shop_address rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].shop_address = @"";
            }
            if ([[UserModel defaultUser].truename rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].banknumber = @"";
            }
            
            [usermodelachivar achive];
            self.useableBeanLabel.text = [UserModel defaultUser].mark;
            self.userableBeanStyleLabel.text = @"可转赠米券:";
            [MBProgressHUD showSuccess:@"转赠成功"];

        }else{
           
        }
        
    } enError:^(NSError *error) {
        
    }];
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//转赠记录
- (IBAction)donationRecord:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLDonationRecordController *recordVC = [[GLDonationRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.beanNumF || textField == self.secondPwdF || textField == self.idCodeF) {
        return [self validateNumber:string];
    }
    
    return YES;
}
//只能输入整数
- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
@end
