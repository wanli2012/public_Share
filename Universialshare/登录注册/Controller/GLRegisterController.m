//
//  GLRegisterController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRegisterController.h"


@interface GLRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *recomendId;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *secretTf;
@property (weak, nonatomic) IBOutlet UITextField *sureSecretTf;
@property (weak, nonatomic) IBOutlet UITextField *verificationTf;
@property (weak, nonatomic) IBOutlet UIButton *getcodeBt;
@property (weak, nonatomic) IBOutlet UIButton *registerBt;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
//获取验证码
- (IBAction)getcode:(UIButton *)sender {
    
    if (self.phoneTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"user/get_yzm" paramDic:@{@"phone":self.phoneTf.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
}
//注册
- (IBAction)regsiterEventBt:(UIButton *)sender {
    
    if (self.recomendId.text.length <= 0) {
        [MBProgressHUD showError:@"推荐人ID不能为空"];
        return;
    }
    if (self.phoneTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    if (self.secretTf.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.secretTf.text.length < 6 || self.secretTf.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-20位密码"];
        return;
    }
    
    if ([predicateModel checkIsHaveNumAndLetter:self.secretTf.text] != 3) {
        
        [MBProgressHUD showError:@"密码须包含数字和字母"];
        return;
    }
    
    if (self.sureSecretTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码"];
        return;
    }
    
    if (![self.secretTf.text isEqualToString:self.sureSecretTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    if (self.verificationTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
//    NSString *encryptphone = [RSAEncryptor encryptString:self.phoneTf.text publicKey:public_RSA];
      NSString *encryptsecret = [RSAEncryptor encryptString:self.secretTf.text publicKey:public_RSA];
//    NSString *encryptrecoemd = [RSAEncryptor encryptString:self.recomendId.text publicKey:public_RSA];
//    NSString *encrypteyzm = [RSAEncryptor encryptString:self.verificationTf.text publicKey:public_RSA];

 
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/register" paramDic:@{@"userphone":self.phoneTf.text , @"password":encryptsecret , @"uid":self.recomendId.text , @"yzm":self.verificationTf.text} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
             [MBProgressHUD showError:responseObject[@"message"]];
             [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.recomendId && [string isEqualToString:@"\n"]) {
        [self.phoneTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.phoneTf && [string isEqualToString:@"\n"]){
        
         [self.secretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.secretTf && [string isEqualToString:@"\n"]){
        
        [self.sureSecretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.sureSecretTf && [string isEqualToString:@"\n"]){
        
        [self.verificationTf becomeFirstResponder];
        return NO;
    }else if (textField == self.verificationTf && [string isEqualToString:@"\n"]) {
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.recomendId || textField == self.phoneTf ||self.sureSecretTf || self.secretTf||self.verificationTf) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    return YES;
    
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
                [self.getcodeBt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getcodeBt.userInteractionEnabled = YES;
                self.getcodeBt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                 self.getcodeBt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getcodeBt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getcodeBt.userInteractionEnabled = NO;
                self.getcodeBt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.getcodeBt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

@end
