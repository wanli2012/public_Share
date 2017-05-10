//
//  LBMerchantSubmissionFourViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMerchantSubmissionFourViewController.h"
#import "MerchantInformationModel.h"

@interface LBMerchantSubmissionFourViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIImageView *handImage;
@property (weak, nonatomic) IBOutlet UIImageView *positiveImage;
@property (weak, nonatomic) IBOutlet UIImageView *otherSideImage;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImage;
@property (weak, nonatomic) IBOutlet UIImageView *undertakingOne;
@property (weak, nonatomic) IBOutlet UIImageView *undertakingTwo;
@property (weak, nonatomic) IBOutlet UIImageView *doorplateImage;
@property (weak, nonatomic) IBOutlet UIImageView *DoorplateOneimage;
@property (weak, nonatomic) IBOutlet UIImageView *InteriorImage;
@property (weak, nonatomic) IBOutlet UIImageView *InteriorOneImage;
@property (weak, nonatomic) IBOutlet UIView *baseview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;

@property (assign, nonatomic)NSInteger tapIndex;//判断点击的是那个图片
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBMerchantSubmissionFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交商户";
    
}
//手持身份证
- (IBAction)tapgesturehandimage:(UITapGestureRecognizer *)sender {
    _tapIndex = 1;
    
    [self tapgesturephotoOrCamera];
    
}
// 身份证正面照
- (IBAction)tapgesturepositiveimage:(UITapGestureRecognizer *)sender {
    _tapIndex = 2;
    [self tapgesturephotoOrCamera];
    
}
//身份证反面照
- (IBAction)tapgestureothersideimage:(UITapGestureRecognizer *)sender {
    _tapIndex = 3;
    [self tapgesturephotoOrCamera];
    
}

//点击营业执照
- (IBAction)tapgestureBusinesslicense:(UITapGestureRecognizer *)sender {
    _tapIndex = 4;
    [self tapgesturephotoOrCamera];
    
    
}
//商家承诺书
- (IBAction)tapgestureBusinessUndertaking:(UITapGestureRecognizer *)sender {
    _tapIndex = 5;
    [self tapgesturephotoOrCamera];
    
    
    
}
- (IBAction)tapgestureBusinessUndertakingOne:(UITapGestureRecognizer *)sender {
    _tapIndex = 6;
    [self tapgesturephotoOrCamera];
}
//点击门牌照
- (IBAction)tapgestureDoorPlate:(UITapGestureRecognizer *)sender {
    _tapIndex = 7;
    [self tapgesturephotoOrCamera];
    
    
}

- (IBAction)tapgestureDoorPlateOne:(UITapGestureRecognizer *)sender {
    _tapIndex = 8;
    [self tapgesturephotoOrCamera];
    
    
}
//门店内景图
- (IBAction)tapgestureStoreInterior:(UITapGestureRecognizer *)sender {
    _tapIndex = 9;
    [self tapgesturephotoOrCamera];
    
    
}

- (IBAction)tapgestureStoreInteriorOne:(UITapGestureRecognizer *)sender {
    _tapIndex = 10;
    
    [self tapgesturephotoOrCamera];
    
}

//选择图片来源
-(void)tapgesturephotoOrCamera{

    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];


}


//提交
- (IBAction)submitinfo:(UIButton *)sender {
    
//    if (!self.handImage.image || self.handImage.image == [UIImage imageNamed:@"手持身份证"]) {
//        [MBProgressHUD showError:@"请上传法人手持证件照"];
//        return;
//    }
    
    if (!self.positiveImage.image || [UIImagePNGRepresentation(self.positiveImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"样板-拷贝"])]) {
        [MBProgressHUD showError:@"请上传身份证正面照"];
        return;
    }
    
    if (!self.otherSideImage.image || [UIImagePNGRepresentation(self.otherSideImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝"])]) {
         [MBProgressHUD showError:@"请上传身份证反面照"];
        return;
    }
    
    if (!self.licenseImage.image || [UIImagePNGRepresentation(self.licenseImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-2"])]) {
        [MBProgressHUD showError:@"请上传营业执照"];
        return;
    }
   
    if (!self.undertakingOne.image || [UIImagePNGRepresentation(self.undertakingOne.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-4"])]) {
        [MBProgressHUD showError:@"请上传商家承诺书"];
        return;
    }
    if (!self.doorplateImage.image || [UIImagePNGRepresentation(self.doorplateImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-10"])]) {
        [MBProgressHUD showError:@"请上传门头照"];
        return;
    }
    
    
    if ([UIImagePNGRepresentation(self.InteriorImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-12"])] || [UIImagePNGRepresentation(self.InteriorOneImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-13"])]  || [UIImagePNGRepresentation(self.DoorplateOneimage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"内景2-拷贝"])]) {
        [MBProgressHUD showError:@"请上传门头照"];
        return;
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"openbank"] = [MerchantInformationModel defaultUser].openBankNameid;
    dict[@"banknumber"] = [MerchantInformationModel defaultUser].bankNumbers;
    dict[@"name"] = [MerchantInformationModel defaultUser].SettlementName;
    dict[@"bank_adderss"] = [MerchantInformationModel defaultUser].SubBranch;
    dict[@"phone"] = [MerchantInformationModel defaultUser].loginPhone;
    dict[@"pwd"] = [MerchantInformationModel defaultUser].secret;
    
    dict[@"shop_name"] = [MerchantInformationModel defaultUser].shopName;
    dict[@"truename"] = [MerchantInformationModel defaultUser].legalPerson;
    dict[@"email"] = [MerchantInformationModel defaultUser].Email;
    dict[@"shop_acreage"] = [MerchantInformationModel defaultUser].measureRrea;
    dict[@"open_time"] = [MerchantInformationModel defaultUser].BusinessBegin;
    dict[@"s_province"] =[MerchantInformationModel defaultUser].provinceId;
    dict[@"s_city"] = [MerchantInformationModel defaultUser].cityId;
    dict[@"s_area"] = [MerchantInformationModel defaultUser].countryId;
    dict[@"s_address"] = [MerchantInformationModel defaultUser].detailAdress;
    dict[@"trade_id"] = [MerchantInformationModel defaultUser].PrimaryClassification;
    dict[@"lat"] = [MerchantInformationModel defaultUser].lat;
    dict[@"lng"] = [MerchantInformationModel defaultUser].lng;
    dict[@"two_trade_id"] = [MerchantInformationModel defaultUser].TwoClassification;
    
    NSArray *imageViewArr = [NSArray arrayWithObjects:self.positiveImage,self.otherSideImage,self.licenseImage,self.undertakingOne,self.doorplateImage,self.DoorplateOneimage,self.InteriorImage,self.InteriorOneImage, nil];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"face_pic",@"con_pic",@"license_pic",@"promise_pic",@"store_pic",@"store_one",@"store_two",@"store_three", nil];

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@user/openOne",URL_Base] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        for (int i = 0; i < imageViewArr.count; i ++) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            UIImageView *imaev = (UIImageView*)imageViewArr[i];
            NSData *data = UIImagePNGRepresentation(imaev.image);
            [formData appendPartWithFileData:data name:titleArr[i] fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setCornerRadius:8.0];
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:dic[@"message"]];
            //[self.navigationController popToRootViewControllerAnimated:YES];
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
        switch (self.tapIndex) {
            case 1:
            {
                self.handImage.image = [UIImage imageWithData:data];
            }
                break;
            case 2:
            {
                self.positiveImage.image = [UIImage imageWithData:data];
            }
                break;
            case 3:
            {
                self.otherSideImage.image = [UIImage imageWithData:data];
            }
                break;
            case 4:
            {
                self.licenseImage.image = [UIImage imageWithData:data];
            }
                break;
            case 5:
            {
                self.undertakingOne.image = [UIImage imageWithData:data];
            }
                break;
            case 6:
            {
                self.undertakingTwo.image = [UIImage imageWithData:data];
            }
                break;
            case 7:
            {
                self.doorplateImage.image = [UIImage imageWithData:data];
            }
                break;
            case 8:
            {
                self.DoorplateOneimage.image = [UIImage imageWithData:data];
            }
                break;
            case 9:
            {
                self.InteriorImage.image = [UIImage imageWithData:data];
            }
                break;
            case 10:
            {
                self.InteriorOneImage.image = [UIImage imageWithData:data];
            }
                break;
                
            default:
                break;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}



-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.submit.layer.cornerRadius = 4;
    self.submit.clipsToBounds = YES;
    
    self.baseview.layer.cornerRadius = 4;
    self.baseview.clipsToBounds = YES;
    
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = 830;


}
@end
