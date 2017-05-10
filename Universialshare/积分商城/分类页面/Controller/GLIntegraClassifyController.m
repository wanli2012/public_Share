//
//  GLIntegraClassifyController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegraClassifyController.h"
#import "GLClassifyCell.h"
#import "GLSet_MaskVeiw.h"
#import "GLClassifyView.h"
#import "GLHourseDetailController.h"

@interface GLIntegraClassifyController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    GLSet_MaskVeiw *_maskV;
    GLClassifyView *_contentV;
    LoadWaitView * _loadV;
    NSInteger _sortType;//排序方式:1 默认正序  2 倒序
    
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *searchView;


@property (weak, nonatomic) IBOutlet UIButton *defaultSortBtn;
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;

@property (nonatomic,strong)NSMutableArray *models;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic,strong)NSMutableArray *typeArr;

@end

static NSString *ID = @"GLClassifyCell";
@implementation GLIntegraClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH /2 - 0.5, 230 * autoSizeScaleY);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    self.collectionView.collectionViewLayout = layout;
    
    self.searchView.layer.cornerRadius = self.searchView.yy_height / 2;
    self.searchView.clipsToBounds = YES;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLClassifyCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;
    [self sortClick:self.defaultSortBtn];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"全部";
    self.navigationController.navigationBar.hidden = NO;
}
//排序
- (IBAction)sortClick:(UIButton *)sender {
    if(sender.titleLabel.textColor != [UIColor redColor]){
        
        [self.defaultSortBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.integralBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        if (sender == self.defaultSortBtn) {
            _sortType = 1;
        }else{
            _sortType = 2;
        }
        [self updateData:YES];
    }
}

//发送请求
- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sel_rank"] = @(_sortType);
    dict[@"sel_type"] = @"1";
    dict[@"page"] = [NSString stringWithFormat:@"%ld",_page];

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/getMarkGoods" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
//        NSLog(@"responseObject = %@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1){
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"]] rangeOfString:@"null"].location == NSNotFound ) {
                
                for (NSDictionary *dict in responseObject[@"data"]) {
                    
                    GLintegralGoodsModel *model = [GLintegralGoodsModel mj_objectWithKeyValues:dict];
                    
                    [self.models addObject:model];
                }
            }
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        self.nodataV.hidden = NO;
    }];
    
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114-49);
    }
    return _nodataV;
    
}
//返回
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        _contentV.frame = CGRectMake(SCREEN_WIDTH, 64, 0, SCREEN_HEIGHT - 64);
        
    }completion:^(BOOL finished) {
        
        [_maskV removeFromSuperview];
    }];

}

//筛选
- (IBAction)filterBtn:(id)sender {
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskV.bgView.alpha = 0.3;
    
    _contentV = [[NSBundle mainBundle] loadNibNamed:@"GLClassifyView" owner:nil options:nil].lastObject;
    __weak typeof(self)weakSelf = self;
    _contentV.block = ^(NSString * str){
//        NSLog(@"arr =  == = = =  = ===%@",str);
        [weakSelf dismiss];
    };
    
    _contentV.frame = CGRectMake(SCREEN_WIDTH, 64, 0, SCREEN_HEIGHT - 64);
    [_maskV showViewWithContentView:_contentV];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _contentV.frame = CGRectMake(64, 64 , SCREEN_WIDTH - 64, SCREEN_HEIGHT - 64);
        
    }];
    
//请求数据
    _loadV = [LoadWaitView addloadview:_contentV.bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/getMarkGoodsType" paramDic:@{} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
//        NSLog(@"responseObject = %@",responseObject);
        [self.typeArr removeAllObjects];
        if ([responseObject[@"code"] integerValue] == 1){
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"]] rangeOfString:@"null"].location == NSNotFound ) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    [self.typeArr addObject:dic[@"catename"]];
                }
                _contentV.dataSource = self.typeArr;
            }else{
                _contentV.dataSource = @[];
            }
            [_contentV.collectionView reloadData];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        self.nodataV.hidden = NO;
    }];

    
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
    GLintegralGoodsModel *model = self.models[indexPath.row];
    detailVC.goods_id = model.goods_id;
    detailVC.navigationItem.title = @"积分商品详情";
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
- (NSMutableArray *)typeArr{
    if (!_typeArr) {
        _typeArr = [NSMutableArray array];
    }
    return _typeArr;
}
@end
