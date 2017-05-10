//
//  GLSubmitSecondController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLSubmitSecondController.h"
#import "GLCityModel.h"
#import "LBMerchantSubmissionThreeViewController.h"
#import "LBAddrecomdManChooseAreaViewController.h"
#import "editorMaskPresentationController.h"
#import "LBBaiduMapViewController.h"
#import "MerchantInformationModel.h"

@interface GLSubmitSecondController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    int _index;
    NSInteger _provinceIndex;
    NSInteger _cityIndex;
    NSInteger _countryIndex;
    
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)UIPickerView *pickerView;
@property (strong, nonatomic)UIView *pickerViewMask;
@property (strong, nonatomic)NodataView *nodataV;

@property (assign, nonatomic)NSInteger messageType;//消息类型 默认为1
@property (strong, nonatomic)NSMutableArray *messageArr;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *classifyOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *classifyTwoBtn;

@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstClassifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondClassifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTextF;

@property (strong, nonatomic)UIView *incentiveModelMaskV;

//省市区选择
@property (nonatomic, strong)NSMutableArray *provinceArr;
@property (nonatomic, strong)NSMutableArray *cityArr;
@property (nonatomic, strong)NSMutableArray *countryArr;
@property (nonatomic, assign)NSInteger ischosePro;//记录选择省的第几行
@property (nonatomic, assign)NSInteger ischoseCity;//记录选择市的第几行
@property (nonatomic, assign)NSInteger ischoseArea;//记录选择区的第几行

//行业
@property (nonatomic, strong)NSMutableArray *industryArr;
@property (nonatomic, assign)NSInteger isChoseFirstClassify;//记录一级分类的第几行
@property (nonatomic, assign)NSInteger isChoseSecondClassify;//记录二级分类的第几行

//地图
@property (nonatomic, copy)NSString *latStr;
@property (nonatomic, copy)NSString *longStr;
@end

@implementation GLSubmitSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提交商户";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.topView.layer.cornerRadius = 5.f;
    self.topView.layer.masksToBounds = YES;
    
    self.middleView.layer.cornerRadius = 5.f;
    self.middleView.layer.masksToBounds = YES;

    self.bottomView.layer.cornerRadius = 5.f;
    self.bottomView.layer.masksToBounds = YES;
    
    self.contentViewHeight.constant = SCREEN_HEIGHT + 40;
    self.contentViewWidth.constant = SCREEN_WIDTH;
    
    self.nextBtn.layer.cornerRadius = 5.f;
    self.nextBtn.clipsToBounds = YES;
    
    self.provinceArr = [NSMutableArray array];
    self.cityArr = [NSMutableArray array];
    self.countryArr = [NSMutableArray array];
    
    
    [self getPickerData];
}

#pragma mark - get data
- (void)getPickerData {
    //省市区列表
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"user/getCityList" paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue]==1) {
            self.provinceArr = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

    //行业列表
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
//    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"user/getHylist" paramDic:dict finish:^(id responseObject) {
//        [_loadV removeloadview];
//        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"code"] integerValue]==1) {
            self.industryArr = responseObject[@"data"];
        }else{
           
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        
    } enError:^(NSError *error) {
//        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

//选择省份
- (IBAction)choseProvince:(id)sender {
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr;
    vc.titlestr = @"请选择省份";
    vc.returnreslut = ^(NSInteger index){
        _ischosePro = index;
        _provinceLabel.text = _provinceArr[index][@"province_name"];
        _provinceLabel.textColor = [UIColor blackColor];
        _cityLabel.text = @"请选择城市";
        _cityLabel.textColor = [UIColor lightGrayColor];
        _countryLabel.text = @"请选择区域";
        _countryLabel.textColor = [UIColor lightGrayColor];
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}

//选择城市
- (IBAction)choseCity:(id)sender {
    if ([self.provinceLabel.text isEqualToString:@"请选择省份"]) {
        [MBProgressHUD showError:@"请选择省份"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr[_ischosePro][@"city"];
    vc.titlestr = @"请选择城市";
    vc.returnreslut = ^(NSInteger index){
        _ischoseCity = index;
        _cityLabel.text = _provinceArr[_ischosePro][@"city"][index][@"city_name"];
        _cityLabel.textColor = [UIColor blackColor];
        _countryLabel.text = @"请选择区域";
        _countryLabel.textColor = [UIColor lightGrayColor];
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

//选择区域
- (IBAction)choseArea:(id)sender {
    
    if ([self.cityLabel.text isEqualToString:@"请选择城市"]) {
        [MBProgressHUD showError:@"请选择城市"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"];
    
    if (vc.provinceArr.count != 0) {
        
        vc.titlestr = @"请选择区域";
        vc.returnreslut = ^(NSInteger index){
            _ischoseArea = index;
            _countryLabel.text = _provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"][index][@"country_name"];
            _countryLabel.textColor = [UIColor blackColor];
            
        };
        vc.transitioningDelegate=self;
        vc.modalPresentationStyle=UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"区域暂无数据"];
    }

}

- (IBAction)chooseFirstClassify:(id)sender {
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    if (self.industryArr.count != 0) {
        
        vc.provinceArr = self.industryArr;
        vc.titlestr = @"请选择一级行业分类";
        vc.returnreslut = ^(NSInteger index){
            _isChoseFirstClassify = index;
            _firstClassifyLabel.text = _industryArr[index][@"trade_name"];
            _firstClassifyLabel.textColor = [UIColor blackColor];
            _secondClassifyLabel.text = @"";
            
        };
        vc.transitioningDelegate=self;
        vc.modalPresentationStyle=UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"一级分类暂无数据"];
    }

}
- (IBAction)chooseSecondClassify:(id)sender {
    if ([self.cityLabel.text isEqualToString:@"请选择一级行业分类"]) {
        [MBProgressHUD showError:@"请选择一级行业分类"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    if(self.industryArr.count != 0){
        NSArray *arr = self.industryArr[_isChoseFirstClassify][@"son"];
        if(arr.count != 0){
            
            vc.provinceArr = self.industryArr[_isChoseFirstClassify][@"son"];
            vc.titlestr = @"请选择二级行业分类";
            vc.returnreslut = ^(NSInteger index){
                _isChoseSecondClassify = index;
                NSArray *son = _industryArr[_isChoseFirstClassify][@"son"];
                if (son.count == 0) {
                    _secondClassifyLabel.text = @"";
                }else{
                    
                    _secondClassifyLabel.text = _industryArr[_isChoseFirstClassify][@"son"][index][@"trade_name"];
                }
                _secondClassifyLabel.textColor = [UIColor blackColor];
                
            };
            
            vc.transitioningDelegate=self;
            vc.modalPresentationStyle=UIModalPresentationCustom;
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"二级分类暂无数据"];
        }
    }

}
- (IBAction)chooseAddress:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBBaiduMapViewController *mapVC = [[LBBaiduMapViewController alloc] init];
    mapVC.returePositon = ^(NSString *strposition,NSString *pro,NSString *city,NSString *area,CLLocationCoordinate2D coors){
//        self.adress = strposition;
//        self.sprovince = pro;
//        self.scity =city;
//        self.saera = area;
        self.latStr = [NSString stringWithFormat:@"%f",coors.latitude];
        self.longStr = [NSString stringWithFormat:@"%f",coors.longitude];
        self.addressLabel.text = [NSString stringWithFormat:@"%@",strposition];
    };
    [self.navigationController pushViewController:mapVC animated:YES];
}

//点击下一步
- (IBAction)nextbuttonevent:(UIButton *)sender {

    if ([self.provinceLabel.text isEqualToString:@"请选择省份"]) {
        [MBProgressHUD showError:@"还没有选择省份"];
        return;
    }
    if ([self.cityLabel.text isEqualToString:@"请选择城市"]) {
        [MBProgressHUD showError:@"还没有选择城市"];
        return;
    }
//    if ([self.countryLabel.text isEqualToString:@"请选择区域"]) {
//        [MBProgressHUD showError:@"还没有选择区域"];
//        return;
//    }
    if ([self.firstClassifyLabel.text isEqualToString:@"请选择分类"]) {
        [MBProgressHUD showError:@"还没有选择分类"];
        return;
    }
//    if ([self.secondClassifyLabel.text isEqualToString:@"请选择分类"]) {
//        [MBProgressHUD showError:@"还没有选择分类"];
//        return;
//    }
    if ([self.addressLabel.text isEqualToString:@"请选择地点"]) {
        [MBProgressHUD showError:@"还没有选择地点"];
        return;
    }
    if ([self.detailTextF.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"还没有填写具体地址"];
        return;
    }
    [MerchantInformationModel defaultUser].provinceId = self.provinceArr[_provinceIndex][@"province_code"];
    [MerchantInformationModel defaultUser].cityId = self.provinceArr[_provinceIndex][@"city"][_cityIndex][@"city_code"];
    
    //区域可能为空
    NSArray *countryArr = self.provinceArr[_provinceIndex][@"city"][_cityIndex][@"country"];
    if (countryArr.count == 0) {
        [MerchantInformationModel defaultUser].countryId = @"";
        
    }else{
        
        [MerchantInformationModel defaultUser].countryId = self.provinceArr[_provinceIndex][@"city"][_cityIndex][@"country"][_countryIndex][@"country_code"];
    }
    
    [MerchantInformationModel defaultUser].PrimaryClassification = self.industryArr[_isChoseFirstClassify][@"trade_id"];
    
    //二级分类可能为空
    NSArray *son = _industryArr[_isChoseFirstClassify][@"son"];
    if (son.count == 0) {
        [MerchantInformationModel defaultUser].TwoClassification = @"";
    }else{
        
        [MerchantInformationModel defaultUser].TwoClassification = _industryArr[_isChoseFirstClassify][@"son"][_isChoseSecondClassify][@"trade_id"];
    }

    [MerchantInformationModel defaultUser].mapAdress = self.addressLabel.text;
    [MerchantInformationModel defaultUser].lat = self.latStr;
    [MerchantInformationModel defaultUser].lng = self.longStr;
    [MerchantInformationModel defaultUser].detailAdress = self.detailTextF.text;
    self.hidesBottomBarWhenPushed = YES;
    LBMerchantSubmissionThreeViewController *vc=[[LBMerchantSubmissionThreeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}
//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
            
        }];
        
    }
    
}

//点击maskview
-(void)incentiveModelMaskVtapgestureLb{
    
    [self.incentiveModelMaskV removeFromSuperview];

    
}
-(UIView*)incentiveModelMaskV{
    
    if (!_incentiveModelMaskV) {
        _incentiveModelMaskV=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _incentiveModelMaskV.backgroundColor=[UIColor clearColor];
    }
    
    return _incentiveModelMaskV;
    
}


-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
- (NSMutableArray *)industryArr{
    if (!_industryArr) {
        _industryArr = [NSMutableArray array];
    }
    return _industryArr;
}
@end
