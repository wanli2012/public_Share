//
//  LBMineCenterRechargeBankCardView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineCenterRechargeBankCardView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titllb;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *addbt;
@property (weak, nonatomic) IBOutlet UIButton *surebutton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableH;

@property (strong, nonatomic)NSArray *dataarr;

@property (strong, nonatomic)NSArray *selctB;

@end
