//
//  GLHourseChangeNumCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseChangeNumCell.h"

@implementation GLHourseChangeNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.changeNumView.layer.cornerRadius = 5.f;
    self.changeNumView.clipsToBounds = YES;
    //    self.bottomView.alpha = 0.3;
    self.changeNumView.layer.borderColor = YYSRGBColor(148, 148, 148, 0.3).CGColor;
    self.changeNumView.layer.borderWidth = 1;
}

- (IBAction)changeNum:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(changeNum:indexPath:)]) { // 如果协议响应
       
        [_delegate changeNum:sender.tag indexPath:self.indexPath];
    }
}


@end
