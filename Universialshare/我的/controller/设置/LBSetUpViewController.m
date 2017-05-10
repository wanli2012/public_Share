//
//  LBSetUpViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBSetUpViewController.h"
#import "LBMineCentermodifyAdressViewController.h"
#import "LBMineCenterAccountSafeViewController.h"
#import "GLSetup_VersionInfoController.h"

#define PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]

@interface LBSetUpViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *exitBt;
@property (weak, nonatomic) IBOutlet UILabel *momeryLb;
@property (weak, nonatomic) IBOutlet UILabel *verionLb;

@property (nonatomic , assign)float folderSize;//缓存



@end

@implementation LBSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    self.verionLb.text = [UserModel defaultUser].version;
    
    self.folderSize = [self filePath];
    
    self.momeryLb.text = [NSString stringWithFormat:@"%.2fM",self.folderSize];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
//修改收货地址
- (IBAction)exchangeAdress:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCentermodifyAdressViewController *vc=[[LBMineCentermodifyAdressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   
}
//清除缓存
- (IBAction)clearMomery:(UITapGestureRecognizer *)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要删除缓存吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 11;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        if (alertView.tag == 10) {
            
            [UserModel defaultUser].loginstatus = NO;
            [UserModel defaultUser].headPic = @"";
            [usermodelachivar achive];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (alertView.tag == 11){
        
             [self clearFile];//清楚缓存
        }

    }
    
}
//账号安全
- (IBAction)accountSafe:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterAccountSafeViewController *vc=[[LBMineCenterAccountSafeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   
}
//关于
- (IBAction)aboutUs:(UITapGestureRecognizer *)sender {
    
    
}
//退出登录
- (IBAction)exitEvent:(UIButton *)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10;
    [alert show];
    
}
- (IBAction)versionInfo:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLSetup_VersionInfoController *versionVC = [[GLSetup_VersionInfoController alloc] init];
    [self.navigationController pushViewController:versionVC animated:YES];
}

//*********************清理缓存********************//
//显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    //NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
}

-(void)clearCachSuccess{
    self.folderSize=[self filePath];
    self.momeryLb.text = [NSString stringWithFormat:@"%.2fM",self.folderSize];
    
}



-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.exitBt.layer.cornerRadius = 5;
    self.exitBt.clipsToBounds = YES;


}

@end
