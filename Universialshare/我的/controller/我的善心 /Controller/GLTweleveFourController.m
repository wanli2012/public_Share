//
//  GLPersentController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLTweleveFourController.h"
#import "GLMine_MyHeartCell.h"

@interface GLTweleveFourController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
}
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *models;

@end

static NSString *ID = @"GLMine_MyHeartCell";
@implementation GLTweleveFourController

- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [NSMutableArray array];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"type"] = @"3";
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"user/mylove" paramDic:dict finish:^(id responseObject) {
//            NSLog(@"%@",responseObject);
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue]== 1) {
                
                GLMyheartModel *model = [GLMyheartModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self.models addObject:model];
                
                [self.tableView reloadData];
                
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
            
        }];

    }
    return _models;
}
-(UITableView*)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_MyHeartCell" bundle:nil] forCellReuseIdentifier:ID];
   
   
}

#pragma  UITableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.models.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_MyHeartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    cell.model = self.models[indexPath.row];
    GLMyheartModel *model = self.models[indexPath.row];
    if ([model.money rangeOfString:@"null"].location != NSNotFound) {
        model.money = @"1970-01-01";
    }
    if ([model.zjl rangeOfString:@"null"].location != NSNotFound) {
        model.zjl = @"1970-01-01";
    }
    if ([model.love rangeOfString:@"null"].location != NSNotFound) {
        model.love = @"0.00";
    }
    if ([model.jl_love rangeOfString:@"null"].location != NSNotFound) {
        model.jl_love = @"0.00";
    }
    if ([model.end_love rangeOfString:@"null"].location != NSNotFound) {
        model.end_love = @"0.00";
    }
    if ([model.end_bean rangeOfString:@"null"].location != NSNotFound) {
        model.end_bean = @"0.00";
    }
    if ([model.bean rangeOfString:@"null"].location != NSNotFound) {
        model.bean = @"0.00";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}


@end
