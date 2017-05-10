//
//  MineCollectionHeaderV.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"


@interface MineCollectionHeaderV : UICollectionReusableView

@property(nonatomic , strong) UIView *baseview;
@property(nonatomic , strong) UIView *baseview1;
@property(nonatomic , strong) UIView *headview;
@property(nonatomic , strong) UIImageView *headimage;
@property(nonatomic , strong) UILabel *namelebel;//用户名
@property (strong, nonatomic)NSArray *titleArr;

@property (strong, nonatomic)UITableView *tableview;

@property(nonatomic , strong) UIButton *CollectinGoodsBt;//代收货
@property(nonatomic , strong) UIButton *ShoppingCartBt;//购物车
@property(nonatomic , strong) UIButton *OrderBt;//订单

@property(nonatomic , copy)void(^returnCollectinGoodsBt)();
@property(nonatomic , copy)void(^returnShoppingCartBt)();
@property(nonatomic , copy)void(^returnOrderBt)();

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@end
