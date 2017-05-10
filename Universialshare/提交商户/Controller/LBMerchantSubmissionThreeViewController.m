//
//  LBMerchantSubmissionThreeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMerchantSubmissionThreeViewController.h"
#import "LBMerchantSubmissionFourViewController.h"
#import "LBAddrecomdManChooseAreaViewController.h"
#import "editorMaskPresentationController.h"
#import "MerchantInformationModel.h"

@interface LBMerchantSubmissionThreeViewController ()<UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UITextField *banktf;
@property (weak, nonatomic) IBOutlet UITextField *bankCode;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *nametf;
@property (weak, nonatomic) IBOutlet UITextField *treebank;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *nextbt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NSMutableArray *dataArr;

@property (assign, nonatomic)NSInteger selectIndex;//选择开户行下标

@end

@implementation LBMerchantSubmissionThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提交商户";
    _dataArr=[NSMutableArray array];
    [self initdatasource];//加载数据
    
}

-(void)initdatasource{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"user/openBankName" paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            self.dataArr = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

//点击开户银行
- (IBAction)tapgesturebank:(UITapGestureRecognizer *)sender {
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.dataArr;
    vc.titlestr = @"请选择开户行";
    vc.returnreslut = ^(NSInteger index){
        
        self.banktf.text = [NSString stringWithFormat:@"%@",self.dataArr[index][@"bank_name"]];
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}
//点击下一步
- (IBAction)nextbutton:(UIButton *)sender {
    
    //NSLog(@"%@",self.dataArr[self.selectIndex][@"id"]);
    
    if (self.banktf.text.length <= 0) {
        [MBProgressHUD showError:@"请选择开户行"];
        return;
    }
    if (self.bankCode.text.length <= 0) {
        [MBProgressHUD showError:@"请填写储蓄卡"];
        return;
    }
    
    if (![predicateModel IsBankCard:self.bankCode.text]) {
        [MBProgressHUD showError:@"储蓄卡格式不对"];
        return;
    }
    
    if (self.phonetf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写手机号"];
        return;
    }
    
    if (![predicateModel valiMobile:self.phonetf.text]) {
        [MBProgressHUD showError:@"手机号格式不对"];
        return;
    }
    
    if (self.nametf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写户名"];
        return;
    }
    if (self.treebank.text.length <= 0) {
        [MBProgressHUD showError:@"请填写支行"];
        return;
    }
    
    
    [MerchantInformationModel defaultUser].openBankNameid = self.dataArr[self.selectIndex][@"id"];
    [MerchantInformationModel defaultUser].bankNumbers = self.bankCode.text;
    [MerchantInformationModel defaultUser].ReservePhone = self.phonetf.text;
    [MerchantInformationModel defaultUser].SettlementName = self.nametf.text;
    [MerchantInformationModel defaultUser].SubBranch = self.treebank.text;
    
    
    self.hidesBottomBarWhenPushed = YES;
    LBMerchantSubmissionFourViewController *vc=[[LBMerchantSubmissionFourViewController alloc]init];
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


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.nametf && [string isEqualToString:@"\n"]) {
        [self.treebank becomeFirstResponder];
        return NO;
        
    }else if (textField == self.treebank && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.nametf && ![string isEqualToString:@""]) {
        //只能输入英文或中文
        NSCharacterSet * charact;
        charact = [[NSCharacterSet characterSetWithCharactersInString:NMUBERS]invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:charact]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if(canChange) {
            [MBProgressHUD showError:@"只能输入英文或中文"];
            return NO;
        }
    }
    
    return YES;

}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.baseView.layer.cornerRadius = 3;
    self.baseView.clipsToBounds = YES;
    
    self.nextbt.layer.cornerRadius = 3;
    self.nextbt.clipsToBounds = YES;

    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = SCREEN_HEIGHT - 64;

}

@end
