//
//  GLShoppingCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLShoppingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLShoppingCell ()

@property (weak, nonatomic) IBOutlet UILabel *goodsNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation GLShoppingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    self.goodsNamelabel.font = [UIFont systemFontOfSize:ADAPT(15)];

}
- (void)setModel:(GLShoppingCartModel *)model {
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
    _goodsNamelabel.text = model.goods_name;
    _amountLabel.text =[NSString stringWithFormat:@"数量:%@",model.num];
    _detailLabel.text = model.info;
    if([model.goods_price integerValue] >10000){
        
        _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f万元",[model.goods_price floatValue]/10000];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"¥ %@元",model.goods_price];
    }
    if (_imageV.image == nil) {
        _imageV.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}


@end
