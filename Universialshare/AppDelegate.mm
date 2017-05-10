//
//  AppDelegate.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "BasetabbarViewController.h"
#import "GLLoginController.h"
#import "IQKeyboardManager.h"
#import "BaseNavigationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@property(strong,nonatomic)BMKMapManager* mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
     //GLLoginController *loginVC = [[GLLoginController alloc] init];
    //BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
   
    //self.window.rootViewController = nav;
     self.window.rootViewController = [[BasetabbarViewController alloc]init];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"AEgIAA5j2QlPKPMIuNoOat6j3ZAagsFd" generalDelegate:self];
    if (!ret) {
        [MBProgressHUD showError:@"启动百度地图失败"];
    }
    
    //友盟分享
    [UMSocialData setAppKey:UMSHARE_APPKEY];
    [UMSocialWechatHandler setWXAppId:WEIXI_APPKEY appSecret:WEIXI_SECRET url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WEIBO_APPKEY
                                              secret:WEIBO_SECRET
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    return YES;
}
-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSLog(@"method is called");

    return YES;
}
#pragma mark - 键盘高度处理
- (void)iqKeyboardShowOrHide {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}


@end
