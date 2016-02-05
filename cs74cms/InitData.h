//
//  InitDataController.h
//  myFirstPro
//
//  Created by zwh on 14-3-26.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T_User.h"
#import "Reachability.h"

@protocol UpDataDelegate <NSObject>

- (void)UpData;//用于通知需要网络数据的页面

@end

typedef enum {X, Y} Direction;

@interface InitData : NSObject{
    //网络
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
}
//用于网络
@property (nonatomic, retain) id<UpDataDelegate> netDelegate;

//返回下载图片的路径
+ (NSString*) Path;
+ (NSString*) HomeDBPath;
+ (void) setAppleDownLoadPath:(NSString*) path;
+ (NSString*) getAppleDownLoadPath;
+ (void) setAndroidDownLoadPath: (NSString*) path;
+ (NSString*) getAndroidDownLoadPath;

// 获取当前设备可用内存(单位：MB）
+ (double)availableMemory;
// 获取当前任务所占用的内存（单位：MB）
+ (double)usedMemory;

//存在网络
+(BOOL)NetIsExit;

//常用用户信息
+ (T_User*) getUser;
+ (T_User*) setUser:(T_User*) tuser;

//正在编辑的简历
+ (int) setPid:(int) t;
+ (int) getPid;

+(double)AllWidth;
+(double)AllHeight;

//状态栏的高度
+ (double) StateBarHeight;

//导航栏的高度
+ (double) NavControllerHeight;
+ (double) NavControllerY;
+ (double) NavBarHight;

//可操作的区域
+ (CGPoint) Origin;
+ (double) Width;
+ (double) Height;

//底部标签栏的大小
+ (double) TabBarY;
+ (double) TabBarHeight;
+ (double) TabBarDown;

//子菜单的大小
+ (double) SubMenuViewX;
+ (double) SubMenuViewY;
+ (double) SubMenuViewCellHeight;
+ (double) SubMenuViewWidth;
+ (double) SubMenuAnimateTime;

//样片界面
+ (double) ThemeImageHeight;

//计算图片
+ (CGSize) calculateImageSize:(CGSize)size imageSize:(CGSize)imageSize priorDirection:(Direction) dir;

//网络警告
//+(void) netAlert;

//判断是否全是数字
+ (BOOL) judgeInt:(NSString*) str;
//判断是否是字母
+ (BOOL) stringIsalnum:(NSString*) str;
//判断是否是手机号
+(BOOL) stringIsPhoneNumber:(NSString*) str;
//判断是否是邮箱
+ (BOOL) stringIsEmail:(NSString*) str;


//初始化数据
- (void) initData;

//销毁内存
+ (void) distory:(UIView *) view;

+ (void)netAlert:(NSString*)message;

//获取皮肤颜色
+ (UIColor*) getSkinColor;


//日期格式转换
+ (NSDate*) dateFromString:(NSString*) str;
+ (NSString*) stringFromDate:(NSDate*) date;
//时间戳变成时间
+ (NSDate*) dateFromNum:(NSString*) str;


//正在加载
+ (void) isLoading:(UIView*) superview;
+ (void) haveLoaded:(UIView *) superview;


//使uibable 中的文字左右对齐;
+ (NSMutableAttributedString*) getMutableAttributedStringWithString:(NSString*) str;
@end
