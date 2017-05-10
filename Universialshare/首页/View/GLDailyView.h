//
//  GLDailyView.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GLDailyView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *models;
@end
