//
//  MineCollectionHeaderV.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "MineCollectionHeaderV.h"
#import <Masonry/Masonry.h>
#import "LBMineCenterinfoTableViewCell.h"
#import "UIButton+SetEdgeInsets.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDCycleScrollView.h"

@interface MineCollectionHeaderV ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>


@end

@implementation MineCollectionHeaderV


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];

        self.backgroundColor=YYSRGBColor(235, 235, 235, 1);
    }
    return self;
    
}

-(void)loadUI{
    [self addSubview:self.baseview];
    [self addSubview:self.baseview1];
    [self.baseview addSubview:self.tableview];
    
    [self.baseview addSubview:self.headview];
    [self.headview addSubview:self.headimage];
    [self.baseview addSubview:self.namelebel];
    [self.baseview1 addSubview:self.CollectinGoodsBt];
    [self.baseview1 addSubview:self.ShoppingCartBt];
    [self.baseview1 addSubview:self.OrderBt];
    [self addSubview:self.cycleScrollView];
    [self.headimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.headview).offset(-2);
        make.leading.equalTo(self.headview).offset(2);
        make.top.equalTo(self.headview).offset(2);
        make.bottom.equalTo(self.headview).offset(-2);
    }];
    
    [self.namelebel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.headview);
        make.leading.equalTo(self.headview);
        make.top.equalTo(self.headview.mas_bottom).offset(8);
        //make.height.equalTo(@20);
    }];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.baseview).offset(-10);
        make.leading.equalTo(self.headview.mas_trailing).offset(30);
        make.top.equalTo(self.baseview).offset(10);
        make.bottom.equalTo(self.baseview).offset(-10);
        
    }];
    
    [self.CollectinGoodsBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.baseview1);
        make.top.equalTo(self.baseview1);
        make.bottom.equalTo(self.baseview1);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        
    }];
    
    [self.ShoppingCartBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.CollectinGoodsBt.mas_trailing);
        make.top.equalTo(self.baseview1);
        make.bottom.equalTo(self.baseview1);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        
    }];
    
    [self.OrderBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.ShoppingCartBt.mas_trailing);
        make.top.equalTo(self.baseview1);
        make.bottom.equalTo(self.baseview1);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        
    }];
    
    
    [self.CollectinGoodsBt verticalCenterImageAndTitle:10];
    [self.ShoppingCartBt verticalCenterImageAndTitle:10];
    [self.OrderBt verticalCenterImageAndTitle:10];
    
    [self.headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserModel defaultUser].headPic]]];
    
    if (!self.headimage.image) {
        
        self.headimage.image = [UIImage imageNamed:@"mine_head"];
    }
    
    self.namelebel.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].name];
    
    if (self.namelebel.text.length <= 0) {
        
        self.namelebel.text = @"用户名";
    }
    
    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
        self.baseview1.hidden = NO;
        self.cycleScrollView.hidden = YES;
    }else{
        self.baseview1.hidden = YES;
        self.cycleScrollView.hidden = NO;
    }
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 25;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCenterinfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterinfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLb.text= [NSString stringWithFormat:@"%@",self.titleArr[indexPath.row]];
    
    if (indexPath.row == 0) {
        cell.infoL.text = [UserModel defaultUser].mark;
        if ([cell.infoL.text isEqualToString:@""]) {
            cell.infoL.text = @"0";
        }
    }else if (indexPath.row == 1){
        cell.infoL.text = [UserModel defaultUser].loveNum;
        if ([cell.infoL.text isEqualToString:@""] || [cell.infoL.text rangeOfString:@"null"].location != NSNotFound) {
            cell.infoL.text = @"0";
        }
    }else if (indexPath.row == 2){
        cell.infoL.text = [UserModel defaultUser].ketiBean;
        if ([cell.infoL.text isEqualToString:@""]) {
            cell.infoL.text = @"0";
        }
    }else if (indexPath.row == 3){
        cell.infoL.text = [UserModel defaultUser].djs_bean;
     
        if ([cell.infoL.text isEqualToString:@""]) {
            cell.infoL.text = @"0";
        }
    }else if (indexPath.row == 4){
        cell.infoL.text = [UserModel defaultUser].recommendMark;
        if ([cell.infoL.text isEqualToString:@""]) {
            cell.infoL.text = @"0";
        }
    }else if (indexPath.row == 5){
        cell.infoL.text = [UserModel defaultUser].giveMeMark;
        if ([cell.infoL.text isEqualToString:@""]) {
            cell.infoL.text = @"0";
        }
    }else if (indexPath.row == 6){
        cell.infoL.text = [UserModel defaultUser].lastFanLiTime;
        if ([cell.infoL.text isEqualToString:@""]) {
            cell.infoL.text = @"暂无";
        }
    }
    
    
    return cell;
    
    
}

#pragma mark  ---- button点击时间
//代收货
-(void)CollectinGoodsBtbtton:(UIButton*)sender{

    if (self.returnCollectinGoodsBt) {
        self.returnCollectinGoodsBt();
    }

}
//购物车
-(void)ShoppingCartBtbtton:(UIButton*)sender{

    if (self.returnShoppingCartBt) {
        self.returnShoppingCartBt();
    }

}
//订单
-(void)Orderbtton:(UIButton*)sender{

    if (self.returnOrderBt) {
        self.returnOrderBt();
    }


}


-(UIView*)baseview{
    
    if (!_baseview) {
        
    _baseview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ((SCREEN_HEIGHT - 64)  * 0.4 + 10) * 0.65 )];
    _baseview.backgroundColor=[UIColor whiteColor];
        
    }
    
    return _baseview;
}

-(UIView*)baseview1{
    
    if (!_baseview1) {
        _baseview1=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.baseview.frame) + 2, SCREEN_WIDTH, ((SCREEN_HEIGHT - 64)  * 0.4 + 10) *0.3 )];
        _baseview1.backgroundColor=[UIColor whiteColor];
        
    }
    
    return _baseview1;
    
}


-(UIView*)headview{

    if (!_headview) {
        
        _headview = ({
        
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20 *  autoSizeScaleX, 15 *  autoSizeScaleY, 80  *  autoSizeScaleX , 80 * autoSizeScaleX)];
            view.backgroundColor=YYSRGBColor(253, 180, 165, 1);
            view.layer.cornerRadius = (80  *  autoSizeScaleX)/2;
            view.clipsToBounds = YES;
            view;
        });
    }

    return _headview;
}

-(UIImageView *)headimage{

    if (!_headimage) {
        _headimage=[[UIImageView alloc]init];
        _headimage.backgroundColor=[UIColor whiteColor];
        _headimage.clipsToBounds = YES;
        _headimage.layer.cornerRadius = (80  *  autoSizeScaleX )/2 -2 ;
        _headimage.contentMode = UIViewContentModeScaleAspectFill;
        _headimage.userInteractionEnabled = YES;
        
    }
    
    return _headimage;

}

-(UILabel*)namelebel{
    
    if (!_namelebel) {
        _namelebel=[[UILabel alloc]init];
        _namelebel.backgroundColor=[UIColor clearColor];
        _namelebel.textColor=[UIColor blackColor];
        _namelebel.font=[UIFont systemFontOfSize:12 * autoSizeScaleX];
        _namelebel.textAlignment=NSTextAlignmentCenter;
        _namelebel.numberOfLines=0;
        [_namelebel sizeToFit];
        
    }
    
    return _namelebel;
    
}

-(UITableView*)tableview{
    
    if (!_tableview) {
        _tableview=[[UITableView alloc]init];
        _tableview.backgroundColor=[UIColor clearColor];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.tableFooterView=[UIView new];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator=NO;
        [_tableview registerNib:[UINib nibWithNibName:@"LBMineCenterinfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterinfoTableViewCell"];
    }
    return _tableview;
}

-(NSArray*)titleArr{

    if (!_titleArr) {
        _titleArr=[NSArray arrayWithObjects:@"米券",@"积分",@"米子",@"推荐米子",@"注册奖励",@"获得米子",@"上个激励日", nil];
    }
return _titleArr;
}


-(UIButton*)CollectinGoodsBt{
    
    if (!_CollectinGoodsBt) {
        _CollectinGoodsBt=[[UIButton alloc]init];
        _CollectinGoodsBt.backgroundColor=[UIColor clearColor];
        [_CollectinGoodsBt setTitle:@"待收货" forState:UIControlStateNormal];
        _CollectinGoodsBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_CollectinGoodsBt setImage:[UIImage imageNamed:@"待收货"] forState:UIControlStateNormal];
        [_CollectinGoodsBt addTarget:self action:@selector(CollectinGoodsBtbtton:) forControlEvents:UIControlEventTouchUpInside];
        [_CollectinGoodsBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return _CollectinGoodsBt;
    
}

-(UIButton*)ShoppingCartBt{
    
    if (!_ShoppingCartBt) {
        _ShoppingCartBt=[[UIButton alloc]init];
        _ShoppingCartBt.backgroundColor=[UIColor clearColor];
        [_ShoppingCartBt setTitle:@"购物车" forState:UIControlStateNormal];
        _ShoppingCartBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_ShoppingCartBt setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
        [_ShoppingCartBt addTarget:self action:@selector(ShoppingCartBtbtton:) forControlEvents:UIControlEventTouchUpInside];
         [_ShoppingCartBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return _ShoppingCartBt;
    
}

-(UIButton*)OrderBt{
    
    if (!_OrderBt) {
        _OrderBt=[[UIButton alloc]init];
        _OrderBt.backgroundColor=[UIColor clearColor];
        [_OrderBt setTitle:@"订单" forState:UIControlStateNormal];
        _OrderBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_OrderBt setImage:[UIImage imageNamed:@"订单"] forState:UIControlStateNormal];
        [_OrderBt addTarget:self action:@selector(Orderbtton:) forControlEvents:UIControlEventTouchUpInside];
         [_OrderBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return _OrderBt;
    
}

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.baseview.frame) + 1, SCREEN_WIDTH, self.frame.size.height - CGRectGetHeight(self.baseview.frame) )
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
        
        _cycleScrollView.localizationImageNamesGroup = @[];
        
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    }

    return _cycleScrollView;

}
@end
