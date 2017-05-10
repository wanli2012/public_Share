//
//  GLRecommendRcordCell.h
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLRecommendRecordModel.h"

@interface GLRecommendRcordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureV;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic ,strong)GLRecommendRecordModel *model;
@end
