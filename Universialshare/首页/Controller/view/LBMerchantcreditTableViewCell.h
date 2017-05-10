//
//  LBMerchantcreditTableViewCell.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMerchantcreditTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Headimage;

@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet UILabel *companyLb;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (weak, nonatomic) IBOutlet UILabel *positionLb;

@property (weak, nonatomic) IBOutlet UILabel *IDStr;

@property (weak, nonatomic) IBOutlet UILabel *adressLb;


@end
