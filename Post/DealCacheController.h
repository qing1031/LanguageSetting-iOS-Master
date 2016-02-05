//
//  DealCacheController.h
//  Test
//
//  Created by zwh on 14-4-2.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

#import <Foundation/Foundation.h>

//保存图片信息
@interface DealCacheController : NSObject

//对内存管理
/**
 *功能：保存数据到缓存中
 *@param data数据
 *@oldkey 保存的键
 */
- (void) saveCache:(NSData*)data oldkey:(NSString*)oldKey;
/**
 *功能：获取指定键的缓存
 *@param keys键值
 *@return 对应键的值
 */
- (NSData*)getCache:(NSString*)oldKey;
/**
 *功能：图片的处理：图片的下载
 *@param urlString图片的url路径
 */
- (void)dealImage:(NSString *)urlString;
/**
 *功能：获取缓存中的图片数据，如果该图片数据没有的时候就进行从指定的地址中进行下载下来，然后进行返回去
 *@param url有两种作用，一个种是获取缓存中数据的键，一种是获取网上图片的地址
 *return 返回图片的NSData数据
 */
- (NSData*)getImageData:(NSString*)url;


- (float) getCacheLengh;
- (void)cleanCache;

@end
