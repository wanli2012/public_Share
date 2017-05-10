//
//  GLMine_InfoCell.h
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMine_InfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UITextField *textTf;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;

@property (assign, nonatomic)NSInteger index;

@property (copy, nonatomic)void(^returnEditing)(NSString *content,NSInteger index);

@property (copy, nonatomic)void(^returnkeyBoard)(NSInteger index);

@property (weak, nonatomic) IBOutlet UILabel *adressLb;


@end
