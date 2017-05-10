//
//  GLConfirmOrderController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLConfirmOrderController.h"
#import "GLOrderDetailController.h"
#import "GLOrderPayView.h"
#import "GLSet_MaskVeiw.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LBMineCentermodifyAdressViewController.h"

#import "LBMineCenterPayPagesViewController.h"
#import "GLOrderGoodsCell.h"
#import "GLConfirmOrderModel.h"

@interface GLConfirmOrderController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _sumNum;
//    GLSet_MaskVeiw *_maskV;
    LoadWaitView * _loadV;
}

@property (nonatomic, strong)GLSet_MaskVeiw *maskV;
@property (nonatomic, strong)GLOrderPayView *payV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;

@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;//运费Label
@property (weak, nonatomic) IBOutlet UILabel *totalSumLabel;//实付总价

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray  *models;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

//收货人信息
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextV;

@property (nonatomic, copy)NSString *address_id;

@end

static NSString *ID = @"GLOrderGoodsCell";
@implementation GLConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    self.contentViewW.constant = SCREEN_WIDTH;
    self.contentViewH.constant = SCREEN_HEIGHT + 49;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAddress)];
    [self.addressView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(ensurePassword:) name:@"input_PasswordNotification" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLOrderGoodsCell" bundle:nil] forCellReuseIdentifier:ID];
     [self postRequest];
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)postRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    //请求地址
    [NetworkManager requestPOSTWithURLStr:@"shop/address_list" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1){

            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                self.address_id = responseObject[@"address_id"];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    if ([dic[@"is_default"] intValue] == 1) {
                        self.nameLabel.text = [NSString stringWithFormat:@"收货人:¥%@",dic[@"collect_name"]];
                        self.phoneLabel.text = [NSString stringWithFormat:@"电话号码:%@",dic[@"s_phone"]];
                        self.addressLabel.text = [NSString stringWithFormat:@"收货地址:%@",dic[@"s_address"]];
                    }
                }
            }
        }
        
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
    
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"token"] = [UserModel defaultUser].token;
    dict1[@"uid"] = [UserModel defaultUser].uid;
    dict1[@"goods_id"] = self.goods_id;
    dict1[@"goods_count"] = self.goods_count;
    //请求商品信息
    [NetworkManager requestPOSTWithURLStr:@"shop/placeOrderBefore" paramDic:dict1 finish:^(id responseObject) {
        
        [_loadV removeloadview];
//        NSLog(@"dict = %@",dict);
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1){
            
            self.totalSumLabel.text = [NSString stringWithFormat:@"合计:¥%@",responseObject[@"data"][@"all_realy_price"]];
            self.yunfeiLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"all_delivery"]];
            
            for (NSDictionary *dic in responseObject[@"data"][@"goods_list"]) {
                GLConfirmOrderModel *model = [GLConfirmOrderModel mj_objectWithKeyValues:dic];
                [_models addObject:model];
            }
            self.tableViewHeight.constant = _models.count * 140 * autoSizeScaleY;
            self.contentViewH.constant = _models.count * 140 * autoSizeScaleY + 220;
            [self.tableView reloadData];
            
        }
        
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
    
}

- (void)changeAddress{
    LBMineCentermodifyAdressViewController *modifyAD = [[LBMineCentermodifyAdressViewController alloc] init];
    modifyAD.block = ^(NSString *name,NSString *phone,NSString *address){
        self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",name];
        self.phoneLabel.text = [NSString stringWithFormat:@"电话号码:%@",phone];
        self.addressLabel.text = [NSString stringWithFormat:@"收货地址:%@",address];
    };
    
    [self.navigationController pushViewController:modifyAD animated:YES];
}
- (void)dismiss {
    [_payV.passwordF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _payV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT *0.5);

    }completion:^(BOOL finished) {

        [_maskV removeFromSuperview];
    }];
}

- (void)ensurePassword:(NSNotification *)userInfo{
    [self dismiss];
   
//    NSLog(@"userinfo = %@",userInfo.userInfo[@"password"]);
}
  

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

//订单提交
- (IBAction)submitOrder:(UIButton *)sender {

    if (self.nameLabel.text.length == 4) {
        [MBProgressHUD showError:@"请填写收货信息"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"goods_id"] = self.goods_id;
    dict[@"goods_count"] = self.goods_count;
    dict[@"address_id"] = self.address_id;
    dict[@"remark"] = self.remarkTextV.text;
    dict[@"cart_id"] = self.cart_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/placeOrderEnd" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1){
            
            self.hidesBottomBarWhenPushed = YES;
            LBMineCenterPayPagesViewController *payVC = [[LBMineCenterPayPagesViewController alloc] init];
            payVC.payType = [responseObject[@"data"][@"order_type"] integerValue];;
            payVC.orderNum =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"ordere_sn"]];
            payVC.orderScore = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"total_price"]];
            payVC.useableScore = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_integal"]];
            payVC.order_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"order_id"]];
            payVC.pushIndex = 1;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];

    
}

//- (IBAction)changeNum:(id)sender {
//    
//    if (sender == self.reduceBtn) {
//        _sumNum -= 1;
//        if(_sumNum < 1){
//            _sumNum = 1;
//        }
//    }else{
//        _sumNum += 1;
//    }
//    self.numberLabel.text = [NSString stringWithFormat:@"%d",_sumNum];
//    
//}

#pragma  UITableveiwdelegate UITableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.orderType == 1){//1:积分商城
        cell.fanliLabel.hidden = YES;
        cell.yuanjiaLabel.hidden = NO;
    }else{
        cell.fanliLabel.hidden = NO;
        cell.yuanjiaLabel.hidden = YES;
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140 *autoSizeScaleY;
}

#pragma 懒加载
- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}
@end
