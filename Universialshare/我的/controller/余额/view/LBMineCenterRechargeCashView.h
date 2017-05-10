//
//  LBMineCenterRechargeCashView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/7.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineCenterRechargeCashView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;

@property (weak, nonatomic) IBOutlet UIButton *surebutton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secretVH;

@property (weak, nonatomic) IBOutlet UIView *baseview;


@property (weak, nonatomic) IBOutlet UITextField *secretTf;


@end
