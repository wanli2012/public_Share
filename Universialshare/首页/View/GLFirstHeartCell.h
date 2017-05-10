//
//  GLFirstHeartCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/7.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLFirstPageDailyModel.h"

@interface GLFirstHeartCell : UITableViewCell

@property (nonatomic, strong)GLFirstPageDailyModel *model;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
