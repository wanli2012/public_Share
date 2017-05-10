//
//  GLHomeLiveController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHomeLiveController.h"
#import "GLHomeLiveCell.h"
#import "GLSet_MaskVeiw.h"
#import "GLHomeLiveChooseController.h"
#import "GLHourseDetailController.h"

@interface GLHomeLiveController ()<UITableViewDelegate,UITableViewDataSource>
{
    GLSet_MaskVeiw *_maskV;
    UIView *_contentView;
    GLHomeLiveChooseController *_chooseVC;
    
    UIButton *_tmpBtn;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchF;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitPriceBtn;
@property (weak, nonatomic) IBOutlet UIButton *houseTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *sizeBtn;

@property (weak, nonatomic) IBOutlet UIButton *defaultSortBtn;
@property (weak, nonatomic) IBOutlet UIButton *totalPriceSortBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitPriceSortBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaSortBtn;

@end

@implementation GLHomeLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleView.layer.cornerRadius = 15.f;
    self.titleView.clipsToBounds = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.backBtn setImage:[UIImage imageNamed:@"iv_back"] forState:UIControlStateNormal];
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 20)];
    self.backBtn.backgroundColor=[UIColor clearColor];

    _tmpBtn = nil;
    
    self.defaultSortBtn.titleLabel.layer.cornerRadius = 5.f;
    self.totalPriceSortBtn.titleLabel.layer.cornerRadius = 5.f;
    self.unitPriceSortBtn.titleLabel.layer.cornerRadius = 5.f;
    self.areaSortBtn.titleLabel.layer.cornerRadius = 5.f;
    
    self.defaultSortBtn.titleLabel.clipsToBounds = YES;
    self.totalPriceSortBtn.titleLabel.clipsToBounds = YES;
    self.unitPriceSortBtn.titleLabel.clipsToBounds = YES;
    self.areaSortBtn.titleLabel.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:@"maskView_dismiss" object:nil];
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)changeColor{
    
    [self.areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.unitPriceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.houseTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.priceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.sizeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        _maskV.alpha = 0;
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
     [self setupControl];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_maskV removeFromSuperview];
}

- (void)setupControl {
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.topView convertRect:self.topView.bounds toView:window];
    
    _chooseVC = [[GLHomeLiveChooseController alloc] init];
    //    _chooseVC.view.frame = CGRectZero;
    _chooseVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, 0);
    _contentView = _chooseVC.view;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 4;
    _contentView.layer.masksToBounds = YES;
    
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(rect), SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _maskV.contentView = _contentView;
    _maskV.bgView.alpha = 0.1;
    
   [_maskV showViewWithContentView:_contentView];
    _maskV.alpha = 0;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sortClick:(UIButton *)sender {
    sender.titleLabel.layer.cornerRadius = 5;

    _tmpBtn.selected = NO;
    _tmpBtn.titleLabel.backgroundColor = [UIColor whiteColor];

    sender.selected = YES;
    sender.titleLabel.backgroundColor = YYSRGBColor(194, 50, 25, 1);

    _tmpBtn = sender;

    
}

- (IBAction)chooseType:(UIButton *)sender {
    
    if (_maskV.alpha == 0) {
        sender.selected = NO;
    }
    
    _maskV.alpha = 1;
    
//     sender.selected = !sender.selected;
    
    if (sender == self.areaBtn) {
        [self.areaBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _chooseVC.dataSource = @[@"1",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2"];
        self.areaBtn.selected = !self.areaBtn.selected;
        
        self.unitPriceBtn.selected = NO;
        self.houseTypeBtn.selected = NO;
        self.priceBtn.selected = NO;
        self.sizeBtn.selected = NO;
    }else if(sender == self.unitPriceBtn){
        [self.unitPriceBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _chooseVC.dataSource = @[@"2"];
        self.unitPriceBtn.selected = !self.unitPriceBtn.selected;
        
        self.areaBtn.selected = NO;
        self.houseTypeBtn.selected = NO;
        self.priceBtn.selected = NO;
        self.sizeBtn.selected = NO;
    }else if(sender == self.houseTypeBtn){
        
        [self.houseTypeBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _chooseVC.dataSource = @[@"3",@"2"];
        self.houseTypeBtn.selected = !self.houseTypeBtn.selected;
        
        self.areaBtn.selected = NO;
        self.unitPriceBtn.selected = NO;
        self.priceBtn.selected = NO;
        self.sizeBtn.selected = NO;
        
    }else if(sender == self.priceBtn){
        
        [self.priceBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _chooseVC.dataSource = @[@"4",@"2",@"2"];
        self.priceBtn.selected = !self.priceBtn.selected;
        
        self.areaBtn.selected = NO;
        self.unitPriceBtn.selected = NO;
        self.houseTypeBtn.selected = NO;
        self.sizeBtn.selected = NO;
        
    }else if(sender == self.sizeBtn){
        
        [self.sizeBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _chooseVC.dataSource = @[@"5",@"2",@"2",@"2",@"2"];
        self.sizeBtn.selected = !self.sizeBtn.selected;
        
        self.areaBtn.selected = NO;
        self.unitPriceBtn.selected = NO;
        self.houseTypeBtn.selected = NO;
        self.priceBtn.selected = NO;
    }
    
    if (sender.selected) {
//        sender.selected = !sender.selected;
        [UIView animateWithDuration:0.3 animations:^{
            
            if (_chooseVC.dataSource.count < 8) {
                _chooseVC.view.yy_height = _chooseVC.dataSource.count * 44;
            }else{
                _chooseVC.view.yy_height = SCREEN_HEIGHT * 0.5;
            }
            
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{

            _chooseVC.view.yy_height = 0;
            
        } completion:^(BOOL finished) {
            
            _maskV.alpha = 0;
        }];
    }
    
    
    [_chooseVC.tableView reloadData];
    
}

#pragma  UITableviewDelegate UITableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLHomeLiveCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GLHomeLiveCell" owner:nil options:nil].lastObject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
    GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
    detailVC.navigationItem.title = @"商品详情";
    detailVC.type = 2;
    detailVC.goods_id = @"18";
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
@end
