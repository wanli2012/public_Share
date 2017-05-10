//
//  LBMineCenterFlyNoticeDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterFlyNoticeDetailViewController.h"
#import "LBMineCenterFlyNoticeDetailTableViewCell.h"
#import "LBMineCenterFlyNoticeDetailOneTableViewCell.h"


@interface LBMineCenterFlyNoticeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation LBMineCenterFlyNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流详情";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.tableview.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterFlyNoticeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterFlyNoticeDetailTableViewCell"];
    
     [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterFlyNoticeDetailOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterFlyNoticeDetailOneTableViewCell"];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 80;
    }else{
        return 70;
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        LBMineCenterFlyNoticeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        return cell;
    }else{
        LBMineCenterFlyNoticeDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeDetailOneTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 1 ) {
            
            cell.lineview.hidden = YES;
        }else if(indexPath.row == 4){
        
            cell.bottomV.hidden = YES;
        }else{
           cell.lineview.hidden = NO;
          cell.bottomV.hidden = NO;
        }
        
        return cell;
    }
    
}



@end
