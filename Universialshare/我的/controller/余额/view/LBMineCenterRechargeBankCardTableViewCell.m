//
//  LBMineCenterRechargeBankCardTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterRechargeBankCardTableViewCell.h"

@implementation LBMineCenterRechargeBankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectEvent:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LBMineCenterRechargeBankCardTableViewCell" object:nil userInfo:@{@"index":[NSNumber numberWithInt:self.index]}];
    
}


@end
