//
//  GLHourseDetailFirstCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseDetailFirstCell.h"

@interface GLHourseDetailFirstCell()
{
    NSString *_price;
}

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanliLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthSellLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GLHourseDetailFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLGoodsDetailModel *)model{
    _model = model;
    
    if ([model.money floatValue] > 10000) {
        _price = [NSString stringWithFormat:@"%.2f万",[model.money floatValue]/10000];
    }else{
        _price = model.money;
    }
    
    if ([model.rebate floatValue] > 10000) {
        
        _fanliLabel.text = [NSString stringWithFormat:@"最高返利:%.2f万元",[model.rebate floatValue]/10000];
    }else{
        _fanliLabel.text = [NSString stringWithFormat:@"最高返利:%.2f元",[model.rebate floatValue]];
    }
    _priceLabel.text = [NSString stringWithFormat:@"¥%@元",_price];
    _monthSellLabel.text = [NSString stringWithFormat:@"月销%@笔",model.sell_count];
    _yunfeiLabel.text = [NSString stringWithFormat:@"运费:%@元",model.posttage];
    _nameLabel.text = model.goods_info;
}

@end
