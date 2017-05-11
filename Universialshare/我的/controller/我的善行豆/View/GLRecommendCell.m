//
//  GLRecommendCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendCell.h"

@implementation GLRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLRecommendModel *)model{
    _model = model;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.regtime];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];
    
    self.dateLabel.text = timeStr;
    self.IDNumLabel.text = model.username;
    self.identityLabel.text = model.num;
    //身份
//    if ([model.uid isEqualToString:OrdinaryUser]) {
//        
//        self.amountLabel.text = @"米家";
//        
//    }else if([model.uid isEqualToString:Retailer]){
//        self.amountLabel.text = @"米商";
//        
//    }else if([model.uid isEqualToString:ONESALER]){
//        self.amountLabel.text = @"副总";
//        
//    }else if([model.uid isEqualToString:TWOSALER]){
//        self.amountLabel.text = @"高级推广员";
//        
//    }else{
//        self.amountLabel.text = @"推广员";
//    }

    
}

@end
