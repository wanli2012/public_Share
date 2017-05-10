//
//  GLBuyBackController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLBuyBackController.h"
#import "GLBuyBackChooseCardController.h"
#import "GLSet_MaskVeiw.h"
#import "GLDirectDnationView.h"
#import "GLBuyBackRecordController.h"
#import "GLNoticeView.h"
#import "UIImageView+WebCache.h"

#import "GLBuyBackChooseController.h"
#import "GLBankCardModel.h"

@interface GLBuyBackController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    GLDirectDnationView *_directV;
    GLSet_MaskVeiw * _maskV;
    LoadWaitView *_loadV;
    NSInteger _buyBackType;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beanStyleLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
//兑换数量
@property (weak, nonatomic) IBOutlet UITextField *buybackNumF;

//二级密码
@property (weak, nonatomic) IBOutlet UITextField *secondPwdF;

@property (weak, nonatomic) IBOutlet UILabel *remainBeanLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainBeanStyleLabel;
//修改银行卡
@property (weak, nonatomic) IBOutlet UIImageView *bankStyleImageV;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardStyleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImageV;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageV;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIView *headView;


@end

@implementation GLBuyBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"兑换";
    self.view.backgroundColor = [UIColor whiteColor];
    self.headView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;

    self.ensureBtn.layer.cornerRadius = 5.f;
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];

    self.scrollView.delegate = self;

    self.noticeLabel.text = [NSString stringWithFormat:@" 1. 兑换建议优先选择工商银行\n 2. 单笔最多兑换50000颗米子\n 3.T+1:一天后到账,手续费为兑换数量的6%%\n    T+3:三天后到账,手续费为兑换数量的3%%\n    T+7:七天后到账,手续费为5颗米子 "] ;

//    [UILabel changeLineSpaceForLabel:self.noticeLabel WithSpace:5.0];

    self.remainBeanLabel.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue]];
    self.remainBeanStyleLabel.text = @"可兑换米子:";
    self.buybackNumF.placeholder = @"请输入100的整数倍";
    
    self.buybackNumF.returnKeyType = UIReturnKeyNext;
    self.secondPwdF.returnKeyType = UIReturnKeyDone;
    
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = SCREEN_HEIGHT;
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//    }else{
//        self.contentViewHeight.constant = SCREEN_HEIGHT + 100;
//        
//    }
    
    [self updateBankInfo];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(changeBankNum:) name:@"deleteBankCardNotification" object:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if(offsetY < 0) {
        CGRect currentFrame = self.headView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = 100 - 1*offsetY;
        self.headView.frame = currentFrame;
       
    }
}
- (void)updateData {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
//    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/refresh" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
//        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1){
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]] rangeOfString:@"null"].location != NSNotFound) {
                [UserModel defaultUser].banknumber = @"";
            }else{
                [UserModel defaultUser].banknumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]];
            }
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"][@"bankname"]] rangeOfString:@"null"].location != NSNotFound) {
                [UserModel defaultUser].defaultBankname = @"";
            }else{
                
                [UserModel defaultUser].defaultBankname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bankname"]];
            }
            
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"common"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"taxes"]];
            [UserModel defaultUser].banknumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]];
            [UserModel defaultUser].defaultBankname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bankname"]];
            
            [usermodelachivar achive];
            
            if ([self.beanStyleLabel.text isEqualToString:NormalMoney]) {

                self.remainBeanLabel.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue]];
                self.remainBeanStyleLabel.text = @"可兑换米子:";
            }else{

                self.remainBeanLabel.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].djs_bean floatValue]];
                self.remainBeanStyleLabel.text = @"可兑换推荐米子:";
            }
            
        }
        
//        [self updateBankInfo];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.buybackNumF || textField == self.secondPwdF) {
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
//移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        _maskV.alpha = 0;
    } completion:^(BOOL finished) {
        [_maskV removeFromSuperview];
        
    }];
}
- (void)showBankInfo{
    self.bankStyleImageV.hidden = NO;
    self.cardNumLabel.hidden = NO;
    self.cardStyleLabel.hidden = NO;
    self.detailImageV.hidden = NO;
    
    self.addImageV.hidden = YES;
    self.addLabel.hidden = YES;
}
- (void)hideBankInfo {
    self.bankStyleImageV.hidden = YES;
    self.cardNumLabel.hidden = YES;
    self.cardStyleLabel.hidden = YES;
    self.detailImageV.hidden = YES;
    
    self.addImageV.hidden = NO;
    self.addLabel.hidden = NO;

}
- (void)updateBankInfo {
    
    if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].banknumber] rangeOfString:@"null"].location != NSNotFound){

        [self showBankInfo];
    }else{
        
        [self hideBankInfo];
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/getbank" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
//        NSLog(@"responseObject = %@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1){
            [self showBankInfo];
            NSArray *arr = responseObject[@"data"];
            if (arr.count != 0) {
                
                self.cardNumLabel.text = responseObject[@"data"][0][@"number"];
                self.cardStyleLabel.text = responseObject[@"data"][0][@"name"];
               
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    if([dic[@"status"] intValue] == 1){
                        
                        self.cardNumLabel.text = dic[@"number"];
                        self.cardStyleLabel.text = dic[@"name"];
                    }
                    
                }
                if ([self.cardStyleLabel.text isEqualToString:@"中国银行"]) {
                    self.bankStyleImageV.image = [UIImage imageNamed:@"BOC"];
                    
                }else if ([self.cardStyleLabel.text isEqualToString:@"中国工商银行"]){
                    self.bankStyleImageV.image = [UIImage imageNamed:@"ICBC"];
                    
                }else if ([self.cardStyleLabel.text isEqualToString:@"中国建设银行"]){
                    self.bankStyleImageV.image = [UIImage imageNamed:@"CCB"];
                    
                }else {
                    self.bankStyleImageV.image = [UIImage imageNamed:@"ABC"];
                }
            }else{
                [self hideBankInfo];
            }
            
        }else{
            [self hideBankInfo];

        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.buybackNumF){
        [self.secondPwdF becomeFirstResponder];
        
    }else if(textField == self.secondPwdF){
        [self.secondPwdF becomeFirstResponder];
        
    }
    return YES;
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
- (IBAction)ensureClick:(id)sender {

    if ([[NSString stringWithFormat:@"%ld",[self.cardNumLabel.text integerValue]] isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"请输入银行卡号"];
        return;
    }
    if ([[NSString stringWithFormat:@"%ld",[self.buybackNumF.text integerValue]] isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"请输入兑换数量"];
        return;
    }else if(![self isPureNumandCharacters:self.buybackNumF.text]){
        [MBProgressHUD showError:@"兑换数量只能为正整数"];
        return;
    }else if([self.buybackNumF.text integerValue] > [self.remainBeanLabel.text integerValue]){
        [MBProgressHUD showError:@"余额不足!"];
        return;
    }
    
    if ([self.buybackNumF.text integerValue] %100 != 0){
            [MBProgressHUD showError:@"数量必须是100的整数倍!"];
            return;
    }

    if ( [self.buybackNumF.text integerValue] > 50000){
        [MBProgressHUD showError:[NSString stringWithFormat:@"单笔最多兑换50000颗%@",NormalMoney]];
        return;
    }
    if (self.secondPwdF.text == nil||self.secondPwdF.text.length == 0) {
        [MBProgressHUD showError:@"请输入二级密码"];
        return;
    }

    [self showOkayCancelAlert];

}
- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"请选择类型", nil);
    NSString *message = NSLocalizedString(@"", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *T1ButtonTitle = NSLocalizedString(@"T + 1 (手续费为6%)", nil);
    NSString *T3ButtonTitle = NSLocalizedString(@"T + 3 (手续费为3%)", nil);
    NSString *T7ButtonTitle = NSLocalizedString(@"T + 7 (手续费为5颗米子)", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    
    CGFloat contentViewH = 200;
    CGFloat contentViewW = SCREEN_WIDTH - 40;
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _maskV.bgView.alpha = 0.4;
    
    GLNoticeView *contentView = [[NSBundle mainBundle] loadNibNamed:@"GLNoticeView" owner:nil options:nil].lastObject;
    contentView.frame = CGRectMake(20, (SCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    [contentView.cancelBtn addTarget:self action:@selector(cancelBuyback) forControlEvents:UIControlEventTouchUpInside];
    [contentView.ensureBtn addTarget:self action:@selector(ensureBuyback) forControlEvents:UIControlEventTouchUpInside];
    

    UIAlertAction *T1Action = [UIAlertAction actionWithTitle:T1ButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([self.beanStyleLabel.text isEqualToString:NormalMoney]) {
            _buyBackType = 1;
            contentView.contentLabel.text = [NSString stringWithFormat:@"手续费为兑换数量的6%%"];
        }else{
            
            contentView.contentLabel.text = [NSString stringWithFormat:@"手续费为兑换数量的6%%"];
        }
        
        [_maskV showViewWithContentView:contentView];

    }];
    UIAlertAction *T3Action = [UIAlertAction actionWithTitle:T3ButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self.beanStyleLabel.text isEqualToString:NormalMoney]) {
            _buyBackType = 2;
            contentView.contentLabel.text = [NSString stringWithFormat:@"手续费为兑换数量的3%%"];
        }else{
            
            contentView.contentLabel.text = [NSString stringWithFormat:@"手续费为兑换数量的3%%"];
        }
        
        [_maskV showViewWithContentView:contentView];
        
    }];
    UIAlertAction *T7Action = [UIAlertAction actionWithTitle:T7ButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([self.beanStyleLabel.text isEqualToString:NormalMoney]) {
            _buyBackType = 3;
            contentView.contentLabel.text = [NSString stringWithFormat:@"手续费为5颗米子"];
        }else{
            
            contentView.contentLabel.text = [NSString stringWithFormat:@"手续费为5颗米子"];
        }
        
        [_maskV showViewWithContentView:contentView];

    }];

    [alertController addAction:cancelAction];
    [alertController addAction:T1Action];
    [alertController addAction:T3Action];
    [alertController addAction:T7Action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)cancelBuyback {
    [UIView animateWithDuration:0.2 animations:^{
        
        _maskV.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [_maskV removeFromSuperview];
        
    }];

}
- (void)ensureBuyback{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    NSString *num = [NSString stringWithFormat:@"%d",[self.buybackNumF.text intValue]];
    dict[@"num"] = num;
    dict[@"IDcar"] = self.cardNumLabel.text;
    //开户行地址  ???
//    dict[@"address"] = self.cardStyleLabel.text;
    NSString *encryptsecret = [RSAEncryptor encryptString:self.secondPwdF.text publicKey:public_RSA];
    dict[@"password"] = encryptsecret;
    dict[@"type"] = [NSString stringWithFormat:@"%lu",_buyBackType];
    if ([self.beanStyleLabel.text isEqualToString:NormalMoney]) {
        dict[@"donatetype"] = @"1";
    }else{
        dict[@"donatetype"] = @"0";
    }
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/back" paramDic:dict finish:^(id responseObject) {
        NSLog(@"dict  = %@",dict);
        NSLog(@"%@",responseObject);
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1) {
            [self cancelBuyback];
            self.secondPwdF.text = nil;
            self.buybackNumF.text = nil;
            
            //刷新信息
            [self updateData];
             [MBProgressHUD showSuccess:@"兑换申请成功"];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];

}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//跳转兑换记录
- (IBAction)buyBackRecord:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLBuyBackRecordController *recordVC = [[GLBuyBackRecordController alloc] init];
    
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (IBAction)chooseBank:(id)sender {
    [self.buybackNumF resignFirstResponder];
    [self.secondPwdF resignFirstResponder];
    if (self.addImageV.hidden) {
        self.hidesBottomBarWhenPushed = YES;
        
        GLBuyBackChooseController *chooseVC = [[GLBuyBackChooseController alloc] init];
        
        [chooseVC returnModel:^(GLBankCardModel *model) {
            self.cardNumLabel.text = model.number;
            self.cardStyleLabel.text = model.name;
            self.bankStyleImageV.image = [UIImage imageNamed:model.iconName];
        }];
        [self.navigationController pushViewController:chooseVC animated:YES];
        
    }else{
        
        self.hidesBottomBarWhenPushed = YES;
        GLBuyBackChooseCardController *chooseVC = [[GLBuyBackChooseCardController alloc] init];
//        chooseVC.block = ^(NSString *cardNum){
//            [self updateBankInfo];
//        };
        __weak typeof(self) weakself = self;
        chooseVC.returnBlock = ^(NSString *str){
            [weakself updateBankInfo];
        };
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
    
}
- (void)changeBankNum:(NSNotification *)notification {
    if ([self.cardNumLabel.text isEqualToString:notification.userInfo[@"banknumber"]]) {
        [self updateBankInfo];
    }
}

- (IBAction)chooseStyle:(id)sender {
    
//    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _maskV.bgView.alpha = 0.1;
////
//    _directV = [[NSBundle mainBundle] loadNibNamed:@"GLDirectDnationView" owner:nil options:nil].lastObject;
//    [_directV.normalBtn addTarget:self action:@selector(chooseValue:) forControlEvents:UIControlEventTouchUpInside];
//    [_directV.taxBtn addTarget:self action:@selector(chooseValue:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    CGRect rect=[self.chooseBtn convertRect: self.chooseBtn.bounds toView:window];
//    
//    _directV.frame = CGRectMake(0,CGRectGetMaxY(rect), SCREEN_WIDTH, 3 * self.chooseBtn.yy_height);
//    _directV.backgroundColor = [UIColor whiteColor];
//    _directV.layer.cornerRadius = 4;
//    _directV.layer.masksToBounds = YES;
//    
//    [_maskV showViewWithContentView:_directV];
    
}
- (void)chooseValue:(UIButton *)sender {
    
    if (sender== _directV.normalBtn) {
        self.beanStyleLabel.text = NormalMoney;
        self.remainBeanLabel.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue]];
        self.remainBeanStyleLabel.text = @"可兑换米子:";
    }else{
//        if([[UserModel defaultUser].userLogin integerValue] == 1){
            self.beanStyleLabel.text = SpecialMoney;
//
//        }else{
//            
//            self.beanStyleLabel.text = @"待提供发票志愿豆";
//        }
        self.remainBeanLabel.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].djs_bean floatValue]];
        self.remainBeanStyleLabel.text = @"可兑换推荐米子:";
    }
    [self dismiss];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self updateData];

   
}

@end
