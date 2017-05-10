//
//  GLDonationRecordCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDonationRecordCell.h"
@interface GLDonationRecordCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *beanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GLDonationRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLDonationRecordModel *)model{
    _model = model;
//    if ([model.picture rangeOfString:@"null"].location != NSNotFound) {
//        model.picture = @"mine_head";
//    }
    if ([model.cname rangeOfString:@"null"].location != NSNotFound) {
        model.cname = @"";
    }
    if ([model.num rangeOfString:@"null"].location != NSNotFound) {
        model.num = @"0";
    }
    if ([model.time rangeOfString:@"null"].location != NSNotFound) {
        model.time = @"";
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:model.time];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter1 stringFromDate:currentDate];
    
    
    self.nameTitle.text = model.cname;
    self.beanNumLabel.text = model.num;
    self.dateLabel.text = timeStr;
    
    if (self.imageV.image ==nil) {
        self.imageV.image = [UIImage imageNamed:@"mine_head"];
    }
    
    if ([self.beanNumLabel.text intValue] > 10000) {
        
        CGFloat num = [self.beanNumLabel.text floatValue] / 10000;
        self.beanNumLabel.text = [NSString stringWithFormat:@"%.2f万",num];
        
    }
}
@end
