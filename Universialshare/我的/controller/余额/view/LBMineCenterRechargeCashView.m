//
//  LBMineCenterRechargeCashView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/7.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterRechargeCashView.h"

@implementation LBMineCenterRechargeCashView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"LBMineCenterRechargeCashView" owner:nil options:nil].firstObject;
        self.frame = frame;
        self.surebutton.layer.cornerRadius = 4;
        self.surebutton.clipsToBounds = YES;
        
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        
        self.secretVH.constant = (SCREEN_WIDTH - 105)/6 ;
        
    }
    
    return self;
}

@end
