//
//  LBSaleManPersonInfoViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBSaleManPersonInfoViewController.h"
#import "LBSaleManPersonInfoTableViewCell.h"

@interface LBSaleManPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation LBSaleManPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBSaleManPersonInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBSaleManPersonInfoTableViewCell"];
    
    self.headimage.layer.cornerRadius = 45;
    self.headimage.clipsToBounds = YES;
    
    self.headimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[UserModel defaultUser].headPic]];
    
    if (!self.headimage.image) {
        self.headimage.image = [UIImage imageNamed:@"mine_head"];
    }
    
    self.namelb.text = [UserModel defaultUser].truename;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    LBSaleManPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBSaleManPersonInfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.typelb.text = @"ID";
        cell.infolb.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].name];
    }else if (indexPath.row == 1) {
        cell.typelb.text = @"类别";
        if ([[UserModel defaultUser].usrtype isEqualToString:@"6"]) {
            cell.infolb.text = @"副总";
        }else if ([[UserModel defaultUser].usrtype isEqualToString:@"7"]) {
            cell.infolb.text = @"高级推广员";
        }else if ([[UserModel defaultUser].usrtype isEqualToString:@"8"]) {
            cell.infolb.text = @"推广员";
        }
        
    }else if (indexPath.row == 2) {
        cell.typelb.text = @"上级代理姓名";
        cell.infolb.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].tjrname];
        if (cell.infolb.text.length <= 0) {
            cell.infolb.text=@"无";
        }
    }else if (indexPath.row == 3) {
        cell.typelb.text = @"上级代理ID";
        cell.infolb.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].tjr];
        if (cell.infolb.text.length <= 0) {
            cell.infolb.text=@"无";
        }
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
        self.headimage.image = [UIImage imageWithData:data];
     
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [self changeHeadImage];//更换头像
        
    }
}
//更换头像
-(void)changeHeadImage{

  NSDictionary  *dic=@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@user/userAndShopInfoBq",URL_Base] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        if (self.headimage.image) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            NSData *data = UIImagePNGRepresentation(self.headimage.image);
            [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
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
            
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}


- (IBAction)tapgestureheadimage:(UITapGestureRecognizer *)sender {
   
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
}


- (IBAction)backevent:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
