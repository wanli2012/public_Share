//
//  GLRecommendRcordCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendRcordCell.h"

@interface GLRecommendRcordCell ()


@end

@implementation GLRecommendRcordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //是否设置边框以及是否可见
    [self.pictureV.layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [self.pictureV.layer setCornerRadius:self.pictureV.yy_height * 0.5];
    //设置边框线的宽
    
    [self.pictureV.layer setBorderWidth:1];
    //设置边框线的颜色
    [self.pictureV.layer setBorderColor:[[UIColor redColor] CGColor]];
    
}

- (void)setModel:(GLRecommendRecordModel *)model {
    _model = model;
//    self.pictureV.image = [UIImage imageNamed:model.picture];
    self.realnameLabel.text = model.username;
    self.dateLabel.text = model.reg_time;
    self.amountLabel.text = model.uid;
}


@end
