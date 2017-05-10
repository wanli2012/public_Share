//
//  GLRankingView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRankingView.h"
#import "GLRankingCell.h"

@interface GLRankingView ()


@end

static NSString *ID = @"GLRankingCell";
@implementation GLRankingView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLRankingCell" bundle:nil] forCellReuseIdentifier:ID];
}

#pragma UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.models[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ADAPT(30);
}
@end
