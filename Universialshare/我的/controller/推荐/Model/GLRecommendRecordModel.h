//
//  GLRecommendRecordModel.h
//  PovertyAlleviation
//
//  Created by 龚磊 on 2017/3/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLRecommendRecordModel : NSObject

@property (nonatomic,copy)NSString *uid;//被推荐人身份

//@property (nonatomic,copy)NSString *usertype;

@property (nonatomic,copy)NSString *username;//被推荐人ID

@property (nonatomic,copy)NSString *regtime;//推荐时间

@end
