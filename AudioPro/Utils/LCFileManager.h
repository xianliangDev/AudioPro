//
//  LCFileManager.h
//  ParentsCommunity
//
//  Created by lucid on 2018/9/10.
//  Copyright © 2018年 XES. All rights reserved.
//

#import <Foundation/Foundation.h>
//素材zip文件夹 zip文件命名=时间戳 cache
//#define kLCChineseGuideZipsFolder  @"LCChineseGuideZipCache"
//素材文件夹 该文件夹下包括各个素材id对应的素材文件夹LCMediasFile_id（该文件夹下有zip、zip的解压后文件夹、片头片尾）  document
#define kLCChineseGuideMediasFolder  @"LCChineseGuideMediasFile"
//录音文件夹 文件命名=tmp_时间戳 cache
#define kLCChineseGuideRecordFolder  @"LCChineseGuideRecord"
//合成缓存文件夹 文件命名=tmp_时间戳 cache
#define kLCChineseGuideCompositionCacheFolder  @"LCChineseGuideCompositionCache"
//合成的视频文件夹LCChineseGuideMyVideos_userid 该文件夹下是用户不同景点的视频myVideo_素材id  document
#define kLCChineseGuideMyVideosFolder  @"LCChineseGuideMyVideos"
@interface LCFileManager : NSObject
/** 获取沙盒Document的文件目录 */
+ (NSString *)getDocumentDirectory;

/** 获取沙盒Library的文件目录 */
+ (NSString *)getLibraryDirectory;

/** 获取沙盒Library/Caches的文件目录 */
+ (NSString *)getCachesDirectory;

/** 获取沙盒Preference的文件目录 */
+ (NSString *)getPreferencePanesDirectory;

/** 获取沙盒tmp的文件目录 */
+ (NSString *)getTmpDirectory;

/** 创建目录 path 路径 */
+ (NSString *)createDocumentFilePath:(NSString *)path;
+ (NSString *)createTmpFilePath:(NSString *)path;
+ (NSString *)createCacheFilePath:(NSString *)path;

/** 判断文件是否存在 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

/** 根据路径返回目录或文件的大小 */
+ (double)sizeWithFilePath:(NSString *)path;

/** 得到指定目录下的所有文件名 */
+ (NSArray *)getAllFileNames:(NSString *)dirPath;

/** 删除指定目录或文件 */
+ (BOOL)clearCachesWithFilePath:(NSString *)path;

/** 清空指定目录下文件 */
+ (BOOL)clearCachesFromDirectoryPath:(NSString *)dirPath;

+ (NSString *)getCurrentTimeString;
//#pragma mark =============== 素材文件夹的创建和路径获取 ===============
///** 创建素材文件夹路径 该文件夹下包括zip zip解压后的文件夹 片头片尾  素材id*/
//+ (NSString *)creatAllMediasFolderPathWithMediasId:(NSString *)mediasId;
///** 该文件夹下包括zip zip解压后的文件夹 片头片尾  素材id*/
//+ (NSString *)getAllMediasFolderPathWithMediasId:(NSString *)mediasId;
///** zip解压后的素材文件夹路径 该文件夹包括图片 音频 素材id */
//+ (NSString *)getMediasFolderPathWithMediasId:(NSString *)mediasId;
//#pragma mark =============== 我录制视频文件的存取 ===============
///** 创建录音文件缓存文件夹*/
//+ (NSString *)creatLCChineseGuideRecordFolder;
///** 创建音视频文件缓存文件夹*/
//+ (NSString *)creatLCChineseGuideCompositionCacheFolder;
///** 创建我的视频文件夹 以userid区分不同用户 用素材id区分用户在不同景点录制的视频 */
//+ (NSString *)creatLCChineseGuideMyVideosFolder;
///** 获取我的视频  */
//+ (NSString *)getLCChineseGuideMyVideoWithMediasId:(NSString *)mediasId;

@end
