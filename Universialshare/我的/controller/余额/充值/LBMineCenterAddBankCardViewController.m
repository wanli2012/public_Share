//
//  LBMineCenterAddBankCardViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterAddBankCardViewController.h"

@interface LBMineCenterAddBankCardViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UITextField *codelb;

@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UITextField *yanzlb;
@property (weak, nonatomic) IBOutlet UIButton *yanzBt;

@property (weak, nonatomic) IBOutlet UIButton *surebutton;


@end

@implementation LBMineCenterAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"添加银行卡";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (IBAction)sendYanzM:(UIButton *)sender {
    
    
}

- (IBAction)sureEvent:(UIButton *)sender {
    
    if (self.retrunAddcard) {
        self.retrunAddcard();
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.codelb && [string isEqualToString:@"\n"]) {
        [self.yanzlb becomeFirstResponder];
        return NO;
    }
   else if (textField == self.yanzlb && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.contentH.constant = SCREEN_HEIGHT - 64;
    self.contentW.constant = SCREEN_WIDTH;
    
    self.yanzBt.layer.cornerRadius = 4;
    self.yanzBt.clipsToBounds =YES;
    
    self.surebutton.layer.cornerRadius = 4;
    self.surebutton.clipsToBounds =YES;


}

@end
