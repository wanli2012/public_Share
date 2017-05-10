//
//  LBImprovePersonalDataViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/18.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBImprovePersonalDataViewController.h"
#import "GLLoginController.h"
#import "BaseNavigationViewController.h"

@interface LBImprovePersonalDataViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;

@property (weak, nonatomic) IBOutlet UIImageView *manImage;
@property (weak, nonatomic) IBOutlet UIImageView *womanimage;

@property (weak, nonatomic) IBOutlet UITextField *sixSecretTf;
@property (weak, nonatomic) IBOutlet UITextField *sixSecretTf1;
@property (weak, nonatomic) IBOutlet UITextField *adressTf;
@property (weak, nonatomic) IBOutlet UIButton *surebutton;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UIButton *exitbt;

@property (strong, nonatomic)NSString *sexstr;
@property (strong, nonatomic)NSString *status;//判断登录是否过期

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;

@end

@implementation LBImprovePersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sexstr=[NSString string];
    self.sexstr = @"男";
    
    self.status = @"0";
    
}

- (IBAction)exitButton:(UIButton *)sender {
    
    
    if ([self.status isEqualToString:@"1"]) {
        
        GLLoginController *loginVC = [[GLLoginController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
    }
}


- (IBAction)surebutton:(UIButton *)sender {
    
    if (self.nameTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    if (self.codeTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入身份证"];
        return;
    }else{
        if (![predicateModel validateIdentityCard:self.codeTf.text]) {
            [MBProgressHUD showError:@"请输入正确的身份证"];
            return;
        }
    }
    
    if (self.sixSecretTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (self.sixSecretTf1.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码"];
        return;
    }
    
    if (self.sixSecretTf1.text.length != 6) {
        [MBProgressHUD showError:@"请输入6位密码"];
        return;
    }
    
    if (![self.sixSecretTf1.text isEqualToString:self.sixSecretTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    if (self.adressTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入地址"];
        return;
    }
    
     NSString *encryptsecret = [RSAEncryptor encryptString:self.sixSecretTf.text publicKey:public_RSA];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/userInfoBq" paramDic:@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid , @"truename":self.nameTf.text , @"idcard":self.codeTf.text, @"sexer":self.sexstr ,@"twopwd":encryptsecret , @"address":self.adressTf.text} finish:^(id responseObject) {
        [_loadV removeloadview];
     
        if ([responseObject[@"status"] integerValue]==1) {
            self.status = @"1";
            [self.exitbt setTitle:@"重新登录" forState:UIControlStateNormal];
        }
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showError:responseObject[@"message"]];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [UserModel defaultUser].truename = self.nameTf.text;
            [UserModel defaultUser].idcard = self.codeTf.text;
   
            [usermodelachivar achive];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
    
    
    
}
- (IBAction)tapgesturewoman:(UITapGestureRecognizer *)sender {
    
    self.sexstr = @"女";
    self.manImage.image = [UIImage imageNamed:@"location_off"];
    self.womanimage.image = [UIImage imageNamed:@"location_on"];
    
}

- (IBAction)tapgestureMan:(UITapGestureRecognizer *)sender {
    
    self.sexstr = @"男";
    self.manImage.image = [UIImage imageNamed:@"location_on"];
    self.womanimage.image = [UIImage imageNamed:@"location_off"];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.nameTf && [string isEqualToString:@"\n"]) {
        [self.codeTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.codeTf && [string isEqualToString:@"\n"]){
        
        [self.sixSecretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.sixSecretTf && [string isEqualToString:@"\n"]){
        
        [self.sixSecretTf1 becomeFirstResponder];
        return NO;
    }else if (textField == self.sixSecretTf1 && [string isEqualToString:@"\n"]){
        
        [self.adressTf becomeFirstResponder];
        return NO;
    }else if (textField == self.adressTf && [string isEqualToString:@"\n"]) {
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.codeTf ) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    if (textField == self.nameTf && ![string isEqualToString:@""]) {
        //只能输入英文或中文
        NSCharacterSet * charact;
        charact = [[NSCharacterSet characterSetWithCharactersInString:NMUBERS]invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:charact]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if(canChange) {
            [MBProgressHUD showError:@"只能输入英文或中文"];
            return NO;
        }
    }
    
    
    return YES;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.contentW.constant =SCREEN_WIDTH;
    self.contentH.constant =SCREEN_HEIGHT - 64;

}

@end
