//
//  GLIntegralGoodsCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralGoodsCell.h"
#import "UIImageView+WebCache.h"

@interface GLIntegralGoodsCell()
@property (weak, nonatomic) IBOutlet UIButton *panicBuyingBtn;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation GLIntegralGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.panicBuyingBtn.layer.cornerRadius = 5.f;
    self.panicBuyingBtn.clipsToBounds = YES;
    [self changeColor:self.jifenLabel rangeNumber:2666];
}


- (void)changeColor:(UILabel*)label rangeNumber:(NSInteger )rangeNum
{
    NSString *remainBeans = [NSString stringWithFormat:@"%lu",rangeNum];
    NSString *totalStr = [NSString stringWithFormat:@"%@ 积分",remainBeans];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:remainBeans];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:rangel];
    [label setAttributedText:textColor];
}

- (void)setModel:(GLMall_InterestModel *)model{
    _model = model;
    [self changeColor:_jifenLabel rangeNumber:[model.goods_price integerValue]];
    _nameLabel.text = model.goods_name;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
    
}

@end
