//
//  GLOrderDetailController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLOrderDetailController.h"

@interface GLOrderDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *fanliLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;

@end

@implementation GLOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fanliLabel.layer.borderWidth = 2;
    self.fanliLabel.layer.borderColor = YYSRGBColor(199, 78, 63, 1).CGColor;
    self.cancelOrderBtn.layer.borderWidth = 1;
    self.cancelOrderBtn.layer.borderColor = YYSRGBColor(199, 78, 63, 1).CGColor;
    
}


@end
