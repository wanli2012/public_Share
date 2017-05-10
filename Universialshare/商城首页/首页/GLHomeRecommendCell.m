//
//  GLHomeRecommendCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/5.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHomeRecommendCell.h"
#import "GLHomeRecommendCollectionCell.h"

@interface GLHomeRecommendCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;


@end

static NSString *ID = @"GLHomeRecommendCollectionCell";

@implementation GLHomeRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = YYSRGBColor(235, 235, 235, 1);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLHomeRecommendCollectionCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
}
- (UICollectionView *)collectionView {
    CGFloat collectionH = 450;
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //        // 定义大小
        //        layout.itemSize = CGSizeMake(SCREEN_WIDTH / 3 ,collectionH /2);
        // 设置最小行间距
        layout.minimumLineSpacing = 1;
        // 设置垂直间距
        layout.minimumInteritemSpacing = 1;
        // 设置滚动方向（默认垂直滚动）
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , collectionH ) collectionViewLayout:layout];
        
    }
    return _collectionView;
}
#pragma  UICollectionViewDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHomeRecommendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    return cell;
}
//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH / 2 - 0.5, 450/2 - 1);
}
@end
