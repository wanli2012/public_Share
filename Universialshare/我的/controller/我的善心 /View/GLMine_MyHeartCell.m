//
//  GLMine_MyHeartCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_MyHeartCell.h"

@interface GLMine_MyHeartCell ()

@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *encourageSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *encouragingLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiliCompleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *daijiliLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishedNumLabel;



@end

@implementation GLMine_MyHeartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLMyheartModel *)model{
    _model = model;
    if([model.money rangeOfString:@"null"].location != NSNotFound){
        model.money = @"0";
    }
    if([model.zjl rangeOfString:@"null"].location != NSNotFound){
        model.zjl = @"0";
    }
    if([model.love rangeOfString:@"null"].location != NSNotFound){
        model.love = @"0";
    }
    if([model.jl_love rangeOfString:@"null"].location != NSNotFound){
        model.jl_love = @"0";
    }
    if([model.end_love rangeOfString:@"null"].location != NSNotFound){
        model.end_love = @"0";
    }
    if([model.end_bean rangeOfString:@"null"].location != NSNotFound){
        model.end_bean = @"0";
    }
    if([model.bean rangeOfString:@"null"].location != NSNotFound){
        model.bean = @"0";
    }
    
    self.consumeLabel.text = model.money;
    self.encourageSumLabel.text = model.zjl;
    self.heartSumLabel.text = model.love;
    self.encouragingLabel.text = model.jl_love;
    self.jiliCompleteLabel.text = model.end_love;
    self.daijiliLabel.text = model.bean;
    self.finishedNumLabel.text = model.end_bean;

}


@end
