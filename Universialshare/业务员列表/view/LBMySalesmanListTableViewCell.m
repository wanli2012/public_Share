//
//  LBMySalesmanListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMySalesmanListTableViewCell.h"

@implementation LBMySalesmanListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.imagev.layer.cornerRadius = 35;
    self.imagev.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureimage:)];
    [self.imagev addGestureRecognizer:tap];
    
}

- (void)tapgestureimage:(UITapGestureRecognizer *)sender {
    
    if (self.returntapgestureimage) {
        self.returntapgestureimage(self.index);
    }
}



@end
