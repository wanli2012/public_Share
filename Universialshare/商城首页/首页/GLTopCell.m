//
//  GLTopCell.m
//  PublicSharing
//
//  Created by 龚磊 on 2017/3/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTopCell.h"
#import "SDCycleScrollView.h"
#import "UIButton+SetEdgeInsets.h"

@interface GLTopCell()<SDCycleScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVW;


@property (weak, nonatomic) IBOutlet UIView *topView;


@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@end

@implementation GLTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentVW.constant = SCREEN_WIDTH;
    self.contentVH.constant = 80;
    
    [self.liveBtn verticalCenterImageAndTitle:5];
    [self.walkBtn verticalCenterImageAndTitle:5];
    [self.foodBtn verticalCenterImageAndTitle:5];
    [self.clothBtn verticalCenterImageAndTitle:5];
  
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
    
    _cycleScrollView.localizationImageNamesGroup = @[@"XRPlaceholder"];
    
    _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    [self.topView addSubview:self.cycleScrollView];

}
- (IBAction)buttonClick:(UIButton *)sender {
 
 [_delegate kindOfButtonClick:sender.tag];
   
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

@end
