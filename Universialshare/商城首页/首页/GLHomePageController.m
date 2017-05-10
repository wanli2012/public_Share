//
//  GLHomePageController.m
//  PublicSharing
//
//  Created by 龚磊 on 2017/3/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomePageController.h"
#import "SDCycleScrollView.h"
#import "GLTopCell.h"
#import "GLHotCell.h"
#import "GLHomeRecommendCell.h"

#import "GLShoppingCartController.h"

#import "GLHomeLiveController.h"

@interface GLHomePageController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,GLTopCellDelegate>
{
     UIImageView *_imageviewLeft , *_imageviewRight;
}
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UITextField *searchF;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@end

static NSString *topID = @"GLTopCell";
static NSString *hotID = @"GLHotCell";
static NSString *recommendID = @"GLHomeRecommendCell";

@implementation GLHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 160)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
    
    _cycleScrollView.localizationImageNamesGroup = @[@"XRPlaceholder",
                                                     @"XRPlaceholder",
                                                     @"XRPlaceholder"];

    _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）

    _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    self.tableView.tableHeaderView = _cycleScrollView;
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, footerV.yy_width, footerV.yy_height - 10)];
    imageV.image = [UIImage imageNamed:@"XRPlaceholder"];
    [footerV addSubview:imageV];
    self.tableView.tableFooterView = footerV;
    
    [self setNavView];
    //[self addMySelfPanGesture];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLTopCell" bundle:nil] forCellReuseIdentifier:topID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHotCell" bundle:nil] forCellReuseIdentifier:hotID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHomeRecommendCell" bundle:nil] forCellReuseIdentifier:recommendID];
    
 
}
- (IBAction)cityChoose:(id)sender {
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)setNavView{
    
    self.titleView.layer.cornerRadius = 17.f;
    self.titleView.clipsToBounds = YES;
    
}
- (IBAction)shoppingCart:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLShoppingCartController *cartVC = [[GLShoppingCartController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (IBAction)leftBtnClick:(id)sender {
    
}
- (void)kindOfButtonClick:(NSInteger )index{

    if (index == 1) {
        self.hidesBottomBarWhenPushed = YES;
        GLHomeLiveController *liveVC = [[GLHomeLiveController alloc] init];
        [self.navigationController pushViewController:liveVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (index == 2){
        self.hidesBottomBarWhenPushed = YES;
        GLHomeLiveController *liveVC = [[GLHomeLiveController alloc] init];
        [self.navigationController pushViewController:liveVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (index == 3){
        self.hidesBottomBarWhenPushed = YES;
        GLHomeLiveController *liveVC = [[GLHomeLiveController alloc] init];
        [self.navigationController pushViewController:liveVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (index == 4){
        self.hidesBottomBarWhenPushed = YES;
        GLHomeLiveController *liveVC = [[GLHomeLiveController alloc] init];
        [self.navigationController pushViewController:liveVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}
#pragma  UITableViewDelegate UITableviewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }else if(indexPath.section == 1){
        return 140;
    }else{
        
        return 450;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerV.backgroundColor = YYSRGBColor(235, 235, 235, 1);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerV.yy_height)];

    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerV addSubview:titleLabel];
    
    if (section == 0) {
        return nil;
    }else if(section == 1){
        titleLabel.text = @"热卖精选";
        return headerV;
        
    }else{
        titleLabel.text = @"为您推荐";
        return headerV;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        
        return 30;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        
        GLTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:topID];
        topCell.delegate = self;
        cell = topCell;

    }else if (indexPath.section == 1){
        
        GLHotCell *hotCell = [tableView dequeueReusableCellWithIdentifier:hotID];
        
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell = hotCell;
        
    }else{
        
        GLHomeRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:recommendID];
        
        cell = recommendCell;
    }

    return cell;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//   
//}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
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
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    UIViewController* v1 = [self.tabBarController.viewControllers objectAtIndex:selectedIndex-1];
    UIImage* image1 = [self imageByCropping:v1.view toRect:v1.view.bounds];
    _imageviewLeft = [[UIImageView alloc] initWithImage:image1];
    _imageviewLeft.frame = CGRectMake(_imageviewLeft.frame.origin.x - [UIScreen mainScreen].bounds.size.width, _imageviewLeft.frame.origin.y , _imageviewLeft.frame.size.width, _imageviewLeft.frame.size.height);
    [self.view addSubview:_imageviewLeft];
    
    UIViewController* v2 = [self.tabBarController.viewControllers objectAtIndex:selectedIndex+1];
    UIImage* image2 = [self imageByCropping:v2.view toRect:v2.view.bounds];
    _imageviewRight = [[UIImageView alloc] initWithImage:image2];
    _imageviewRight.frame = CGRectMake(_imageviewRight.frame.origin.x + [UIScreen mainScreen].bounds.size.width, 0, _imageviewRight.frame.size.width, _imageviewRight.frame.size.height);
    [self.view addSubview:_imageviewRight];
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

@end
