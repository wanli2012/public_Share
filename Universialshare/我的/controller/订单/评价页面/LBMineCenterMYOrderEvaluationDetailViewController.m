//
//  LBMineCenterMYOrderEvaluationDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/7.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMYOrderEvaluationDetailViewController.h"
#import <Masonry/Masonry.h>
#import "LBMyOrderEvaluationSucessViewController.h"

@interface LBMineCenterMYOrderEvaluationDetailViewController ()<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picviewH;

@property (weak, nonatomic) IBOutlet UIImageView *productImage;


@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *imahe3;
@property (weak, nonatomic) IBOutlet UIImageView *imag4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;

@property (weak, nonatomic) IBOutlet UILabel *palceHolder;

@property (weak, nonatomic) IBOutlet UITextView *textview;

@property (weak, nonatomic) IBOutlet UIButton *hideNameBt;

@property (weak, nonatomic) IBOutlet UIView *pictureView;


@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UIImageView *image8;
@property (weak, nonatomic) IBOutlet UIImageView *image9;
@property (weak, nonatomic) IBOutlet UIImageView *image10;
@property (weak, nonatomic) IBOutlet UIImageView *image11;
@property (weak, nonatomic) IBOutlet UIImageView *image12;
@property (weak, nonatomic) IBOutlet UIImageView *image13;
@property (weak, nonatomic) IBOutlet UIImageView *image14;
@property (weak, nonatomic) IBOutlet UIImageView *image15;
@property (weak, nonatomic) IBOutlet UIImageView *image16;
@property (weak, nonatomic) IBOutlet UIImageView *image17;
@property (weak, nonatomic) IBOutlet UIImageView *image18;
@property (weak, nonatomic) IBOutlet UIImageView *image19;
@property (weak, nonatomic) IBOutlet UIImageView *image20;
@property (weak, nonatomic) IBOutlet UIImageView *image21;
@property (weak, nonatomic) IBOutlet UIImageView *image22;
@property (weak, nonatomic) IBOutlet UIImageView *image23;
@property (weak, nonatomic) IBOutlet UIImageView *image24;
@property (weak, nonatomic) IBOutlet UIImageView *image25;

@property (strong, nonatomic)NSMutableArray *arrpic;


@end

@implementation LBMineCenterMYOrderEvaluationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"评价订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _arrpic = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"XRPlaceholder"], nil];
    
    
    [self Relayoutinterface];
    
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(subcommitEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = ba;
    
    
}
//提交
-(void)subcommitEvent:(UIButton*)sender{

    self.hidesBottomBarWhenPushed = YES;
    LBMyOrderEvaluationSucessViewController *vc=[[LBMyOrderEvaluationSucessViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
//选择图片然后重新布局
-(void)Relayoutinterface{
    if (self.pictureView.subviews > 0) {
       [self.pictureView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int i =0 ; i< _arrpic.count; i++) {
        
        int v = i / 3;
        int h = i % 3;
        UIImageView *imagev=[[UIImageView alloc]init];
        UIButton *button=[[UIButton alloc]init];
        button.backgroundColor=[UIColor redColor];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        imagev.tag = 10 + i;
        button.tag = 100 + i;
        button.hidden = YES;
        [button addTarget:self action:@selector(removeimage:) forControlEvents:UIControlEventTouchUpInside];
        imagev.userInteractionEnabled = YES;
        imagev.image = _arrpic[i];
        imagev.frame = CGRectMake(10 + 70 * h, 10 + 70 * v, 60, 60);
        [self.pictureView addSubview:imagev];
        if (i == _arrpic.count - 1) {
            UITapGestureRecognizer *tappicture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePictures)];
            [imagev addGestureRecognizer:tappicture];
        }else{
            UILongPressGestureRecognizer *longesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longgesture:)];
            UITapGestureRecognizer *tappicture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesturePicture:)];
            [imagev addGestureRecognizer:longesture];
             [imagev addGestureRecognizer:tappicture];
            
            [imagev addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.trailing.equalTo(imagev).offset(5);
                make.top.equalTo(imagev).offset(-5);
                make.width.equalTo(@20);
                make.height.equalTo(@20);
                
            }];
        
        }
        
    
    }
    
    if (_arrpic.count == 4 ||_arrpic.count == 5 ||_arrpic.count == 6) {
        self.picviewH.constant = 80 + 80;
        self.contentH.constant = 580 + 80;
    }else if (_arrpic.count == 7){
    
        self.picviewH.constant = 80 + 80 * 2;
        self.contentH.constant = 580 + 80 * 2;
        
    }else if (_arrpic.count == 0 || _arrpic.count == 1 ||_arrpic.count == 2 || _arrpic.count == 3){
        
        self.picviewH.constant = 80 ;
        self.contentH.constant = 580 ;
        
    }
}

-(void)removeimage:(UIButton*)sender{

    [_arrpic removeObjectAtIndex:sender.tag - 100];

    [self Relayoutinterface];

}
//长按
-(void)longgesture:(UILongPressGestureRecognizer *)longPress{

    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIImageView *imagev=(UIImageView*)longPress.view;
        UIButton *button = [self.view viewWithTag:imagev.tag + 90];
        button.hidden = NO;

        
    }
}
//单击图片
-(void)tapgesturePicture:(UITapGestureRecognizer*)gesture{

     UIImageView *imagev=(UIImageView*)gesture.view;
     UIButton *button = [self.view viewWithTag:imagev.tag + 90];
     button.hidden = YES;

}

-(void)takePictures{

    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self getpicture];//获取相册
        }break;
            
        case 1:{
            [self getcamera];//获取照相机
        }break;
        default:
            break;
    }
}

-(void)getpicture{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //    // 设置选择后的图片可以被编辑
    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    picker.allowsEditing = YES;
    //6.推送
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)getcamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可以被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.1);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.1);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        if (_arrpic.count >= 7) {
            return;
        }else{
          [_arrpic insertObject:[UIImage imageWithData:data] atIndex:0];
        }
       
        
        [self Relayoutinterface];
        
    }
}


- (IBAction)hideNameEvent:(UIButton *)sender {
    
    sender.selected = sender.selected;
    
    
}


- (IBAction)image6:(UITapGestureRecognizer *)sender {
    
    if (self.image6.image) {
        self.image6.image = [UIImage imageNamed:@""];
    }else{
        self.image6.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
    
}
- (IBAction)image7:(UITapGestureRecognizer *)sender {
    
    if (self.image7.image) {
        self.image7.image = [UIImage imageNamed:@""];
    }else{
        self.image7.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image8:(UITapGestureRecognizer *)sender {
    
    if (self.image8.image) {
        self.image8.image = [UIImage imageNamed:@""];
    }else{
        self.image8.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}
- (IBAction)image9:(UITapGestureRecognizer *)sender {
    
    if (self.image9.image) {
        self.image9.image = [UIImage imageNamed:@""];
    }else{
        self.image9.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image10:(UITapGestureRecognizer *)sender {
    
    if (self.image10.image) {
        self.image10.image = [UIImage imageNamed:@""];
    }else{
        self.image10.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}
- (IBAction)image11:(UITapGestureRecognizer *)sender {
    
    if (self.image11.image) {
        self.image11.image = [UIImage imageNamed:@""];
    }else{
        self.image11.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image12:(UITapGestureRecognizer *)sender {
    
    if (self.image12.image) {
        self.image12.image = [UIImage imageNamed:@""];
    }else{
        self.image12.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image13:(UITapGestureRecognizer *)sender {
    
    if (self.image13.image) {
        self.image13.image = [UIImage imageNamed:@""];
    }else{
        self.image13.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image14:(UITapGestureRecognizer *)sender {
    
    if (self.image14.image) {
        self.image14.image = [UIImage imageNamed:@""];
    }else{
        self.image14.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image15:(UITapGestureRecognizer *)sender {
    if (self.image15.image) {
        self.image15.image = [UIImage imageNamed:@""];
    }else{
        self.image15.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}
- (IBAction)image16:(UITapGestureRecognizer *)sender {
    
    if (self.image16.image) {
        self.image16.image = [UIImage imageNamed:@""];
    }else{
        self.image16.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image17:(UITapGestureRecognizer *)sender {
    
    if (self.image17.image) {
        self.image17.image = [UIImage imageNamed:@""];
    }else{
        self.image17.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)imag18:(UITapGestureRecognizer *)sender {
    
    if (self.image18.image) {
        self.image18.image = [UIImage imageNamed:@""];
    }else{
        self.image18.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image19:(UITapGestureRecognizer *)sender {
    
    if (self.image19.image) {
        self.image19.image = [UIImage imageNamed:@""];
    }else{
        self.image19.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image20:(UITapGestureRecognizer *)sender {
    
    if (self.image20.image) {
        self.image20.image = [UIImage imageNamed:@""];
    }else{
        self.image20.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image21:(UITapGestureRecognizer *)sender {
    
    if (self.image21.image) {
        self.image21.image = [UIImage imageNamed:@""];
    }else{
        self.image21.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image22:(UITapGestureRecognizer *)sender {
    
    if (self.image22.image) {
        self.image22.image = [UIImage imageNamed:@""];
    }else{
        self.image22.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}
- (IBAction)iamge23:(UITapGestureRecognizer *)sender {
    
    if (self.image23.image) {
        self.image23.image = [UIImage imageNamed:@""];
    }else{
        self.image23.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}
- (IBAction)image24:(UITapGestureRecognizer *)sender {
    
    if (self.image24.image) {
        self.image24.image = [UIImage imageNamed:@""];
    }else{
        self.image24.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}

- (IBAction)image25:(UITapGestureRecognizer *)sender {
    
    if (self.image25.image) {
        self.image25.image = [UIImage imageNamed:@""];
    }else{
        self.image25.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
}




-(void)textViewDidBeginEditing:(UITextView *)textView{

    self.palceHolder.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{

    if (textView.text.length <= 0) {
        self.palceHolder.hidden = NO;
    }

}

-(void)updateViewConstraints{

    [super updateViewConstraints];
    
    self.contentH.constant = 580;
    self.contentW.constant = SCREEN_WIDTH;

}



@end
