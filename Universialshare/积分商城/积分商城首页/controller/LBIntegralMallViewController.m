//
//  LBIntegralMallViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBIntegralMallViewController.h"
#import "SDCycleScrollView.h"
#import "GLIntegralHeaderView.h"
#import "GLIntegralMallTopCell.h"
#import "GLIntegralGoodsCell.h"

#import "GLHourseDetailController.h"
#import "GLIntegraClassifyController.h"

#import "GLMallHotModel.h"
#import "GLMall_InterestModel.h"

//城市定位 选择

#import "GLCityChooseController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LBIntegralMallViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    UIImageView *_imageviewLeft;
    UIImageView *_imageviewRight;
    LoadWaitView * _loadV;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property (nonatomic, strong)NSMutableArray *hotModels;
@property (nonatomic, strong)NSMutableArray *interestModels;
@property (weak, nonatomic) IBOutlet UIView *searchView;

//城市定位


@end


static NSString *topCellID = @"GLIntegralMallTopCell";
static NSString *goodsCellID = @"GLIntegralGoodsCell";
@implementation LBIntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor purpleColor];
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 160*autoSizeScaleY)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
    
    _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
    _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    
    
    self.tableView.tableHeaderView = _cycleScrollView;

    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralMallTopCell" bundle:nil] forCellReuseIdentifier:topCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralGoodsCell" bundle:nil] forCellReuseIdentifier:goodsCellID];
    self.searchView.layer.cornerRadius = self.searchView.yy_height / 2;
    self.searchView.clipsToBounds = YES;
    
    [self postRequest];
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        
    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;

}
- (void)updateUI{
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)postRequest{

    [NetworkManager requestPOSTWithURLStr:@"index/banner_list" paramDic:@{@"type":@"6"} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == 1){
            NSMutableArray *arrM = [NSMutableArray array];
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic  in responseObject[@"data"]) {
                    
                    UIImageView *imageV = [[UIImageView alloc] init];
                    [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"img_path"]]];
                    
                    if(imageV.image){
                        
                        [arrM addObject:dic[@"img_path"]];
                    }
                }
                if (arrM.count >= 3) {
                    
                    _cycleScrollView.imageURLStringsGroup = arrM;
                }else{
                    _cycleScrollView.localizationImageNamesGroup = @[@"banner01",
                                                                     @"banner02",
                                                                     @"banner03"];
                }
                
            }
        }
        
    } enError:^(NSError *error) {
        [MBProgressHUD showError:error.description];
    }];

    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/main" paramDic:@{} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
//        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1){
            for (NSDictionary *dict in responseObject[@"data"][@"mall_tabe"]) {
                
                GLMallHotModel *model = [GLMallHotModel mj_objectWithKeyValues:dict];
                [_hotModels addObject:model];
            }
            for (NSDictionary *dic in responseObject[@"data"][@"inte_list"]) {
                GLMall_InterestModel *model = [GLMall_InterestModel mj_objectWithKeyValues:dic];
                [_interestModels addObject:model];
            }
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

}
- (void)classifyClick:(UITapGestureRecognizer *)tap {
   
    self.hidesBottomBarWhenPushed = YES;
    GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
    detailVC.navigationItem.title = @"积分兑换详情";
    if (tap.view.tag == 11) {
        GLMallHotModel *model = self.hotModels[0];
        detailVC.goods_id = model.mall_id;
        [self.navigationController pushViewController:detailVC animated:YES];

    }else if (tap.view.tag == 12){
        GLMallHotModel *model = self.hotModels[1];
        detailVC.goods_id = model.mall_id;
        [self.navigationController pushViewController:detailVC animated:YES];

    }else if (tap.view.tag == 13){
        GLMallHotModel *model = self.hotModels[2];
        detailVC.goods_id = model.mall_id;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else{
        
        GLIntegraClassifyController *classifyVC = [[GLIntegraClassifyController alloc] init];
        [self.navigationController pushViewController:classifyVC animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}

//城市选择
- (IBAction)cityChoose:(id)sender {
    
//    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
//    cityViewController.title = @"城市";
    GLCityChooseController *cityVC = [[GLCityChooseController alloc] init];
    __weak typeof(self) weakSelf = self;
    cityVC.block = ^(NSString *city){
        [weakSelf.cityBtn setTitle:city forState:UIControlStateNormal];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        
        return self.interestModels.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40*autoSizeScaleY;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        GLIntegralHeaderView *headerVeiw = [[NSBundle mainBundle] loadNibNamed:@"GLIntegralHeaderView" owner:nil options:nil].lastObject;
        return headerVeiw;
    }else{
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0) {
        GLIntegralMallTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.hotModels.count == 3) {
            
            cell.models = self.hotModels;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
            cell.firstView.tag = 11;
            cell.secondView.tag = 12;
            cell.thirdView.tag = 13;
            [cell.firstView addGestureRecognizer:tap];
            [cell.secondView addGestureRecognizer:tap2];
            [cell.thirdView addGestureRecognizer:tap3];
            
            UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
            [cell.moreView addGestureRecognizer:tap4];

        }
        return cell;
        
    }else{
        GLIntegralGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID];
        cell.model = self.interestModels[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 185 *autoSizeScaleY;
    }else{
        
        return 110 *autoSizeScaleY;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     self.hidesBottomBarWhenPushed = YES;
    if(indexPath.section != 0 ){
        
        GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
        detailVC.navigationItem.title = @"积分兑换详情";
        GLMall_InterestModel *model = self.interestModels[indexPath.row];
        detailVC.goods_id = model.goods_id;
        //    GLSubmitFirstController *submitVC = [[GLSubmitFirstController alloc] init];
        detailVC.type = 1;
        [self.navigationController pushViewController:detailVC animated:YES];
    }

     self.hidesBottomBarWhenPushed = NO;
}

#pragma mark ------------------self.view的滑动手势
#pragma mark 添加手势
-(void)addMySelfPanGesture{
    
    //添加左右滑动手势pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /********用于创建pan********/       //将左右的tab页面绘制出来，并把UIView添加到当前的self.view中
//    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
//    UIViewController* v1 = [self.tabBarController.viewControllers objectAtIndex:selectedIndex-1];
//    UIImage* image1 = [self imageByCropping:v1.view toRect:v1.view.bounds];
//    _imageviewLeft = [[UIImageView alloc] initWithImage:image1];
//    _imageviewLeft.frame = CGRectMake(_imageviewLeft.frame.origin.x - [UIScreen mainScreen].bounds.size.width, _imageviewLeft.frame.origin.y , _imageviewLeft.frame.size.width, _imageviewLeft.frame.size.height);
//    [self.view addSubview:_imageviewLeft];
//    
//    UIViewController* v2 = [self.tabBarController.viewControllers objectAtIndex:selectedIndex+1];
//    UIImage* image2 = [self imageByCropping:v2.view toRect:v2.view.bounds];
//    _imageviewRight = [[UIImageView alloc] initWithImage:image2];
//    _imageviewRight.frame = CGRectMake(_imageviewRight.frame.origin.x + [UIScreen mainScreen].bounds.size.width, 0, _imageviewRight.frame.size.width, _imageviewRight.frame.size.height);
//    [self.view addSubview:_imageviewRight];
    /********用于创建pan********/
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    /********用于移除pan时的左右两边的view********/
    [_imageviewLeft removeFromSuperview];
    [_imageviewRight removeFromSuperview];
    /********用于移除pan时的左右两边的view********/
}

#pragma mark 绘制图片
//与pan结合使用 截图方法，图片用来做动画
-(UIImage*)imageByCropping:(UIView*)imageToCrop toRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize pageSize = CGSizeMake(scale*rect.size.width, scale*rect.size.height) ;
    UIGraphicsBeginImageContext(pageSize);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGContextRef resizedContext =UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext,-1*rect.origin.x,-1*rect.origin.y);
    [imageToCrop.layer renderInContext:resizedContext];
    UIImage*imageOriginBackground =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageOriginBackground = [UIImage imageWithCGImage:imageOriginBackground.CGImage scale:scale orientation:UIImageOrientationUp];
    
    return imageOriginBackground;
}

#pragma mark Pan手势
- (void) handlePan:(UIPanGestureRecognizer*)recongizer{
    
    NSUInteger index = [self.tabBarController selectedIndex];
    
    CGPoint point = [recongizer translationInView:self.view];
    
    recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
    [recongizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recongizer.state == UIGestureRecognizerStateEnded) {
        if (recongizer.view.center.x < [UIScreen mainScreen].bounds.size.width && recongizer.view.center.x > 0 ) {
            [UIView animateWithDuration:timea delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
            }completion:^(BOOL finished) {
                
            }];
        } else if (recongizer.view.center.x <= 0 ){
            [UIView animateWithDuration:timea delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
            }completion:^(BOOL finished) {
                [self.tabBarController setSelectedIndex:index+1];
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
            }];
        } else {
            [UIView animateWithDuration:timea delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width*1.5 ,[UIScreen mainScreen].bounds.size.height/2);
            }completion:^(BOOL finished) {
                [self.tabBarController setSelectedIndex:index-1];
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
            }];
        }
    }
}

- (NSMutableArray *)hotModels{
    if (!_hotModels) {
        _hotModels = [NSMutableArray array];
    }
    return _hotModels;
}
- (NSMutableArray *)interestModels{
    if (!_interestModels) {
        _interestModels = [NSMutableArray array];
    }
    return _interestModels;
}
@end
