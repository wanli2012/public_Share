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

@interface LBImprovePersonalDataViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;

@property (weak, nonatomic) IBOutlet UITextField *sixSecretTf;
@property (weak, nonatomic) IBOutlet UITextField *sixSecretTf1;
@property (weak, nonatomic) IBOutlet UIButton *surebutton;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UIButton *exitbt;

@property (strong, nonatomic)NSString *status;//判断登录是否过期

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;

@property (weak, nonatomic) IBOutlet UIImageView *positiveImage;//身份证正面

@property (weak, nonatomic) IBOutlet UIImageView *otherImage;//身份证反面
@property (weak, nonatomic) IBOutlet UIImageView *saleImage;//消费承诺书

@property (assign, nonatomic)NSInteger tapIndex;//判断点击的是那个图片

@end

@implementation LBImprovePersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
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

//选择正面
- (IBAction)tapgesturepositiveImage:(UITapGestureRecognizer *)sender {
    _tapIndex = 1;
    [self tapgesturephotoOrCamera];
}
//选择反面
- (IBAction)tapgestureotherimage:(UITapGestureRecognizer *)sender {
    _tapIndex = 2;
    [self tapgesturephotoOrCamera];
}
//消费承诺书
- (IBAction)tapgesturepromiseImage:(UITapGestureRecognizer *)sender {
    _tapIndex = 2;
    [self tapgesturephotoOrCamera];
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
    
    
    
    if (!self.positiveImage.image || [UIImagePNGRepresentation(self.positiveImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"样板-拷贝"])]) {
        [MBProgressHUD showError:@"请上传身份证正面照"];
        return;
    }
    
    if (!self.otherImage.image || [UIImagePNGRepresentation(self.otherImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝"])]) {
        [MBProgressHUD showError:@"请上传身份证反面照"];
        return;
    }
    
    
    if (!self.saleImage.image || [UIImagePNGRepresentation(self.saleImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-4"])]) {
        [MBProgressHUD showError:@"请上传消费承诺书"];
        return;
    }
    
    
    
//     NSString *encryptsecret = [RSAEncryptor encryptString:self.sixSecretTf.text publicKey:public_RSA];
//    
//    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//    [NetworkManager requestPOSTWithURLStr:@"user/userInfoBq" paramDic:@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid , @"truename":self.nameTf.text , @"idcard":self.codeTf.text ,@"twopwd":encryptsecret ,} finish:^(id responseObject) {
//        [_loadV removeloadview];
//     
//        if ([responseObject[@"status"] integerValue]==1) {
//            self.status = @"1";
//            [self.exitbt setTitle:@"重新登录" forState:UIControlStateNormal];
//        }
//        if ([responseObject[@"code"] integerValue]==1) {
//            [MBProgressHUD showError:responseObject[@"message"]];
//            [self dismissViewControllerAnimated:YES completion:nil];
//            
//            [UserModel defaultUser].truename = self.nameTf.text;
//            [UserModel defaultUser].idcard = self.codeTf.text;
//   
//            [usermodelachivar achive];
//            
//        }else{
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//    } enError:^(NSError *error) {
//        [_loadV removeloadview];
//        [MBProgressHUD showError:error.localizedDescription];
//        
//    }];
    
    
}

//选择图片来源
-(void)tapgesturephotoOrCamera{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
    
}

-(void)getpicture{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //    // 设置选择后的图片可以被编辑
    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    picker.allowsEditing = YES;
    //6.推送
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)getcamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可以被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.1);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.1);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        switch (self.tapIndex) {
            case 1:
            {
                self.positiveImage.image = [UIImage imageWithData:data];
            }
                break;
            case 2:
            {
                self.otherImage.image = [UIImage imageWithData:data];
            }
                break;
            case 3:
            {
                self.saleImage.image = [UIImage imageWithData:data];
            }
                break;
           
                
            default:
                break;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
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
    self.contentH.constant =670;

}

@end
