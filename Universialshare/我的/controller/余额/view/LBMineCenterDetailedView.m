//
//  LBMineCenterDetailedView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/5.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterDetailedView.h"

@implementation LBMineCenterDetailedView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"LBMineCenterDetailedView" owner:nil options:nil].firstObject;
        self.baseview.layer.cornerRadius = 4;
        self.baseview.clipsToBounds = YES;
        self.frame = frame;
        
    }
    return self;

}

@end
