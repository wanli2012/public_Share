//
//  LoadWaitView.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LoadWaitView.h"

@interface LoadWaitView  ()


@end

@implementation LoadWaitView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"LoadWaitView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestrue)];
        [self addGestureRecognizer:tap];
        
        [self initinterface];
        
    }
    return self;

}

+(LoadWaitView*)addloadview:(CGRect)rect tagert:(id)tagert{
    
    LoadWaitView *loadview=[[LoadWaitView alloc]initWithFrame:rect];
    [tagert addSubview:loadview];
    
    return loadview;

}

-(void)removeloadview{

    [self removeFromSuperview];
    [self.loadImage stopAnimating];

}

-(void)initinterface{
    
   
    self.loadImage.animationImages = self.imageArr;
    self.loadImage.animationDuration = 1;//设置动画时间
    self.loadImage.animationRepeatCount = 0;//设置动画次数 0 表示无限
    
    [self.loadImage startAnimating];

}

-(void)tapgestrue{

    [self removeFromSuperview];
    [self.loadImage stopAnimating];

}

-(NSArray*)imageArr{

    if (!_imageArr) {
        _imageArr=[NSArray arrayWithObjects:[UIImage imageNamed:@"progress_1.png"],[UIImage imageNamed:@"progress_2.png"],[UIImage imageNamed:@"progress_3.png"],[UIImage imageNamed:@"progress_4.png"],[UIImage imageNamed:@"progress_5.png"],[UIImage imageNamed:@"progress_6.png"],[UIImage imageNamed:@"progress_7.png"],[UIImage imageNamed:@"progress_8.png"], nil];
        
    }
    return _imageArr;

}

@end
