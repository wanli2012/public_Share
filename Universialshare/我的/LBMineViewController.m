//
//  LBMineViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineViewController.h"
#import "MineCollectionHeaderV.h"
#import "LBMineCenterCollectionViewCell.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBSetUpViewController.h"
#import "LBMineMessageViewController.h"
#import "LBMineCenterReceivingGoodsViewController.h"
#import "LBMineCenterMyOrderViewController.h"
#import "LBMineCenterMyBalanceViewController.h"

#import "GLMyHeartController.h"
#import "GLDirectDonationController.h"
#import "GLMine_MyBeansController.h"
#import "GLBuyBackController.h"
#import "GLDonationController.h"
#import "GLRecommendController.h"
#import "GLMine_InfoController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GLNoneOfDonationController.h"
#import "LBMineStoreOrderingViewController.h"
#import "LBMineSelectCustomerTypeView.h"
#import "LBMineCenterUsualUnderOrderViewController.h"
#import "GLSubmitFirstController.h"
#import "LBSaleManPersonInfoViewController.h"
#import "LBRecommendedBusinessAuditViewController.h"
#import "LBBelowTheLineViewController.h"
#import "GLShoppingCartController.h"
#import <SDWebImage/UIButton+WebCache.h>


@interface LBMineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UIImageView *_imageviewLeft;
}

@property(nonatomic,strong)UICollectionView *collectionV;
@property(nonatomic,strong) MineCollectionHeaderV *headview;
@property(nonatomic,strong)NSArray *titlearr;
@property(nonatomic,strong)NSArray *imageArr;
@property (strong, nonatomic)LBMineSelectCustomerTypeView *SelectCustomerTypeView;
@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)NSString *ordertype;//订单类型 默认为线上类型 1 为线上 2线下

@property (strong, nonatomic)NSMutableArray *CarouselArr;//轮播图图片

@end

@implementation LBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self addMySelfPanGesture];
    
    // 注册表头
    [self.collectionV registerClass:[MineCollectionHeaderV class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MineCollectionHeaderV"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"LBMineCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBMineCenterCollectionViewCell"];
    
    [self.view addSubview:self.collectionV];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMineCollection) name:@"refreshMine" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
    _ordertype = @"1";
    
}

-(void)refreshMineCollection{
    
    [self.collectionV reloadData];
    [self.headview.tableview reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
     self.navigationController.navigationBar.hidden = YES;
    [self refreshDataSource];
    
    if (self.CarouselArr.count<=0) {
        [self getdatasorce];
    }
    
}

-(void)pushToInfoVC{
    
    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser] || [[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        self.hidesBottomBarWhenPushed=YES;
        GLMine_InfoController *infoVC = [[GLMine_InfoController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else{
        self.hidesBottomBarWhenPushed=YES;
        LBSaleManPersonInfoViewController *infoVC = [[LBSaleManPersonInfoViewController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return 6;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBMineCenterCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    
    [cell.button setImage:[UIImage imageNamed:self.imageArr[indexPath.row]] forState:UIControlStateNormal];
    [cell.button setTitle:[NSString stringWithFormat:@"%@",self.titlearr[indexPath.row]] forState:UIControlStateNormal];
    
    [cell.button verticalCenterImageAndTitle:15];
   
    return cell;
    
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH-3)/3, ((SCREEN_WIDTH-3)/3)+13);

}

//选择cell时
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UserModel defaultUser].usrtype isEqualToString:ONESALER] || [[UserModel defaultUser].usrtype isEqualToString:TWOSALER] || [[UserModel defaultUser].usrtype isEqualToString:TWOSALER]) {
        switch (indexPath.row) {
            case 0:
            {
                
                self.hidesBottomBarWhenPushed=YES;
                GLSubmitFirstController *vc=[[GLSubmitFirstController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }
                
                break;
            case 1:
            {
                self.hidesBottomBarWhenPushed=YES;
                GLDirectDonationController *vc=[[GLDirectDonationController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                
                break;
            case 2:
            {
                if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]) {
                    self.hidesBottomBarWhenPushed=YES;
                    LBRecommendedBusinessAuditViewController *vc=[[LBRecommendedBusinessAuditViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed=NO;
                }else{
                
                    self.hidesBottomBarWhenPushed=YES;
                    LBRecommendedBusinessAuditViewController *vc=[[LBRecommendedBusinessAuditViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed=NO;
                }
                
            }
                break;
            case 3:
            {
                self.hidesBottomBarWhenPushed=YES;
                GLBuyBackController *vc=[[GLBuyBackController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
            case 4:
            {
                self.hidesBottomBarWhenPushed=YES;
                GLDonationController *vc=[[GLDonationController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
            case 5:
            {
                self.hidesBottomBarWhenPushed=YES;
                GLRecommendController *vc=[[GLRecommendController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
                
            default:
                break;
        }
    
    }else{
    
        switch (indexPath.row) {
            case 0:
            {
                
                if ([[UserModel defaultUser].groupId isEqualToString:OrdinaryUser]) {
                    
                    self.hidesBottomBarWhenPushed=YES;
                    GLMyHeartController *vc=[[GLMyHeartController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed=NO;
                }else{
                    self.hidesBottomBarWhenPushed=YES;
                    GLNoneOfDonationController *vc = [[GLNoneOfDonationController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed=NO;
                }
                
            }
                
                break;
            case 1:
            {
                if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
                    self.hidesBottomBarWhenPushed=YES;
                    LBBelowTheLineViewController *vc=[[LBBelowTheLineViewController alloc]init];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed=NO;
                }else{
                    self.hidesBottomBarWhenPushed=YES;
                    GLDirectDonationController *vc=[[GLDirectDonationController alloc]init];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed=NO;
                }
            }
                
                break;
            case 2:
            {
                self.hidesBottomBarWhenPushed=YES;
                GLMine_MyBeansController *vc=[[GLMine_MyBeansController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }
                break;
            case 3:
            {
                self.hidesBottomBarWhenPushed=YES;
                GLBuyBackController *vc=[[GLBuyBackController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
            case 4:
            {
                self.hidesBottomBarWhenPushed=YES;
                GLDonationController *vc=[[GLDonationController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
            case 5:
            {
                self.hidesBottomBarWhenPushed=YES;
                GLRecommendController *vc=[[GLRecommendController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
                break;
            case 6:
                
            {
                self.hidesBottomBarWhenPushed=YES;
                LBMineCenterMyBalanceViewController *vc=[[LBMineCenterMyBalanceViewController alloc]init];
                vc.vcIndex = 1;
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }
                
                break;
            case 7:
            {
                {
                    self.hidesBottomBarWhenPushed=YES;
                    LBMineCenterMyBalanceViewController *vc=[[LBMineCenterMyBalanceViewController alloc]init];
                    vc.vcIndex = 2;
                    [self.navigationController pushViewController:vc animated:YES];
                    self.hidesBottomBarWhenPushed=NO;
                    
                }
                
            }
                break;
            case 8:
            {
                self.hidesBottomBarWhenPushed=YES;
                LBMineCenterMyBalanceViewController *vc=[[LBMineCenterMyBalanceViewController alloc]init];
                vc.vcIndex = 3;
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }
                break;
                
                
            default:
                break;
        }
    
    }
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (!_headview) {
        _headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                       withReuseIdentifier:@"MineCollectionHeaderV"
                                                              forIndexPath:indexPath];

        //待收货
        __weak typeof(self)  weakself = self;
        _headview.returnCollectinGoodsBt = ^(){
            
            weakself.hidesBottomBarWhenPushed=YES;
            LBMineCenterReceivingGoodsViewController *vc=[[LBMineCenterReceivingGoodsViewController alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
            weakself.hidesBottomBarWhenPushed=NO;
            
        };
        //    购物车
        _headview.returnShoppingCartBt = ^(){
            weakself.hidesBottomBarWhenPushed = YES;
            GLShoppingCartController *cartVC = [[GLShoppingCartController alloc] init];
            [weakself.navigationController pushViewController:cartVC animated:YES];
            weakself.hidesBottomBarWhenPushed = NO;
        };
        //    订单
        _headview.returnOrderBt = ^(){
            
            if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
                weakself.hidesBottomBarWhenPushed=YES;
                LBMineStoreOrderingViewController *vc=[[LBMineStoreOrderingViewController alloc]init];
                vc.hideNavB = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
                weakself.hidesBottomBarWhenPushed=NO;
            
            }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]){
            
                [weakself.view addSubview:weakself.maskView];
                [weakself.maskView addSubview:weakself.SelectCustomerTypeView];
            
            }

        };
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToInfoVC)];
        [_headview.headimage addGestureRecognizer:tap];
        
        [_headview.headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserModel defaultUser].headPic]]];
        
        if (!_headview.headimage.image) {
            
            _headview.headimage.image = [UIImage imageNamed:@"mine_head"];
        }
        
        _headview.namelebel.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].name];
        
        if (_headview.namelebel.text.length <= 0) {
            
            _headview.namelebel.text = @"用户名";
        }
        
    }
    
    return _headview;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 1, 0);
}


#pragma mark ---- button
//设置
- (IBAction)setupevent:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    LBSetUpViewController *vc=[[LBSetUpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

//消息
- (IBAction)messagebutton:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    LBMineMessageViewController *vc=[[LBMineMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
    
    
    
}

#pragma mark 懒加载

-(UICollectionView *)collectionV{

    if (!_collectionV) {
        
         UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
         [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 10, 0)];
        if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
           [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT - 64) * 0.4 + 10)];
        }else{
            [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT - 64) * 0.45)];
        }
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:0.0];
        [flowLayout setMinimumLineSpacing:0.0];
        
        _collectionV =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 - 50)collectionViewLayout:flowLayout];
        _collectionV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionV.alwaysBounceVertical = YES;
        _collectionV.showsVerticalScrollIndicator = NO;
        //设置代理
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
    }
    return _collectionV;
}

-(NSArray*)titlearr{

    if (!_titlearr) {
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            _titlearr=[NSArray arrayWithObjects:@"让利",@"线下下单",@"我的米柜",@"兑换",@"转赠",@"我要推荐",@"余额",@"营业额",@"我的积分", nil];
        }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
           _titlearr=[NSArray arrayWithObjects:@"积分",@"直捐",@"我的米柜",@"兑换",@"转赠",@"我要推荐",@"余额",@"营业额",@"我的积分", nil];
        }
        else if ([[UserModel defaultUser].usrtype isEqualToString:ONESALER] || [[UserModel defaultUser].usrtype isEqualToString:TWOSALER]) {
            _titlearr=[NSArray arrayWithObjects:@"开通商家",@"直捐",@"开通推广员",@"兑换",@"转赠",@"我要推荐", nil];
        }
        else if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]) {
           _titlearr=[NSArray arrayWithObjects:@"开通商家",@"直捐",@"我的米柜",@"兑换",@"转赠",@"我要推荐", nil];
        }
    }
    return _titlearr;

}

-(NSArray*)imageArr{

    if (!_imageArr) {
        
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            _imageArr=[NSArray arrayWithObjects:@"让利",@"直捐",@"我的米子",@"回购",@"转赠",@"我要推荐",@"余额",@"我的信使豆",@"我的积分", nil];
        }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
            _imageArr=[NSArray arrayWithObjects:@"米袋",@"直捐",@"我的米子",@"回购",@"转赠",@"我要推荐",@"余额",@"我的返利",@"我的积分", nil];
        }
        else if ([[UserModel defaultUser].usrtype isEqualToString:ONESALER] || [[UserModel defaultUser].usrtype isEqualToString:TWOSALER]) {
           _imageArr=[NSArray arrayWithObjects:@"开通米商",@"直捐",@"开通推广员",@"回购",@"转赠",@"我要推荐", nil];
        }
        else if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]) {
            _imageArr=[NSArray arrayWithObjects:@"开通米商",@"直捐",@"我的米子",@"回购",@"转赠",@"我要推荐", nil];
        }
    }
    return _imageArr;

}

//点击maskview
-(void)maskviewgesture{
    
   
    
}
//线上订单
-(void)selectonlineorder{

    self.ordertype = @"1";
    self.SelectCustomerTypeView.imagev1.image = [UIImage imageNamed:@"location_on"];
    self.SelectCustomerTypeView.imagev2.image = [UIImage imageNamed:@"location_off"];

}
//线下订单
-(void)selectunderlineorder{
    
    self.ordertype = @"2";
    self.SelectCustomerTypeView.imagev1.image = [UIImage imageNamed:@"location_off"];
    self.SelectCustomerTypeView.imagev2.image = [UIImage imageNamed:@"location_on"];
    
}
#pragma mark ---- 选择线上线下订单类型
-(void)selectCustomerTypeViewCancelBt{

    [self.maskView removeFromSuperview];
    [self.SelectCustomerTypeView removeFromSuperview];
}

-(void)selectCustomerTypeViewsureBt{
    
    if ([self.ordertype isEqualToString:@"1"]) {//线上
        self.hidesBottomBarWhenPushed=YES;
        LBMineCenterMyOrderViewController *vc=[[LBMineCenterMyOrderViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        [self.maskView removeFromSuperview];
        [self.SelectCustomerTypeView removeFromSuperview];
    }else  if ([self.ordertype isEqualToString:@"2"]) {//线下
        
        self.hidesBottomBarWhenPushed=YES;
        LBMineCenterUsualUnderOrderViewController *vc=[[LBMineCenterUsualUnderOrderViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        [self.maskView removeFromSuperview];
        [self.SelectCustomerTypeView removeFromSuperview];
    }
}

-(LBMineSelectCustomerTypeView*)SelectCustomerTypeView{
    
    if (!_SelectCustomerTypeView) {
        _SelectCustomerTypeView=[[NSBundle mainBundle]loadNibNamed:@"LBMineSelectCustomerTypeView" owner:self options:nil].firstObject;
        _SelectCustomerTypeView.frame=CGRectMake(20, (SCREEN_HEIGHT - 210)/2, SCREEN_WIDTH-40, 201);
        _SelectCustomerTypeView.alpha=1;
        UITapGestureRecognizer *shanVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectonlineorder)];
        
        [_SelectCustomerTypeView.baseView1 addGestureRecognizer:shanVgesture];
        //
        UITapGestureRecognizer *lingVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectunderlineorder)];
        //
        [_SelectCustomerTypeView.baseView2 addGestureRecognizer:lingVgesture];
        [_SelectCustomerTypeView.cancelBt addTarget:self action:@selector(selectCustomerTypeViewCancelBt) forControlEvents:UIControlEventTouchUpInside];
        [_SelectCustomerTypeView.sureBt addTarget:self action:@selector(selectCustomerTypeViewsureBt) forControlEvents:UIControlEventTouchUpInside];
        _SelectCustomerTypeView.layer.cornerRadius = 4;
        _SelectCustomerTypeView.clipsToBounds = YES;
        
    }
    
    return _SelectCustomerTypeView;
    
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
        //UITapGestureRecognizer *maskvgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskviewgesture)];
        //[_maskView addGestureRecognizer:maskvgesture];
        
       
        
    }
    return _maskView;
    
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
    
    /********用于创建pan********/
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    /********用于移除pan时的左右两边的view********/
    [_imageviewLeft removeFromSuperview];
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
    
    
    if (recongizer.view.center.x + point.x <  [UIScreen mainScreen].bounds.size.width/2) {
        recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, recongizer.view.center.y);
    } else {
        recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
    }
    [recongizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recongizer.state == UIGestureRecognizerStateEnded) {
        if (recongizer.view.center.x <= [UIScreen mainScreen].bounds.size.width && recongizer.view.center.x >= 0 ) {
            [UIView animateWithDuration:timea delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
            }completion:^(BOOL finished) {
                
            }];
        } else if (recongizer.view.center.x <= 0 ){
            
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

//刷新数据
-(void)refreshDataSource{

    [NetworkManager requestPOSTWithURLStr:@"user/refresh" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == 1) {
            
            [UserModel defaultUser].mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].loveNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lovenum"]];
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"common"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"taxes"]];
            [UserModel defaultUser].giveMeMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"give_me_bean"]];
            [UserModel defaultUser].lastFanLiTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lasttime"]];
            [UserModel defaultUser].recommendMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"tjtc"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].shop_address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_address"]];
            [UserModel defaultUser].shop_type = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_type"]];
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].headPic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pic"]];
            [UserModel defaultUser].AudiThrough = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"status"]];
            
            if ([[UserModel defaultUser].idcard rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].idcard = @"";
            }
            if ([[UserModel defaultUser].shop_type rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].shop_type = @"";
            }
            if ([[UserModel defaultUser].shop_address rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].shop_address = @"";
            }
            if ([[UserModel defaultUser].truename rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].banknumber = @"";
            }
            
            [usermodelachivar achive];
  

            [self.headview.headimage sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].headPic]];
            
            if (!self.headview.headimage.image) {
                
                self.headview.headimage.image = [UIImage imageNamed:@"mine_head"];
            }
            
            [self.headview.tableview reloadData];
           
        }else{
            
        }

    } enError:^(NSError *error) {
        
    }];
}

-(void)getdatasorce{
    
    NSDictionary *dic;
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        dic = @{@"type":@"1"};
    }else if ([[UserModel defaultUser].usrtype isEqualToString:ONESALER]){
        dic = @{@"type":@"2"};
    }else if ([[UserModel defaultUser].usrtype isEqualToString:TWOSALER]){
        dic = @{@"type":@"3"};
    }else if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]){
        dic = @{@"type":@"4"};
    }
    [NetworkManager requestPOSTWithURLStr:@"index/banner_list" paramDic:dic finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                self.CarouselArr = responseObject[@"data"];
                NSMutableArray *imageArr=[NSMutableArray array];
                
                for (int i=0; i<[responseObject[@"data"]count]; i++) {
                    UIImageView *imagev=[[UIImageView alloc]init];
                    [imagev sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][i][@"img_path"]]];
                    
                    if (imagev.image) {
                        [imageArr addObject:responseObject[@"data"][i][@"img_path"]];
                    }
                    
                }
                
                self.headview.cycleScrollView.imageURLStringsGroup = imageArr;
            }
            
        }else{
            
            
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}

-(NSMutableArray*)CarouselArr{

    if (!_CarouselArr) {
        _CarouselArr=[NSMutableArray array];
    }

    return _CarouselArr;
}
@end
