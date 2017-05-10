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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.regtime];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];

    self.realnameLabel.text = model.username;
    self.dateLabel.text = timeStr;
    
//    //米家
//#define OrdinaryUser @"10"
//    //米商
//#define Retailer @"9"
//    //副总
//#define ONESALER @"6"
//    //高级推广员
//#define TWOSALER @"7"
//    //推广员
//#define THREESALER @"8"
    
    //身份
    if ([model.uid isEqualToString:OrdinaryUser]) {
        
        self.amountLabel.text = @"米家";
        
    }else if([model.uid isEqualToString:Retailer]){
        self.amountLabel.text = @"米商";
        
    }else if([model.uid isEqualToString:ONESALER]){
        self.amountLabel.text = @"副总";
        
    }else if([model.uid isEqualToString:TWOSALER]){
        self.amountLabel.text = @"高级推广员";
        
    }else{
        self.amountLabel.text = @"推广员";
    }

}


@end
