//
//  GLReceiveBeansCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLReceiveBeansCell.h"

@implementation GLReceiveBeansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLReceiveBeansModel *)model{
    _model = model;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.timeStr];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];
    
    self.dateLabel.text = timeStr;
    
    if ([model.num floatValue] > 10000) {
        
        self.numberLabel.text = [NSString stringWithFormat:@"%.2f",[model.num floatValue] / 10000];
    }else{
        
        self.numberLabel.text = [NSString stringWithFormat:@"%@",model.num];
    }
    self.IDLabel.text = model.username;
}

@end
