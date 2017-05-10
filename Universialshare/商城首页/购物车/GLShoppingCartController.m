//
//  GLShoppingCartController.m
//  PublicSharing
//
//  Created by 龚磊 on 2017/3/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLShoppingCartController.h"
#import "GLShoppingCell.h"
#import "GLConfirmOrderController.h"

@interface GLShoppingCartController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_numArr;
    NSInteger _yesSum;
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearingBtn;

@property (nonatomic, assign)BOOL isSelectedRightBtn;

@property (nonatomic, strong)NSMutableArray *selectArr;

@property (nonatomic, strong)UIButton *seleteAllBtn;

@property (nonatomic, strong)UIButton *rightBtn;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, assign)NSInteger totalPrice;

@property (nonatomic, assign)NSInteger totalNum;

@property (nonatomic, strong)NSMutableArray *models;

@end

static NSString *ID = @"GLShoppingCell";
@implementation GLShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLShoppingCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.tableHeaderView = self.headerView;
    
     [self.clearingBtn addTarget:self action:@selector(clearingMore:) forControlEvents:UIControlEventTouchUpInside];
//    self.selectedNumLabel.text = [NSString stringWithFormat:@"已选中%ld件商品",_totalNum];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总金额¥ %ld元",_totalPrice];
    [self updateTitleNum];
    [self postRequest];
    
}

- (void)postRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/myCartList" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        NSLog(@"responseObject = %@",responseObject);
        
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                if ([responseObject[@"code"] integerValue] == 1){
                    for (NSDictionary *dic in responseObject[@"data"]) {
                        
                        GLShoppingCartModel *model = [GLShoppingCartModel mj_objectWithKeyValues:dic];
                        [self.models addObject:model];
                    }
                    
                    [self.tableView reloadData];
                }
            }
     
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}

//去结算
- (void)clearingMore:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"去结算"]) {
        if (_yesSum > 0) {
            
            NSMutableString *goods_idStrM = [NSMutableString string];
            NSMutableString *goods_numStrM = [NSMutableString string];
            NSMutableString *cart_idM = [NSMutableString string];
            for (int i = 0; i < _models.count; i ++) {
                if ([self.selectArr[i] boolValue]) {
                    GLShoppingCartModel *model = _models[i];
                    [goods_idStrM appendFormat:@"%@,",model.goods_id];
                    [goods_numStrM appendFormat:@"%@,",model.num];
                    [cart_idM appendFormat:@"%@,",model.cart_id];
                }
            }
            
            [goods_idStrM deleteCharactersInRange:NSMakeRange([goods_idStrM length]-1, 1)];
            [goods_numStrM deleteCharactersInRange:NSMakeRange([goods_numStrM length]-1, 1)];
            [cart_idM deleteCharactersInRange:NSMakeRange([cart_idM length]-1, 1)];
            self.hidesBottomBarWhenPushed = YES;
            GLConfirmOrderController *payVC = [[GLConfirmOrderController alloc] init];
            payVC.goods_id = goods_idStrM;
            payVC.goods_count = goods_numStrM;
            payVC.cart_id = cart_idM;
            NSLog(@"goods_idStrM = %@,goods_numStrM = %@",goods_idStrM,goods_numStrM);
            
            [self.navigationController pushViewController:payVC animated:YES];
        }else{
            [MBProgressHUD showError:@"请选择商品"];
        }
        
    }else{
        
//        NSLog(@"删除%ld件商品",_totalNum);
//        
//        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
//        // 遍历选中的数据源的index并添加到set里面
//        for (int i = 0; i < self.selectArr.count; i ++) {
//            if ([self.selectArr[i] boolValue] == YES) {
//                [indexs addIndex:i];
//                _totalPrice -= [_dataSource[i] integerValue] * [_numArr[i] integerValue];
//            }
//        }
//        _totalNum = 0;
//        self.selectedNumLabel.text = [NSString stringWithFormat:@"已选中%ld件商品",_totalNum];
//        self.totalPriceLabel.text = [NSString stringWithFormat:@"总金额¥ %ld元",_totalPrice];
//        //  删除选中数据源 并更新tableView
////        [dataSource removeObjectsAtIndexes:indexs];
//        [self.selectArr removeObjectsAtIndexes:indexs];
//        [self.dataSource removeObjectsAtIndexes:indexs];
//        [_numArr removeObjectsAtIndexes:indexs];
//        
//        [self updateTitleNum];
//        
//        [self.tableView reloadData];
//        
    }
}
//全选
- (void)selectAll {
    self.seleteAllBtn.selected = !self.seleteAllBtn.selected;
    _totalPrice = 0;
    _totalNum = 0;
    for (int i = 0; i< self.selectArr.count; i ++) {
        
        BOOL tempBool = [self.selectArr[i] boolValue];
        
        if (self.seleteAllBtn.selected) {
            tempBool = YES;
            _yesSum = self.selectArr.count;
            _totalPrice += [self.dataSource[i] integerValue] * [_numArr[i] integerValue];
            _totalNum += [_numArr[i] integerValue];
        }else{
            tempBool = NO;
            _yesSum = 0;
        }
        
        [self.selectArr replaceObjectAtIndex:i withObject:@(tempBool)];
        
    }

    if(self.seleteAllBtn.selected){
        
        [self.seleteAllBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        self.selectedNumLabel.text = [NSString stringWithFormat:@"已选中%lu件商品",_totalNum];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"总金额¥ %ld元",_totalPrice];
        
    }else{
        
        self.selectedNumLabel.text = [NSString stringWithFormat:@"已选中0件商品"];
        self.totalPriceLabel.text = @"总金额¥ 0元";
        [self.seleteAllBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        _totalNum = 0;
        _totalPrice = 0;
        
    }
    [self updateTitleNum];
    [self.tableView reloadData];
}
//选中,取消选中
- (void)changeStatus:(NSInteger)index {
    
    BOOL isSelected = [self.selectArr[index] boolValue];

    isSelected = !isSelected;
    
    if (isSelected) {
         _yesSum += 1;
        _totalNum += [_numArr[index] integerValue];
        _totalPrice += [self.dataSource[index] integerValue] * [_numArr[index] integerValue];
    }else{
        _yesSum -= 1;
        _totalNum -= [_numArr[index] integerValue];
        _totalPrice -= [self.dataSource[index] integerValue]* [_numArr[index] integerValue];
    }

    self.selectedNumLabel.text = [NSString stringWithFormat:@"已选中%ld件商品",_totalNum];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总金额%ld元",_totalPrice];
    [self.selectArr replaceObjectAtIndex:index withObject:@(isSelected)];

    
    if (_yesSum == self.selectArr.count) {
        
        [self.seleteAllBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }else{
        [self.seleteAllBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];

    }
    
    [self updateTitleNum];
    [self.tableView reloadData];

}

- (void)updateTitleNum {
    self.navigationItem.title = [NSString stringWithFormat:@"购物车(%ld)",_totalNum];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.model = self.models[indexPath.row];
    
    if ([self.selectArr[indexPath.row] boolValue] == NO) {

        [cell.selectedBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }else{

        [cell.selectedBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
       
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self changeStatus:indexPath.row];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WS(weakself);
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            if ([self.selectArr[indexPath.row] boolValue] == YES) {
                _yesSum -= 1;
                if (_yesSum <= 0) {
                    _yesSum = 0;
                }
            }
            
            GLShoppingCartModel *model = self.models[indexPath.row];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"goods_id"] = model.goods_id;
            dict[@"cart_id"] = model.cart_id;
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:@"shop/delCart" paramDic:dict finish:^(id responseObject) {
                
                [_loadV removeloadview];
//                NSLog(@"dict = %@",dict);
                if ([responseObject[@"code"] integerValue] == 1){
                
                    
                    [self.selectArr removeObjectAtIndex:indexPath.row];
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    [_numArr removeObjectAtIndex:indexPath.row];
                    [self.models removeObjectAtIndex:indexPath.row];
                    
//                    NSLog(@"indexPath.row = %lu",indexPath.row);
//                    NSLog(@"indexPath = %@",indexPath);
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    if(_yesSum != self.selectArr.count || _yesSum == 0){
                        [self.seleteAllBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                    }else{
                        [self.seleteAllBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                    }
                    
                }else{
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
                
            } enError:^(NSError *error) {
                [_loadV removeloadview];
            }];

        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



- (UIView *)headerView {
    
    if(_headerView == nil){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAll)];
        [_headerView addGestureRecognizer:tap];
        _seleteAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
        //        _seleteAllBtn.backgroundColor = [UIColor lightGrayColor];
        [_seleteAllBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
//        [_seleteAllBtn addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
        _seleteAllBtn.userInteractionEnabled = NO;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_seleteAllBtn.frame) + 10, _seleteAllBtn.yy_y, 80, _seleteAllBtn.yy_height)];
        label.text = @"全选";
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.alpha = 0.3;
        
        
        [_headerView addSubview:_seleteAllBtn];
        [_headerView addSubview:label];
        [_headerView addSubview:lineView];
    }
    return  _headerView;
    
}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
        _numArr = [NSMutableArray array];
        for (int  i = 0; i < self.models.count; i ++) {
            BOOL isSelected = NO;
            [_selectArr addObject:@(isSelected)];
            GLShoppingCartModel *model = self.models[i];
            [_numArr addObject:model.num];;
        }
    }
    return _selectArr;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (int i = 0; i < self.models.count; i ++) {
            GLShoppingCartModel *model = self.models[i];
            [_dataSource addObject:model.goods_price];
        }
    }
    return _dataSource;
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
@end
