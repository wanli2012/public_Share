//
//  LBMineCenterPayPagesViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineCenterPayPagesViewController : UIViewController

@property (nonatomic, assign) NSInteger payType; // 支付类型 1普通消费支付  2 积分支付

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *useableScore;

@property (nonatomic, copy) NSString *orderNum;

@property (nonatomic, copy) NSString *orderScore;

@property (nonatomic, assign)NSInteger pushIndex;//记录从哪个控制器push的 1:积分商城确认订单  2:我的-订单


@end
