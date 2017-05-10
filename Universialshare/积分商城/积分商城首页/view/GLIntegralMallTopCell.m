//
//  GLIntegralMallTopCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralMallTopCell.h"
#import "UIImageView+WebCache.h"
#import "GLMallHotModel.h"
@interface GLIntegralMallTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel2;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel3;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;


@end

@implementation GLIntegralMallTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self changeColor:self.jifenLabel rangeNumber:2666];
    [self changeColor:self.jifenLabel2 rangeNumber:2666];
    [self changeColor:self.jifenLabel3 rangeNumber:2666];
    
}

- (NSMutableAttributedString *)changeColor:(UILabel*)label rangeNumber:(NSInteger )rangeNum
{
    NSString *remainBeans = [NSString stringWithFormat:@"%lu",rangeNum];
    NSString *totalStr = [NSString stringWithFormat:@"%@ 积分",remainBeans];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:remainBeans];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:rangel];
    return textColor;
}

- (void)setModels:(NSArray *)models{
    _models = models;
    if (models.count != 0) {
        
        GLMallHotModel *model = models[0];
        [_imageV sd_setImageWithURL:[NSURL URLWithString:model.mall_url] placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
        _titleLabel.text = model.mall_name;
        
        [_jifenLabel setAttributedText:[self changeColor:_jifenLabel rangeNumber:[model.mall_inte integerValue]]];
        
        GLMallHotModel *model2 = models[1];
        [_imageV2 sd_setImageWithURL:[NSURL URLWithString:model2.mall_url] placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
        _titleLabel2.text = model2.mall_name;
        
        [_jifenLabel2 setAttributedText:[self changeColor:_jifenLabel rangeNumber:[model2.mall_inte integerValue]]];
        
        GLMallHotModel *model3 = models[2];
        [_imageV3 sd_setImageWithURL:[NSURL URLWithString:model3.mall_url] placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
        _titleLabel3.text = model3.mall_name;
        
        [_jifenLabel3 setAttributedText:[self changeColor:_jifenLabel rangeNumber:[model3.mall_inte integerValue]]];
    }

}
@end
