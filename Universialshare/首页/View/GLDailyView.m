//
//  GLDailyView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLDailyView.h"
#import "GLFirstHeartCell.h"

@interface GLDailyView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

static NSString *ID = @"GLFirstHeartCell";
@implementation GLDailyView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.tableViewHeight.constant = 180 *autoSizeScaleY;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLFirstHeartCell" bundle:nil] forCellReuseIdentifier:ID];
}

#pragma UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLFirstHeartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.models.count != 0){
       
        cell.model = self.models[indexPath.row];
    }
    if (indexPath.row == 0) {
        cell.typeLabel.text = @"米家";
    }else{
        cell.typeLabel.text = @"米商";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90 * autoSizeScaleY;
}

@end
