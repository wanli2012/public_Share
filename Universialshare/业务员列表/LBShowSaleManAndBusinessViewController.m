//
//  LBShowSaleManAndBusinessViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBShowSaleManAndBusinessViewController.h"
#import "LBMySalesmanListViewController.h"
#import "LBMyBusinessListViewController.h"
#import "LBMySalesmanListDeatilViewController.h"
#import "LBMyBusinessListDetailViewController.h"
#import "LBSaleManPersonInfoViewController.h"
#import "LBViewProtocolViewController.h"
#import <MapKit/MapKit.h>

@interface LBShowSaleManAndBusinessViewController ()
@property (weak, nonatomic) IBOutlet UIView *navigationV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIView *buttonv;
@property (weak, nonatomic) IBOutlet UIButton *saleBt;
@property (weak, nonatomic) IBOutlet UIButton *businessBt;
@property (strong, nonatomic)LBMyBusinessListViewController *businessListVc;
@property (strong, nonatomic)LBMySalesmanListViewController *salesmanListVc;
@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, strong)UIView *lineView;

@end

@implementation LBShowSaleManAndBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    //    self.navigationItem.title = @"商家列表";
        self.automaticallyAdjustsScrollViewInsets = NO;
     [self.buttonv addSubview:self.lineView];
    
    _businessListVc=[[LBMyBusinessListViewController alloc]init];
    _salesmanListVc=[[LBMySalesmanListViewController alloc]init];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_businessListVc];
    [self addChildViewController:_salesmanListVc];
    
    self.currentViewController = _salesmanListVc;
    [self fitFrameForChildViewController:_salesmanListVc];
    [self.contentView addSubview:_salesmanListVc.view];
    
    __weak typeof(self) weakself = self;
    _salesmanListVc.returnpushvc = ^(NSDictionary *dic){
    
        if ([dic[@"saleman_type"] integerValue] == 8) {
//            weakself.hidesBottomBarWhenPushed = YES;
//            LBMyBusinessListViewController *vc=[[LBMyBusinessListViewController alloc]init];
//            vc.HideNavB = YES;
//            [weakself.navigationController pushViewController:vc animated:YES];
//            weakself.hidesBottomBarWhenPushed = NO;
        }else {
            weakself.hidesBottomBarWhenPushed = YES;
            LBMySalesmanListDeatilViewController *vc=[[LBMySalesmanListDeatilViewController alloc]init];
            vc.dic = dic;
            [weakself.navigationController pushViewController:vc animated:YES];
            weakself.hidesBottomBarWhenPushed = NO;
        }
    };
    _businessListVc.returnpushvc = ^(NSDictionary *dic){
        
        weakself.hidesBottomBarWhenPushed = YES;
        LBMyBusinessListDetailViewController *vc=[[LBMyBusinessListDetailViewController alloc]init];
        vc.dic = dic;
        [weakself.navigationController pushViewController:vc animated:YES];
        weakself.hidesBottomBarWhenPushed = NO;
    };
    
    _salesmanListVc.returnpushinfovc = ^(NSInteger index){
    
        weakself.hidesBottomBarWhenPushed = YES;
        LBSaleManPersonInfoViewController *vc=[[LBSaleManPersonInfoViewController alloc]init];
        [weakself.navigationController pushViewController:vc animated:YES];
        weakself.hidesBottomBarWhenPushed = NO;
    
    };
    //去这里
    _businessListVc.returnpushinfovc = ^(NSInteger index){
        
        double lat = 100.0;double lng = 100.0;
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])// -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"baidumap://map/geocoder?location=%f,%f&coord_type=bd09ll&src=webapp.rgeo.yourCompanyName.yourAppName",lat,lng]]];
        }else{
            //使用自带地图导航
            
            CLLocationCoordinate2D destCoordinate;
            // 将数据传到反地址编码模型
            destCoordinate = CLLocationCoordinate2DMake(lat,lng);
            
            MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
            
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destCoordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                       MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        }
        
    };
    
}

- (IBAction)salemanEvent:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(0, 48, SCREEN_WIDTH / 2, 1);
        [self.saleBt setTitleColor:YYSRGBColor(44, 153, 46, 1) forState:UIControlStateNormal];
        [self.businessBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
    [self transitionFromVC:self.currentViewController toviewController:_salesmanListVc];
    [self fitFrameForChildViewController:_salesmanListVc];
}


- (IBAction)businessEvent:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(SCREEN_WIDTH / 2, 48, SCREEN_WIDTH / 2, 1);
        [self.businessBt setTitleColor:YYSRGBColor(44, 153, 46, 1) forState:UIControlStateNormal];
        [self.saleBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
    [self transitionFromVC:self.currentViewController toviewController:_businessListVc];
    [self fitFrameForChildViewController:_businessListVc];
    
}

- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

- (void)transitionFromVC:(UIViewController *)viewController toviewController:(UIViewController *)toViewController {
    
    if ([toViewController isEqual:self.currentViewController]) {
        return;
    }
    [self transitionFromViewController:viewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        [viewController willMoveToParentViewController:nil];
        [toViewController willMoveToParentViewController:self];
        self.currentViewController = toViewController;
    }];
    
    
    
}

-(UIView*)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH / 2, 1)];
        _lineView.backgroundColor = YYSRGBColor(44, 153, 46, 1);
    }
    
    return _lineView;
    
}

@end
