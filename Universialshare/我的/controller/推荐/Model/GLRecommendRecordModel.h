//
//  GLRecommendRecordModel.h
//  PovertyAlleviation
//
//  Created by 龚磊 on 2017/3/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLRecommendRecordModel : NSObject

@property (nonatomic,copy)NSString *uid;//推荐人ID

@property (nonatomic,copy)NSString *usertype;

@property (nonatomic,copy)NSString *username;//真实姓名

@property (nonatomic,copy)NSString *reg_time;//推荐时间

@end
