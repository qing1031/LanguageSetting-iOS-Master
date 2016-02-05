//
//  DealCacheController.m
//  Test
//
//  Created by zwh on 14-4-2.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

#import "DealCacheController.h"
#import "NSString+MD5.h"

#define ALLKEYS @"allKeys"  //所有数据的键

@implementation DealCacheController
/*
 *功能：将所有的数据都以NSData的方式存储到缓存中去
 *  data为文件数据
 *  oldkey为原始键，在后期要进行加密
 */
- (void)saveCache:(NSData *)data oldkey:(NSString *)oldKey{
    NSString *documentPath = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents"];//将Documents添加到sandbox路径上
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[oldKey MD5Hash],@".jpg"]];   // 保存文件的名称
   // NSLog(@"%@", filePath);
    
   // BOOL res = //[UIImagePNGRepresentation([UIImage imageWithData:data])writeToFile: filePath    atomically:YES];
    [UIImageJPEGRepresentation([UIImage imageWithData:data], 1.0) writeToFile:filePath options:NSAtomicWrite error:nil];
}

/*功能：获取缓存数据
 *  type缓存类型
 *  data如果是文本类型时，而且不存在缓存中时，可以将该数据放入到缓存中
 *  url这个参数，有两个用处：一个是如果kind是文本类型时作为key来使用，但如果是其他类型时是既作为key又作为文件下载的url
 *  down为保留参数
 */
- (NSData*)getCache:(NSString *)oldKey{
    NSString *documentPath = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents"];//将Documents添加到sandbox路径上
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[oldKey MD5Hash],@".jpg"]];
    //NSLog(@"%@", filePath);
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    NSData *value = UIImageJPEGRepresentation(img, 1);
    
    if (value)
        return value;
    return nil;
}

/**
 *功能：用于将图片从网上进行下载下来，而后进行存放于缓存中去
 *  urlString为下载图片的url
 */
- (void)dealImage:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if ([data length] != 1163)
        [self saveCache:data oldkey:urlString];
}
/**
 *功能：获取缓存中的图片数据，如果该图片数据没有的时候就进行从指定的地址中进行下载下来，然后进行返回去
 *@param url有两种作用，一个种是获取缓存中数据的键，一种是获取网上图片的地址
 *return 返回图片的NSData数据
 */
- (NSData*)getImageData:(NSString *)url{
   // NSString *newUrl = [[NSString alloc] initWithFormat:@"%@%@", [InitData Path], [url substringFromIndex:2]];
    NSData *data = [self getCache:url];
    if (nil == data){
        [self dealImage:url];
    }
    return [self getCache:url];
}

//通常用于删除缓存的时，计算缓存大小
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/1024.0;
}
- (float) getCacheLengh{
    NSString *documentPath = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents"];//将Documents添加到sandbox路径上
    
   // NSDictionary *file = [[NSFileManager defaultManager] attributesOfItemAtPath:documentPath error:nil];
    float ff = [self folderSizeAtPath:documentPath];
    //NSLog(@"length=%.2f", ff);
    return ff;
}



- (void)cleanCache
{
    NSString *documentPath = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents"];//将Documents添加到sandbox路径上
    
   // NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentPath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
       // NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
      //  if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
      //  {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        //}
    }
}

@end
 















