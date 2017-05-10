//
//  GLRankingCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRankingCell.h"

@interface GLRankingCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation GLRankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLFirstPageRankingModel *)model{
    _model = model;
    _nameLabel.text = model.truename;
    _moneyLabel.text = model.money1;
}

@end
