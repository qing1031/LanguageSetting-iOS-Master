//
//  CompanyCenterViewController.m
//  74cms
//
//  Created by lyp on 15/5/5.
//  Copyright (c) 2015年 XunYi Science and Technology Co.,Ltd. All rights reserved.
//

#import "CompanyCenterViewController.h"
#import "InitData.h"
#import "ManageViewController.h"
#import "EditCompanyViewController.h"
#import "PublishViewController.h"
#import "ITF_Company.h"
#import "FindResumeViewController.h"
#import "ColloctionViewController.h"
#import "AuthenticationViewController.h"
#import "ChangePasswordViewController.h"
#import "CutImageViewController.h"
#import "DealCacheController.h"
#import "SearchResumeViewController.h"

@interface CompanyCenterViewController ()<cutImageDelegate>{
    UIButton *logoBut;
    UIColor *textcolor;
    float height;
    T_Company *company;
    T_CompanyCenter *companyCenter;
    
    UIView *topView;
    NSMutableArray *subMenuArray;
}

@end

@implementation CompanyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

}
- (void) viewCanBeSee{

     /*   [InitData isLoading:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //后台代码
            T_User *user = [InitData getUser];
            
            if (user.profile)//为0 为没有完善
                company = [[[ITF_Company alloc] init] companyProfileByUser:user andCompany:nil];

            
            //后台完成后，到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [InitData haveLoaded:self.view];
                if ([[self.view subviews] count]== 0)
                    [self drawView];
             //   else
                  //  [self changeInfo];
            });
        });*/
    if ([[self.view subviews] count] == 0)
        [self drawView];
    [self getCompanyCenterInfo];
    [self.myNavigationController setTitle:MYLocalizedString(@"企业中心", @"Enterprise center")];
}
- (void) viewCannotBeSee{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawView{
    
    [self topView];

    [self next];
    [self content];
}

- (void) downLoadPic{
    //不可从主线程取值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        NSString *str = [InitData getUser].logo;
        NSData *data;
        if (str != nil)
           data = [[[DealCacheController alloc] init] getImageData:str];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (str != nil && data != nil){
                UIImage *img = [UIImage imageWithData:data];
               // CGSize size = [InitData calculateImageSize:logoBut.frame.size imageSize:img.size priorDirection:Y];
               // [logoBut setFrame:CGRectMake(logoBut.frame.origin.x, logoBut.frame.origin.y, size.width, size.height)];
                [logoBut setImage:img forState:UIControlStateNormal];
            }
        });
    });
}

- (void) topView{
    textcolor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [InitData Width], 133)];
    [self.view addSubview:topView];
    
    logoBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoBut setFrame:CGRectMake(20, 15, 95, 95)];
    [logoBut setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [logoBut addTarget:self action:@selector(logoButClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:logoBut];
    [self downLoadPic];

    
   // NSString * str = company.companyname;
  //  CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([InitData Width] - 130 - 15, 15)];
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 15, 0, 15)];
    textField.font = [UIFont systemFontOfSize:15] ;
    textField.textColor = [UIColor colorWithRed:53./255 green:53./255 blue:53./255 alpha:1];
    textField.placeholder = MYLocalizedString(@"请输入公司名称", @"Please enter company name");
  //  textField.text = str;
  //  textField.delegate = self;
    textField.userInteractionEnabled = NO;
    [topView addSubview:textField];
    
    //编辑按钮
    UIButton* editBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBut setImage:[UIImage imageNamed:@"edit.jpg"] forState:UIControlStateNormal];
    [editBut addTarget:self action:@selector(editButClicked) forControlEvents:UIControlEventTouchUpInside];
    [editBut setFrame:CGRectMake(130, 15, 20, 20)];
    [topView addSubview:editBut];
    
    height = 45;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130, height, 40, 15)];
    label.textColor = textcolor;
    label.font = [UIFont systemFontOfSize:12];
    label.text = MYLocalizedString(@"性质：", @"Nature:");
    [topView addSubview:label];
    
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(165, height, 100, 15)];
    textlabel.font = label.font;
    textlabel.textColor = textcolor;
    textlabel.text = MYLocalizedString(@"股份制企业", @"Joint stock enterprise");
    [topView addSubview:textlabel];
    if (company.nature_cn != nil)
        textlabel.text = company.nature_cn;
    height += 20;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(130, height, 40, 15)];
    label2.textColor = textcolor;
    label2.font = label.font;
    label2.text = MYLocalizedString(@"规模：", @"Scale:");
    [topView addSubview:label2];
    
    UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(165, height, 100, 15)];
    textlabel2.font = label.font;
    textlabel2.textColor = textcolor;
    textlabel2.text = MYLocalizedString(@"20-99人", @"20-99 person");
    [topView addSubview:textlabel2];
    if (company.scale_cn!= nil)
        textlabel2.text = company.scale_cn;
    height += 20;

    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(130, height, 40, 15)];
    label3.textColor = textcolor;
    label3.font = label.font;
    label3.text = MYLocalizedString(@"行业：", @"Industry:");
    [topView addSubview:label3];
    
    UILabel *textlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(165, height, 140, 15)];
    textlabel3.font = label.font;
    textlabel3.textColor = textcolor;
    textlabel3.text = MYLocalizedString(@"计算机软件", @"Computer software");
    [topView addSubview:textlabel3];
    if (company.trade_cn != nil)
        textlabel3.text = company.trade_cn;
    height += 20;

    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(130, height, 40, 15)];
    label4.textColor = textcolor;
    label4.font = label.font;
    label4.text = MYLocalizedString(@"地址：", @"Adress:");
    [topView addSubview:label4];
    
    UILabel *textlabel4 = [[UILabel alloc] initWithFrame:CGRectMake(165, height, 140, 15)];
    textlabel4.font = label.font;
    textlabel4.textColor = textcolor;
    textlabel4.text = MYLocalizedString(@"北京市朝阳区太阳宫中路", @"Chaoyang District, Beijing Sun Palace Road");
    [topView addSubview:textlabel4];
    if (company.address != nil)
        textlabel4.text = company.address;
    height += 28;
}
- (void) next{
    height = 133;
    NSArray *arr = [NSArray arrayWithObjects:@"zhaopin.png", @"guanli.png", @"sousuo.png", nil];
    NSArray * arr2 =[NSArray arrayWithObjects:MYLocalizedString(@"发布职位", @"Release position"), MYLocalizedString(@"管理职位", @"Manage position"), MYLocalizedString(@"搜索简历", @"Search resume"), nil];
    float cellHeight = 50;
    float sep =  45;
    float left = ([InitData Width] - cellHeight * 3 - sep * 2) / 2;
    for (int i=0; i<3; i++) {
        UIButton *but = [UIButton buttonWithType: UIButtonTypeCustom];
        but.tag = i + 1;
        [but setFrame:CGRectMake(left, height, cellHeight, cellHeight)];
        [but setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(menuSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(left - cellHeight / 3, height + cellHeight + 10, cellHeight / 3 * 5, 15)];
        label.textColor = [UIColor colorWithRed:102./255 green:102./255 blue:102./255 alpha:1];
        label.text = [arr2 objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:label];
        
        left += sep + cellHeight;
    }
    height += cellHeight + 37;
}
- (void) content{
    float cellHeight = ([InitData Height] - height - 10) / 7;
    NSArray *arr = [NSArray arrayWithObjects:MYLocalizedString(@"应聘简历", @"Apply for resume"), MYLocalizedString(@"已下载的简历", @"Downloaded resume"),MYLocalizedString(@"发起的面试邀请", @"Interview invitation"), MYLocalizedString(@"收藏的简历", @"A collection of resumes"),  MYLocalizedString(@"手机认证", @"Mobile phone authentication"), MYLocalizedString(@"修改密码", @"Modify password"), MYLocalizedString(@"退出登录", @"Exit login"), nil];
    for (int i=0; i<[arr count]; i++){
        if (i == 0 || i == 4){
            UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], 5)];
            [tview setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
            [self.view addSubview:tview];
            height += 5;
        }
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(15, height - 1, [InitData Width] - 30, 1)];
        [sep  setBackgroundColor:[UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1]];
        [self.view addSubview:sep];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, [InitData Width], cellHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.tag = i + 1;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedThis:)];
        recognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:recognizer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, height, 200, cellHeight)];
        label.textColor = textcolor;
        label.font = [UIFont systemFontOfSize:15];
        label.text = [arr objectAtIndex:i];
        [self.view addSubview:label];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake([InitData Width] - 40, height + (cellHeight - 25) / 2, 20, 25)];
        imgView.image = [UIImage imageNamed:@"go.png"];
        [self.view addSubview:imgView];
        if (i < 4){
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 40, cellHeight / 3 - 2, 0, cellHeight / 3 + 5)];
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.layer.cornerRadius = 7;
            numberLabel.layer.masksToBounds = YES;
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.layer.borderColor = [[UIColor colorWithRed:236.0 / 255 green:72.0 / 255 blue:72.0 / 255 alpha:1] CGColor];
            numberLabel.layer.borderWidth = 1;
            [numberLabel setBackgroundColor:[UIColor colorWithRed:236.0 / 255 green:72.0 / 255 blue:72.0 / 255 alpha:1]];
            [view addSubview:numberLabel];
            if (subMenuArray == nil)
                subMenuArray = [[NSMutableArray alloc] initWithCapacity:5];
            [subMenuArray addObject:numberLabel];
        }
        if (i == 4){
            UILabel * authenLabel = [[UILabel alloc] initWithFrame:CGRectMake([InitData Width] - 130 - 40, 0, 130, view.frame.size.height)];
            authenLabel.textColor = [UIColor colorWithRed:228.0 / 255 green:48.0 / 255 blue:56.0 / 355 alpha:1];
            authenLabel.font = [UIFont systemFontOfSize:14];
            authenLabel.textAlignment = NSTextAlignmentRight;
            authenLabel.text = @"";
            [view addSubview:authenLabel];
            [subMenuArray addObject:authenLabel];
        }
        
        height += cellHeight;
    }
}

- (void) getCompanyCenterInfo{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user =[InitData getUser];
        
        
        T_CompanyCenter *data = [[[ITF_Company alloc] init] getCompanyCenterInfoByUser:user];
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (data != nil && data.profile == NO){
                [self.myNavigationController popAndPushViewController:[[EditCompanyViewController alloc] init]];
                return ;
            }
            if (data.mobileAudit == 0){
                UILabel *numberLabel = [subMenuArray objectAtIndex:4];
                numberLabel.text = MYLocalizedString(@"未认证手机", @"Not certified mobile phone");
            }
            else{
                UILabel *numberLabel = [subMenuArray objectAtIndex:4];
                numberLabel.text = MYLocalizedString(@"手机已认证", @"Mobile phone has been certified");
            }
            
            if (data.comeResume > 0){
                UILabel *label = [subMenuArray objectAtIndex:0];
                NSString *str = [NSString stringWithFormat:@"%d", data.comeResume];
                CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(100, 25)];
                [label setFrame:CGRectMake([InitData Width] - 40 - size.width - 15 ,label.frame.origin.y, size.width + 15, label.frame.size.height)];
                label.text =str;
            }
            else{
                UILabel *label = [subMenuArray objectAtIndex:0];
                [label setFrame:CGRectMake([InitData Width] - 40 ,label.frame.origin.y, 0, label.frame.size.height)];
            }
            if (data.downResume > 0){
                UILabel *label = [subMenuArray objectAtIndex:1];
                NSString *str = [NSString stringWithFormat:@"%d", data.downResume];
                CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(100, 25)];
                [label setFrame:CGRectMake([InitData Width] - 40 - size.width - 15 ,label.frame.origin.y, size.width + 15, label.frame.size.height)];
                label.text =str;
            }
            else{
                UILabel *label = [subMenuArray objectAtIndex:1];
                [label setFrame:CGRectMake([InitData Width] - 40 ,label.frame.origin.y, 0, label.frame.size.height)];
            }
            if (data.interResume > 0){
                UILabel *label = [subMenuArray objectAtIndex:2];
                NSString *str = [NSString stringWithFormat:@"%d", data.interResume];
                CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(100, 25)];
                [label setFrame:CGRectMake([InitData Width] - 40 - size.width - 15 ,label.frame.origin.y, size.width + 15, label.frame.size.height)];
                label.text =str;
            }
            else{
                UILabel *label = [subMenuArray objectAtIndex:2];
                [label setFrame:CGRectMake([InitData Width] - 40,label.frame.origin.y,0, label.frame.size.height)];
            }
            if (data.favResume > 0){
                UILabel *label = [subMenuArray objectAtIndex:3];
                NSString *str = [NSString stringWithFormat:@"%d", data.favResume];
                CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(100, 25)];
                [label setFrame:CGRectMake([InitData Width] - 40 - size.width - 15 ,label.frame.origin.y, size.width + 15, label.frame.size.height)];
                label.text =str;
            }
            else{
                UILabel *label = [subMenuArray objectAtIndex:3];
                [label setFrame:CGRectMake([InitData Width] - 40 ,label.frame.origin.y, 0, label.frame.size.height)];
            }
            
            NSString * str = data.companyName;
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([InitData Width] - 130 - 15, 15)];
            UITextField* textField = [[topView subviews] objectAtIndex:1];
            [textField setFrame:CGRectMake(130, 15, size.width, 15)];
            textField.text = str;
            //编辑按钮
            UIButton* editBut = [[topView subviews] objectAtIndex:2];
            [editBut setFrame:CGRectMake(130 + size.width, 15, 20, 20)];
            
            
            UILabel *label1 = [[topView subviews] objectAtIndex:4];
            label1.text = data.natureCn;
            
            UILabel *label2 = [[topView subviews] objectAtIndex:6];
            label2.text = data.scaleCn;
            
            UILabel *label3 = [[topView subviews] objectAtIndex:8];
            label3.text = data.tradeCn;
            
            UILabel *label4 = [[topView subviews] objectAtIndex:10];
            label4.text = data.address;
        });
    });
}

- (void) getAddMode{
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        int mode = [[[ITF_Company alloc] init] companyAddJobsByUser:user andAddJob:nil];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            if (mode > 0){
                PublishViewController *pub = [[PublishViewController alloc] init];
                [pub setMode:mode];
                [self.myNavigationController pushAndDisplayViewController: pub];
            }
         /*   else if([InitData NetIsExit]){
                [InitData netAlert:@"您的积分不足，请充值后再发"];
            }*/

        });
    });
}



- (void) menuSelected:(UIButton*) but{
    long index = but.tag;
    switch (index) {
        case 1:
            [self getAddMode];
            break;
        case 2:
            [self.myNavigationController pushAndDisplayViewController:[[ManageViewController alloc] init]];
            break;
        case 3:{
           // FindResumeViewController *search = [[FindResumeViewController alloc] init];
           // [search setType:0];
           // [self.myNavigationController pushAndDisplayViewController:search];
            SearchResumeViewController *search = [[SearchResumeViewController alloc] init];
            [self.myNavigationController pushAndDisplayViewController:search];
        }
            break;
            
        default:
            break;
    }
}

- (void) selectedThis:(UITapGestureRecognizer*) recognizer{
    long index = recognizer.view.tag - 1;
    switch (index) {
        case 0:{
            FindResumeViewController *find = [[FindResumeViewController alloc] init];
            [find setType:1];
            [self.myNavigationController pushAndDisplayViewController:find];
        }
            break;
        case 1:{
            ColloctionViewController *colle = [[ColloctionViewController alloc] init];
            [colle setType:5 andPid:0];
            [self.myNavigationController pushAndDisplayViewController: colle];
        }
            break;
        case 2:{
            ColloctionViewController *colle = [[ColloctionViewController alloc] init];
            [colle setType:6 andPid:0];
            [self.myNavigationController pushAndDisplayViewController: colle];
        }
            break;
        case 3:{
            ColloctionViewController *colle = [[ColloctionViewController alloc] init];
            [colle setType:7 andPid:0];
            [self.myNavigationController pushAndDisplayViewController: colle];
        }
            break;
        case 4:{
            AuthenticationViewController *auth = [[AuthenticationViewController alloc] init];
            [auth setType:1];
            [self.myNavigationController pushAndDisplayViewController:auth];
        }
            break;
        case 5:{
            ChangePasswordViewController *change = [[ChangePasswordViewController alloc] init];
            [change setType:1];
            [self.myNavigationController pushAndDisplayViewController:change];
        }
            break;
        case 6:{
            T_User *user = [InitData getUser];
            if ([[[ITF_Company alloc] init] loginOutByUsername:user.username andPassword:user.userpwd]) {
                [InitData setUser:nil];
                [self.myNavigationController dismissViewController];
            }
        }
            break;
        default:
            break;
    }
}
/*
- (void) spaceClicked{
    [textField resignFirstResponder];
    
    textField.borderStyle = UITextBorderStyleNone;
    CGSize size = CGSizeMake(100, 15);
    if ([textField.text respondsToSelector:@selector(sizeWithFont:forWidth:lineBreakMode:)]){
        size = [textField.text sizeWithFont:textField.font constrainedToSize:CGSizeMake([InitData Width] - 145, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    float x = textField.frame.origin.x;
    float y = textField.frame.origin.y;
    float theight = textField.frame.size.height;
    float width = textField.frame.size.width;
    if (textField.userInteractionEnabled == YES){
        textField.frame = CGRectMake(x, y, size.width, theight);
        
        [editBut setFrame:CGRectMake(editBut.frame.origin.x + (size.width - width), editBut.frame.origin.y, editBut.frame.size.width, editBut.frame.size.height)];
        
    }
    textField.userInteractionEnabled = NO;
}*/
-(void) editButClicked{
    EditCompanyViewController *edit = [[EditCompanyViewController alloc] init];
    [self.myNavigationController pushAndDisplayViewController:edit];
    [edit setEditable:companyCenter.audit == 0];
  /*  if (textField.userInteractionEnabled == YES){
        [self spaceClicked];
        return;
    }
    textField.userInteractionEnabled = YES;
    
    float x = textField.frame.origin.x;
    float y = textField.frame.origin.y;
    float theight = textField.frame.size.height;
    float width = textField.frame.size.width;
    if (textField.userInteractionEnabled == YES){
        textField.frame = CGRectMake(x, y, 100, theight);
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        [editBut setFrame:CGRectMake(editBut.frame.origin.x + (100 - width), editBut.frame.origin.y, editBut.frame.size.width, editBut.frame.size.height)];
    }*/
}
/*
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self spaceClicked];
    return YES;
}*/


#pragma mark getPic
- (void) logoButClick{
    CutImageViewController *cut = [[CutImageViewController alloc] init];
    [cut getPicture];
    cut.delegate = self;
    [self.myNavigationController pushAndDisplayViewController:cut];
}


#pragma mark delegate
- (void) getCutImage:(UIImage *)img{
    if (img == nil)
        return;
   // CGSize size = [InitData calculateImageSize:logoBut.frame.size imageSize:img.size priorDirection:Y];
   // [logoBut setFrame:CGRectMake(logoBut.frame.origin.y, logoBut.frame.origin.y, size.width, size.height)];
    [logoBut setImage:img forState:UIControlStateNormal];
    
    
    //传值
    [InitData isLoading:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //后台代码
        T_User *user = [InitData getUser];
        NSString *str = [[[ITF_Company alloc] init] companyPhotoByUsername:user.username andUserpwd:user.userpwd andUploadefile:img];
        
        //后台完成后，到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [InitData haveLoaded:self.view];
            [InitData netAlert:str];
            
        });
    });
    
}

@end
