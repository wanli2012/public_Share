//
//  LoadWaitView.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadWaitView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *loadImage;

@property (strong, nonatomic) NSArray *imageArr;


+(LoadWaitView *)addloadview:(CGRect)rect tagert:(id)tagert;//加载

-(void)removeloadview;//移除


@end
