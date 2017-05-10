//
//  GLTopCell.h
//  PublicSharing
//
//  Created by 龚磊 on 2017/3/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLTopCellDelegate <NSObject>

- (void)kindOfButtonClick:(NSInteger )index;

@end

@interface GLTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *walkBtn;
@property (weak, nonatomic) IBOutlet UIButton *foodBtn;
@property (weak, nonatomic) IBOutlet UIButton *clothBtn;

@property (nonatomic, assign)id<GLTopCellDelegate> delegate;

@end
