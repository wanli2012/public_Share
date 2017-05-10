//
//  LBBelowTheLineViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBelowTheLineViewController.h"
#import "IncentiveModel.h"

@interface LBBelowTheLineViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UIView *baseView1;
@property (weak, nonatomic) IBOutlet UIView *baseView2;
@property (weak, nonatomic) IBOutlet UIView *baseview3;
@property (weak, nonatomic) IBOutlet UIView *baseView4;
@property (weak, nonatomic) IBOutlet UIView *baseView5;
@property (weak, nonatomic) IBOutlet UIView *baseView6;
@property (weak, nonatomic) IBOutlet UIView *baseView7;
@property (weak, nonatomic) IBOutlet UIButton *codeBt;
@property (weak, nonatomic) IBOutlet UIButton *comitbt;

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *modeltf;
@property (weak, nonatomic) IBOutlet UITextField *moneyTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *numTf;
@property (weak, nonatomic) IBOutlet UITextField *yuliuTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getNewCode;


@property (strong, nonatomic)IncentiveModel *incentiveModelV;
@property (strong, nonatomic)UIView *incentiveModelMaskV;
@property (nonatomic, assign) NSInteger userytpe; // 让利类型 1 20% 2 10% 3 5%

@property (nonatomic, assign) NSInteger documentType; // 1为打款凭证，2为消费凭证
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UIImageView *TriangleImage;


@end

@implementation LBBelowTheLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"线下下单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITapGestureRecognizer *incentiveModelMaskVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incentiveModelMaskVtapgestureLb)];
    [self.incentiveModelMaskV addGestureRecognizer:incentiveModelMaskVgesture];
    
    int num = (arc4random() % 10000);
    NSString *randomNumber = [NSString stringWithFormat:@"%.4d", num];
    
    self.yuliuTf.text = randomNumber;
    
}

//重新生成生成预留信息
- (IBAction)getNewCodeEvent:(UIButton *)sender {
    
    int num = (arc4random() % 10000);
    NSString *randomNumber = [NSString stringWithFormat:@"%.4d", num];
    
    self.yuliuTf.text = randomNumber;
}


//选择激励模式
- (IBAction)choseJiliModel:(UITapGestureRecognizer *)sender {
   

    self.TriangleImage.transform = CGAffineTransformMakeRotation(M_PI);

    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.baseView2 convertRect: self.baseView2.bounds toView:window];
    
    self.incentiveModelV.frame=CGRectMake(SCREEN_WIDTH-130, rect.origin.y+20, 120, 120);
    
    [self.view addSubview:self.incentiveModelMaskV];
    [self.incentiveModelMaskV addSubview:self.incentiveModelV];
}
//打款凭证
- (IBAction)choseimageone:(UITapGestureRecognizer *)sender {
    self.documentType = 1;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
}
//消费凭证
- (IBAction)choseimageTwo:(UITapGestureRecognizer *)sender {
    self.documentType = 2;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
}


//获取验证码
- (IBAction)getcodeEvent:(UIButton *)sender {
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"user/get_yzm" paramDic:@{@"phone":[UserModel defaultUser].phone} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
}
//提交
- (IBAction)submitInfoEvent:(UIButton *)sender {
    
    if (self.phoneTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写购买会员"];
        return;
    }
    if (self.modeltf.text.length <= 0) {
        [MBProgressHUD showError:@"请选择激励模式"];
        return;
    }
    if (self.moneyTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写消费金额"];
        return;
    }else{
        if ([self.moneyTf.text hasPrefix:@"."] || [self.moneyTf.text hasSuffix:@"."]) {
            [MBProgressHUD showError:@"消费金额格式错误"];
            return;
        }
    }
    
    if (self.nameTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写商品名称"];
        return;
    }
    if (self.numTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写商品数量"];
        return;
    }
    if (self.codeTf.text.length <= 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    if (!self.imageOne.image || [UIImagePNGRepresentation(self.imageOne.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-9"])]) {
        [MBProgressHUD showError:@"请上传打款凭证"];
        return;
    }
    if (!self.imageTwo.image || [UIImagePNGRepresentation(self.imageTwo.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-9"])]) {
        [MBProgressHUD showError:@"请上传消费凭证"];
        return;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"user/getTrueName" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"username" :self.phoneTf.text} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                NSString *str=[NSString stringWithFormat:@"确定向%@下单吗?",responseObject[@"data"][@"truename"]];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSDictionary  *dic=@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid , @"username":self.phoneTf.text , @"yzm":self.codeTf.text,@"rlmodel_type":[NSNumber numberWithInteger:self.userytpe],@"money":self.moneyTf.text,@"shopname":self.nameTf.text,@"shopnum":self.numTf.text,@"code":self.yuliuTf.text};
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 20;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@user/placeOrderLine",URL_Base] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            if (self.imageOne.image) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@one.png",str];
                NSData *data = UIImagePNGRepresentation(self.imageOne.image);
                [formData appendPartWithFileData:data name:@"dkpz" fileName:fileName mimeType:@"image/png"];
            }
            if (self.imageTwo.image) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@two.png",str];
                NSData *data = UIImagePNGRepresentation(self.imageOne.image);
                [formData appendPartWithFileData:data name:@"xfpz" fileName:fileName mimeType:@"image/png"];
            }
            
            
        }progress:^(NSProgress *uploadProgress){
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD setCornerRadius:8.0];
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
            
        }success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [SVProgressHUD dismiss];
            if ([dic[@"code"]integerValue]==1) {
                
                [MBProgressHUD showError:dic[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD showError:dic[@"message"]];
            }
            [_loadV removeloadview];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
        }];
                
    }
    
}
//结束编辑
- (IBAction)endeditEvent:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self getpicture];//获取相册
        }break;
            
        case 1:{
            [self getcamera];//获取照相机
        }break;
        default:
            break;
    }
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
        if (self.documentType == 1) {
            self.imageOne.image = [UIImage imageWithData:data];
        }else if (self.documentType == 2){
            self.imageTwo.image = [UIImage imageWithData:data];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTf && [string isEqualToString:@"\n"]) {
        [self.moneyTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.moneyTf && [string isEqualToString:@"\n"]){
        
        [self.nameTf becomeFirstResponder];
        return NO;
    }else if (textField == self.nameTf && [string isEqualToString:@"\n"]){
        
        [self.numTf becomeFirstResponder];
        return NO;
    }else if (textField == self.numTf && [string isEqualToString:@"\n"]){
        
        [self.codeTf becomeFirstResponder];
        return NO;
    }else if (textField == self.codeTf && [string isEqualToString:@"\n"]) {
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.phoneTf) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    return YES;
    
}


#pragma mark - 点击激励模式选择

-(void)sixbuttonE{
    self.userytpe=3;
    self.modeltf.text=@"5%激励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}
-(void)twenteenButtonE{
    self.userytpe=2;
    self.modeltf.text=@"10%激励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}
-(void)twentyFbuttonE{
    self.userytpe=1;
    self.modeltf.text=@"20%激励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}

//点击maskview
-(void)incentiveModelMaskVtapgestureLb{
    
    [self.incentiveModelMaskV removeFromSuperview];
    [self.incentiveModelV removeFromSuperview];
    self.TriangleImage.transform = CGAffineTransformIdentity;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.baseView1.layer.cornerRadius = 4;
    self.baseView1.clipsToBounds = YES;
    self.baseView2.layer.cornerRadius = 4;
    self.baseView2.clipsToBounds = YES;
    self.baseview3.layer.cornerRadius = 4;
    self.baseview3.clipsToBounds = YES;
    self.baseView4.layer.cornerRadius = 4;
    self.baseView4.clipsToBounds = YES;
    self.baseView5.layer.cornerRadius = 4;
    self.baseView5.clipsToBounds = YES;
    self.baseView6.layer.cornerRadius = 4;
    self.baseView6.clipsToBounds = YES;
    self.baseView7.layer.cornerRadius = 4;
    self.baseView7.clipsToBounds = YES;

    self.codeBt.layer.cornerRadius = 4;
    self.codeBt.clipsToBounds = YES;
    self.comitbt.layer.cornerRadius = 4;
    self.comitbt.clipsToBounds = YES;
    self.getNewCode.layer.cornerRadius = 4;
    self.getNewCode.clipsToBounds = YES;
    
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = 600;

}

-(IncentiveModel*)incentiveModelV{
    
    if (!_incentiveModelV) {
        _incentiveModelV=[[NSBundle mainBundle]loadNibNamed:@"IncentiveModel" owner:self options:nil].firstObject;
        [_incentiveModelV.sixButton addTarget:self action:@selector(sixbuttonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.twenteenButton addTarget:self action:@selector(twenteenButtonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.twentyFBt addTarget:self action:@selector(twentyFbuttonE) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _incentiveModelV;
    
}
-(UIView*)incentiveModelMaskV{
    
    if (!_incentiveModelMaskV) {
        _incentiveModelMaskV=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _incentiveModelMaskV.backgroundColor=[UIColor clearColor];
    }
    
    return _incentiveModelMaskV;
    
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
                [self.codeBt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.codeBt.userInteractionEnabled = YES;
                self.codeBt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                self.codeBt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.codeBt.userInteractionEnabled = NO;
                self.codeBt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.codeBt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

@end
