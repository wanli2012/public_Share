//
//  LBMySalesmanListTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMySalesmanListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet UILabel *namelb;

@property (weak, nonatomic) IBOutlet UILabel *EngLishLb;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (assign , nonatomic)NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *businessNum;
@property (weak, nonatomic) IBOutlet UILabel *shopnum;


@property (copy , nonatomic)void(^returntapgestureimage)();

@end
