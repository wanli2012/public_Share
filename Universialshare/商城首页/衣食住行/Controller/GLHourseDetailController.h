//
//  GLHourseDetailController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLHourseDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *settleBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToCartBtn;

@property (nonatomic, assign)int type;

@property (nonatomic, copy)NSString *goods_id;

@end
