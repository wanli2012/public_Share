//
//  GLHomeLiveChooseController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHomeLiveChooseController.h"

@interface GLHomeLiveChooseController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GLHomeLiveChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


@end
