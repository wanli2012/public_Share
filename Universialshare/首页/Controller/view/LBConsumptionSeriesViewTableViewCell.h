//
//  LBConsumptionSeriesViewTableViewCell.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBConsumptionSeriesViewTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *xiaoFLb;//消费金额

@property (weak, nonatomic) IBOutlet UILabel *heartLb;
@property (weak, nonatomic) IBOutlet UILabel *beanLB;


@property (weak, nonatomic) IBOutlet UILabel *timeLb;


@end
