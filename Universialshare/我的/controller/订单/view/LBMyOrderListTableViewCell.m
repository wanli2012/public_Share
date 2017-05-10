//
//  LBMyOrderListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LBMyOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.payBt.layer.borderColor = YYSRGBColor(191, 0, 0, 1).CGColor;
    self.payBt.layer.borderWidth = 1;
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureEvent:)];
    
    [self.stauesLb addGestureRecognizer:tapgesture];
    
}

- (IBAction)paEvent:(UIButton *)sender {
    
    if (self.retunpaybutton) {
        self.retunpaybutton(self.index);
    }
    
}
//查看进度
- (void)tapgestureEvent:(UITapGestureRecognizer *)sender {
    
    if (_delegete && [_delegete respondsToSelector:@selector(clickTapgesture)]) {
        
        [_delegete clickTapgesture];
    }

}

- (IBAction)deletebutton:(UIButton *)sender {
    
    if (self.retundeletebutton) {
        self.retundeletebutton(self.index);
    }
    
}

-(void)setMyorderlistModel:(LBMyOrdersListModel *)myorderlistModel{
    _myorderlistModel = myorderlistModel;
    
    NSDictionary *dic = (NSDictionary*)_myorderlistModel;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:dic[@"thumb"]] placeholderImage:[UIImage imageNamed:@""]];
    self.namelb.text = [NSString stringWithFormat:@"%@",dic[@"goods_name"]];
    self.numlb.text = [NSString stringWithFormat:@"数量: %@",dic[@"goods_num"]];
    self.priceLb.text = [NSString stringWithFormat:@"价格: %@",dic[@"goods_price"]];


}

@end
