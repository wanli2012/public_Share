//
//  LBMineCenterMyOrderViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMyOrderViewController.h"
#import "LBMyOrderAlreadyCompletedViewController.h"
#import "LBMyOrderPendingPaymentViewController.h"
#import "LBMyOrderPendingEvaluationViewController.h"
#import "LBMyOrderPendingRefundViewController.h"
#import "LBMyOrderAlreadyPaymentViewController.h"

@interface LBMineCenterMyOrderViewController ()


@end

@implementation LBMineCenterMyOrderViewController

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:49])
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;

     [self addviewcontrol];
     [self selectTagByIndex:0 animated:YES];
    
     self.hidesBottomBarWhenPushed=YES;
    
}

-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 3, 49);

//    LBMyOrderAlreadyCompletedViewController *vc1=[[LBMyOrderAlreadyCompletedViewController alloc]init];
//    LBMyOrderPendingPaymentViewController *vc2=[[LBMyOrderPendingPaymentViewController alloc]init];
//    LBMyOrderPendingEvaluationViewController *vc3=[[LBMyOrderPendingEvaluationViewController alloc]init];
//    LBMyOrderPendingRefundViewController *vc4=[[LBMyOrderPendingRefundViewController alloc]init];
    
    NSArray *titleArray = @[
                            @"已完成",
                            @"待付款",
                            @"已付款",
                            ];
    
    NSArray *classNames = @[
                            [LBMyOrderAlreadyCompletedViewController class],
                            [LBMyOrderPendingPaymentViewController class],
                            [LBMyOrderAlreadyPaymentViewController class],
                            
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = YYSRGBColor(191, 0, 0, 1);
    self.selectedIndicatorColor = YYSRGBColor(191, 0, 0, 1);
    
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}

@end
