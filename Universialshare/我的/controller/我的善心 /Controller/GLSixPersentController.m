//
//  GLPersentController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLSixPersentController.h"
#import "GLMine_MyHeartCell.h"

@interface GLSixPersentController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *models;

@end

static NSString *ID = @"GLMine_MyHeartCell";

@implementation GLSixPersentController

- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [NSMutableArray array];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"type"] = @"1";
        NSLog(@"%@",dict);
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"user/mylove" paramDic:dict finish:^(id responseObject) {
            NSLog(@"%@",responseObject);
            [_loadV removeloadview];
           if ([responseObject[@"code"] integerValue] == 1) {
            
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
    GLMyheartModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

@end
