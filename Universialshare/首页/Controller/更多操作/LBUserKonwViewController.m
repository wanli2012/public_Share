//
//  LBUserKonwViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBUserKonwViewController.h"
#import "LBUserKonwViewTableViewCell.h"

@interface LBUserKonwViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NSDictionary *dataDic;

@end

@implementation LBUserKonwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden = NO;
    
    self.title=self.titlestr;
    self.titleLb.text=self.titlestr;
    self.tableview.tableFooterView=[UIView new];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"LBUserKonwViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBUserKonwViewTableViewCell"];
    
    [self loadData];//加载数据
}

-(void)loadData{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"index/index_alert" paramDic:@{@"type":self.indexType} finish:^(id responseObject) {
        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue] == 1) {
             
            self.dataDic = responseObject[@"data"];
            
            [self.tableview reloadData];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
    NSString *str=[NSString stringWithFormat:@"     %@",self.dataDic[@"content"]];
    CGRect sizeconent=[str boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return sizeconent.size.height;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBUserKonwViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBUserKonwViewTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataDic.count > 0) {
//        cell.contentLb.text;
        NSString *str = [NSString stringWithFormat:@"     %@",self.dataDic[@"content"]];
        
        cell.contentLb.text = str;
        
    }else{
      cell.contentLb.text = @"";
    }
    
    
    
    return cell;
    
    
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

/**
 *  字符串转富文本
 */
- (NSMutableAttributedString *)strToAttriWithStr:(NSString *)htmlStr{
    
    NSMutableAttributedString *AttributedString=[[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                             documentAttributes:nil
                                                                                          error:nil];
    
    [AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [AttributedString length])];//设置字体大小
    
    return AttributedString;
}

-(NSDictionary*)dataDic{
    
    if (!_dataDic) {
        _dataDic=[[NSDictionary alloc]init];
    }
    
    return _dataDic;
    
}

@end
