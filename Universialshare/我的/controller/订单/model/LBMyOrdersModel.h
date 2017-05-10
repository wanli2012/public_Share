//
//  LBMyOrdersModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMyOrdersModel : NSObject

@property (copy, nonatomic)NSString *order_id;
@property (copy, nonatomic)NSString *order_money;
@property (copy, nonatomic)NSString *addtime;
@property (copy, nonatomic)NSString *order_num;
@property (copy, nonatomic)NSString *order_type;
@property (copy, nonatomic)NSString *realy_price;
@property (copy, nonatomic)NSString *total;
@property (copy, nonatomic)NSString *mark;

@property (copy, nonatomic)NSArray *MyOrdersListModel;

@property (assign, nonatomic)BOOL isExpanded;//是否展开

@end
