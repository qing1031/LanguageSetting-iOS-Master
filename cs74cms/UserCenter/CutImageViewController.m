//
//  CutImageViewController.m
//  cs74cms
//
//  Created by lyp on 15/5/9.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "CutImageViewController.h"
#import "CustomAlertView.h"

#define SHOW_PREVIEW NO

@interface CutImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, CustomAlertViewDelegate>

@end

@implementation CutImageViewController

@synthesize delegate;
@synthesize preview;
@synthesize imageCropper;

- (void) viewCannotBeSee{
    [self.myNavigationController setRightBtn:nil];
}
- (void) viewCanBeSee{
    [self.myNavigationController setTitle:MYLocalizedString(@"修剪照片", @"Trim photo")];
    
    UIButton *ok = [UIButton buttonWithType:UIButtonTypeCustom];
    [ok setImage:[UIImage imageNamed:@"OKBut.png"] forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(OKButClicked) forControlEvents:UIControlEventTouchUpInside];
    [ok setFrame:CGRectMake(0, 0, 40, 40)];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelButClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancel setFrame:CGRectMake(0, 0, 40, 40)];
    
    NSArray *array = [NSArray arrayWithObjects:ok, cancel, nil];
    if (self.myNavigationController != nil){
        [self.myNavigationController setRightBtn: array];
    }
}
- (void) OKButClicked{
    UIImage *img = [imageCropper getCroppedImage];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getCutImage:)]){
        [self.delegate getCutImage:img];
    }
    [self.myNavigationController dismissViewController];
}
- (void) cancelButClicked{
    [self.myNavigationController dismissViewController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCutImage:(UIImage*) img{
    self.imageCropper = [[BJImageCropper alloc] initWithImage:img andMaxSize:CGSizeMake(1024, 600)];
    [self.view addSubview:self.imageCropper];
    self.imageCropper.center = self.view.center;
    self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
    
    if (SHOW_PREVIEW) {
        self.preview = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,self.imageCropper.crop.size.width * 0.1, self.imageCropper.crop.size.height * 0.1)];
        self.preview.image = [self.imageCropper getCroppedImage];
        self.preview.clipsToBounds = YES;
        self.preview.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.preview.layer.borderWidth = 2.0;
        [self.view addSubview:self.preview];
    }
}

- (void) viewDidDisappear:(BOOL)animated{
    self.imageCropper = nil;
    self.preview = nil;
    [super viewDidDisappear:animated];
}

- (void)updateDisplay {

    
    if (SHOW_PREVIEW) {
        self.preview.image = [self.imageCropper getCroppedImage];
        self.preview.frame = CGRectMake(10,10,self.imageCropper.crop.size.width * 0.1, self.imageCropper.crop.size.height * 0.1);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        [self updateDisplay];
    }
}


#pragma mark - getPicture
- (void) getPicture{
    //在这里呼出下方菜单按钮项
    
    //我的菜单
    CustomAlertView *alertView = [[CustomAlertView alloc] init];
    NSArray * arr = [NSArray arrayWithObjects:MYLocalizedString(@"拍照", @"Photograph"), MYLocalizedString(@"从手机相册获取", @"Get from a mobile photo album"), nil];
    [alertView setDirection:Y andTitle:MYLocalizedString(@"修改简历头像", @"Modify the photot of resume") andMessage:nil andArray:arr];
    alertView.delegate = self;
    [self.view addSubview:alertView];
}
//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
       // picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        UIViewController *nav = (UIViewController*)self.myNavigationController;
        [nav presentViewController:picker animated:YES completion:nil];
        
    }
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
   // picker.allowsEditing = YES;
    UIViewController *nav = (UIViewController*)self.myNavigationController;
    [nav presentViewController:picker animated:YES completion:nil];
}


//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    /*  UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
     [imgBut setImage:img forState:UIControlStateNormal];
     [picker dismissViewControllerAnimated:YES completion:nil];
     */
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [picker dismissViewControllerAnimated:YES completion:nil];

        [self setCutImage:image];
        /*  NSData *data;
         if (UIImagePNGRepresentation(image) == nil)
         {
         data = UIImageJPEGRepresentation(image, 1.0);
         }
         else
         {
         data = UIImagePNGRepresentation(image);
         }
         
         
         //图片保存的路径
         //这里将图片放在沙盒的documents文件夹中
         NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
         
         
         //文件管理器
         NSFileManager *fileManager = [NSFileManager defaultManager];
         
         //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
         [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
         [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
         
         //得到选择后沙盒中图片的完整路径
         //NSString * filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
         
         //关闭相册界面
         [picker dismissViewControllerAnimated:YES completion:nil];
         //[self.myNavigationController dismissViewController];
         
         
         [imgBut setImage:image forState:UIControlStateNormal];*/
        
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) customAlertViewbuttonClicked:(int)index{
    
    //照片的返回函数
    switch (index) {
        case 0:
            [self takePhoto];
            break;
            
        default:
            [self LocalPhoto];
            break;
    }
}



@end
