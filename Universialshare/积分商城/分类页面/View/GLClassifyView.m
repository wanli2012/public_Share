//
//  GLClassifyView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLClassifyView.h"
#import "GLClassifyRecommendCell.h"
#import "GLClassifyHeaderView.h"

@interface GLClassifyView()<UICollectionViewDelegate,UICollectionViewDataSource>



//@property (nonatomic, strong)NSMutableArray *chooseArr;
@property (nonatomic, copy)NSString *chooseStr;
@property (nonatomic, strong)NSMutableArray *cellArr;


@end

static NSString *ID = @"GLClassifyRecommendCell";
@implementation GLClassifyView

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 64 - 40) / 3 , 30);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(0, SCREEN_HEIGHT / 4);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置section的编距
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLClassifyRecommendCell" bundle:nil] forCellWithReuseIdentifier:ID];
    //注册头视图

    [self.collectionView registerNib:[UINib nibWithNibName:@"GLClassifyHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLClassifyHeaderView"];
    
}
- (IBAction)ensureClick:(id)sender {
    
    self.block(_chooseStr);
    
}
- (IBAction)resetClick:(id)sender {
//    [self.chooseArr removeAllObjects];
    for (GLClassifyRecommendCell *cell in self.cellArr) {
        
        cell.status = NO;
        
        cell.backgroundColor = YYSRGBColor(235, 235, 235, 1);
        [cell.titleLabel setTextColor:[UIColor darkGrayColor]];
        cell.layer.borderWidth = 0;
    }
}

#pragma  UICollectionDelegate UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GLClassifyRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.titleLabel.text = _dataSource[indexPath.row];
    [self.cellArr addObject:cell];
    return  cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GLClassifyRecommendCell *cell = (GLClassifyRecommendCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.status) {
        
        cell.backgroundColor = YYSRGBColor(235, 235, 235, 1);
        [cell.titleLabel setTextColor:[UIColor darkGrayColor]];
        cell.layer.borderWidth = 0;
        self.chooseStr = @"";
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        [cell.titleLabel setTextColor:[UIColor redColor]];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor redColor].CGColor;
        self.chooseStr = cell.titleLabel.text;
    }
    cell.status = !cell.status;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    GLClassifyRecommendCell *cell = (GLClassifyRecommendCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = YYSRGBColor(235, 235, 235, 1);
    [cell.titleLabel setTextColor:[UIColor darkGrayColor]];
    cell.layer.borderWidth = 0;
    cell.status = NO;
}
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    GLClassifyHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLClassifyHeaderView"  forIndexPath:indexPath];

    
    return headView;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(self.frame.size.width, 40);
    }
    else {
        return CGSizeMake(0, 0);
    }
}

//- (NSMutableArray *)chooseArr{
//    if (!_chooseArr) {
//        _chooseArr = [NSMutableArray array];
//    }
//    return _chooseArr;
//}
- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [NSMutableArray array];
    }
    return _cellArr;
}
@end
