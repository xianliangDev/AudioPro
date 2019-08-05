//
//  LCFileManager.m
//  ParentsCommunity
//
//  Created by lucid on 2018/9/10.
//  Copyright © 2018年 XES. All rights reserved.
//

#import "LCFileManager.h"

@implementation LCFileManager
#pragma mark == 获取路径
+ (NSString *)getDocumentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)getLibraryDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)getCachesDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)getPreferencePanesDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)getTmpDirectory{
    return NSTemporaryDirectory();
}


#pragma mark == 创建文件夹
+ (NSString *)createDocumentFilePath:(NSString *)path
{
    NSString *Path = nil;
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    Path = [documentPath stringByAppendingPathComponent:path];
    if (Path && ![[NSFileManager defaultManager] fileExistsAtPath:Path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return Path;
}

+ (NSString *)createTmpFilePath:(NSString *)path
{
    NSString *Path = nil;
    NSString *tmpPath = NSTemporaryDirectory();
    Path = [tmpPath stringByAppendingPathComponent:path];
    if (Path && ![[NSFileManager defaultManager] fileExistsAtPath:Path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return Path;
}

+ (NSString *)createCacheFilePath:(NSString *)path
{
    NSString *Path = nil;
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    Path = [cachePath stringByAppendingPathComponent:path];
    if (Path && ![[NSFileManager defaultManager] fileExistsAtPath:Path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return Path;
}

#pragma mark == 判断是否存在文件
+ (BOOL)fileExistsAtPath:(NSString *)path
{
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    
    BOOL exits = [manger fileExistsAtPath:path];
    return exits;
}


#pragma mark == 删除文件相关
+ (double)sizeWithFilePath:(NSString *)path{
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    // 3.判断是否为文件夹
    if (dir) {
        // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [manger subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            BOOL dir = NO;
            [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [manger attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1024 * 1024.0);
    } else { // 文件
        NSDictionary *attrs = [manger attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1024.0 * 1024.0);
    }
}

+ (NSArray *)getAllFileNames:(NSString *)dirPath{
    NSError *err;
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath error:&err];
    return files;
}

+ (BOOL)clearCachesWithFilePath:(NSString *)path{
    NSFileManager *mgr = [NSFileManager defaultManager];
    return [mgr removeItemAtPath:path error:nil];
}

+ (BOOL)clearCachesFromDirectoryPath:(NSString *)dirPath{
    //获得全部文件数组
    NSArray *fileAry =  [self getAllFileNames:dirPath];
    //遍历数组
    BOOL flag = NO;
    for (NSString *fileName in fileAry) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        flag = [self clearCachesWithFilePath:filePath];
        if (!flag)
            break;
    }
    return flag;
}
//获取当前时间
+ (NSString *)getCurrentTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    NSDate *datenow = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:datenow];
    return dateStr;
}
//#pragma mark =============== 素材文件夹的创建和路径获取 ===============
///** 创建素材文件夹路径 该文件夹下包括zip zip解压后的文件夹 片头片尾  素材id*/
//+ (NSString *)creatAllMediasFolderPathWithMediasId:(NSString *)mediasId{
//    return [LCFileManager createDocumentFilePath:[NSString stringWithFormat:@"%@/LCMediasFile_%@",kLCChineseGuideMediasFolder,mediasId]];
//}
//
//+ (NSString *)getAllMediasFolderPathWithMediasId:(NSString *)mediasId{
//    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *path = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@/LCMediasFile_%@",kLCChineseGuideMediasFolder,mediasId]];
//    return path;
//}
///** 该文件夹下主要是素材中的图片和音频 */
//+ (NSString *)getMediasFolderPathWithMediasId:(NSString *)mediasId{
//    NSString *allPath = [LCFileManager getAllMediasFolderPathWithMediasId:mediasId];
//    //注释的这两个方法都是深度遍历 返回所有子文件以及子文件夹里的文件
////    NSArray *arr = [LCFileManager getAllFileNames:allPath];
////    NSArray *arr = [[NSFileManager defaultManager] subpathsAtPath:allPath];
//    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:allPath error:nil];
//    NSString *resultName = @"";
//    for(NSString *filename in arr){
//        if ([filename containsString:[NSString stringWithFormat:@"package_%@_",mediasId]]) {
//            resultName = filename;
//        }
//    }
//    return [allPath stringByAppendingPathComponent:resultName];
//}
//#pragma mark =============== 我录制视频文件的存取 ===============
///** 创建录音文件缓存文件夹*/
//+ (NSString *)creatLCChineseGuideRecordFolder{
//    return [LCFileManager createCacheFilePath:[NSString stringWithFormat:@"%@",kLCChineseGuideRecordFolder]];
//}
///** 创建音视频文件缓存文件夹*/
//+ (NSString *)creatLCChineseGuideCompositionCacheFolder{
//    return [LCFileManager createCacheFilePath:[NSString stringWithFormat:@"%@",kLCChineseGuideCompositionCacheFolder]];
//}
///** 创建我的视频文件夹 以userid区分不同用户 */
//+ (NSString *)creatLCChineseGuideMyVideosFolder{
//    return [LCFileManager createDocumentFilePath:[NSString stringWithFormat:@"%@_%@",kLCChineseGuideMyVideosFolder,[MyUserInfoDefaults sharedDefaults].myUserEntity.userId]];
//}
///** 获取我的视频  */
//+ (NSString *)getLCChineseGuideMyVideoWithMediasId:(NSString *)mediasId{
//    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *str = [NSString stringWithFormat:@"/%@_%@/myVideo_%@",kLCChineseGuideMediasFolder,[MyUserInfoDefaults sharedDefaults].myUserEntity.userId,mediasId];
//    NSString *path = [documentPath stringByAppendingString:str];
//    return path;
//}
@end
