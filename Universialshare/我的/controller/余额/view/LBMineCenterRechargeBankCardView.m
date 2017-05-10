//
//  LBMineCenterRechargeBankCardView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterRechargeBankCardView.h"
#import "LBMineCenterRechargeBankCardTableViewCell.h"

@interface LBMineCenterRechargeBankCardView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LBMineCenterRechargeBankCardView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"LBMineCenterRechargeBankCardView" owner:nil options:nil].firstObject;
        self.frame = frame;
        self.surebutton.layer.cornerRadius = 4;
        self.surebutton.clipsToBounds = YES;
        
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        
        self.tableview.tableFooterView = [UIView new];
        
        [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterRechargeBankCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterRechargeBankCardTableViewCell"];
        
    }
    
    return self;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCenterRechargeBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterRechargeBankCardTableViewCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    if ([self.selctB[indexPath.row] boolValue] == YES) {
        cell.selctBt.backgroundColor = [UIColor redColor];
    }else{
        cell.selctBt.backgroundColor = [UIColor yellowColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}




@end
