//
//  AVQueueViewController.m
//  AudioPro
//
//  Created by xlCoder on 2018/11/23.
//  Copyright © 2018年 XES. All rights reserved.
//

#import "AVQueueViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

/**
 *AVQueuePlayer
 *特点：1、完成回放功能；2、同一个实体对象控制多个多媒体文件的播放
 */
//
@interface AVQueueViewController (){

}
@property (nonatomic, strong)AVQueuePlayer *queuePlayer;
@property (nonatomic, strong)AVPlayerLooper *looper;
@end

@implementation AVQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"AVQueue";
    
    UIButton* playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.bounds = CGRectMake(0, 0, 100, 60);
    playBtn.center = CGPointMake(kScreen.width/2, 120);
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    playBtn.backgroundColor = [UIColor orangeColor];
    [playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.bounds = CGRectMake(0, 0, 100, 60);
    nextBtn.center = CGPointMake(kScreen.width/2, 200);
    [nextBtn setTitle:@"播放-Next" forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor orangeColor];
    [nextBtn addTarget:self action:@selector(plerNextAudioItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    // Do any additional setup after loading the view.
}

#pragma mark -初始化播放队列
- (void)playBtnClick{
    NSString* first_audioPath = [[NSBundle mainBundle] pathForResource:@"FWDL" ofType:@"mp3"];
    AVPlayerItem *first_playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:first_audioPath]];
    NSString* second_audioPath = [[NSBundle mainBundle] pathForResource:@"Kim Taylor-I Am You" ofType:@"mp3"];
    AVPlayerItem *second_playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:second_audioPath]];
    NSArray *playerItemArr =  @[first_playerItem,second_playerItem];
    AVQueuePlayer *queuePlayer = [[AVQueuePlayer alloc] initWithItems:playerItemArr];
    self.queuePlayer = queuePlayer;
//    self.looper = [AVPlayerLooper playerLooperWithPlayer:self.queuePlayer templateItem:first_playerItem];
    [self.queuePlayer play];
    
    
    //添加通知监控播放的状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.queuePlayer.currentItem];
    
    //KVO监听音乐的播放状态
    [self.queuePlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    //KVO监听音乐缓冲状态
    [self.queuePlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
    
    //开始播放时，通过AVPlayer的方法监听播放进度，并更新进度条（定期监听的方法）
    __weak typeof(AVQueueViewController*) weakSelf = self;
    [self.queuePlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
        //总时间
        float total = CMTimeGetSeconds(weakSelf.queuePlayer.currentItem.duration);
        if (current) {
            float progress = current / total;
            //更新播放进度条
//            weakSelf.playSlider.value = progress;
            NSLog(@"------%f",progress);
        }
    }];
    
}
//用户拖动进度条，修改播放进度
- (void)playSliderValueChange:(UISlider*)slider{
    float currentTime = slider.value*CMTimeGetSeconds(self.queuePlayer.currentItem.duration);
    NSLog(@"----%f",currentTime);
}
/**
 多个音乐播放顺滑播放
 */
- (void)audiosPlaySmooth {
    
}
//切换到下一首歌曲
- (void)plerNextAudioItem{
    
    /**
     *判读是否还有下一首
     */
    if (self.queuePlayer.items.count < 2) {
        NSLog(@"已经播放到最后一首");
        return;
    }
    [self.queuePlayer advanceToNextItem];
    
    //更新锁屏展示信息
    [self refreshlockScreenInfo];
}

//当前播放的媒体
- (void)playFinished:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"----%@",userInfo);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context

{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * timeRanges = self.queuePlayer.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.queuePlayer.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
        //        self.loadTimeProgress.progress = scale;
    } else if ([keyPath isEqualToString:@"status"]){
        switch (self.queuePlayer.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"AVPlayerStatusUnknown");
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"AVPlayerStatusReadyToPlay");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"AVPlayerStatusFailed");
                break;
            default:
                break;
        }
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

/**-----------关于媒体播放的一些常规操作------------**/
//1 、后台播放功能 在AppDelegate didFinishLaunchingWithOptions方法中添加如下代码，并在info.plist设置下权限
/**
 <key>UIBackgroundModes</key>
<array>
<string>audio</string>
</array>
 */
//{
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//}

//2、锁屏信息 每次播放下一首歌曲时 要更新锁屏信息 需要导入#import <MediaPlayer/MediaPlayer.h>
- (void)refreshlockScreenInfo{
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"audiolevels.png"]];
    [infoCenter setNowPlayingInfo:@{
                                    MPMediaItemPropertyTitle :@"歌曲名",
                                    MPMediaItemPropertyArtist :@"歌手名",
//                                    MPMediaItemPropertyPlaybackDuration :歌曲时间长度,
                                    MPMediaItemPropertyPlaybackDuration:@(180),
//                                        MPNowPlayingInfoPropertyElapsedPlaybackTime : @(已播放时间长度),
                                    MPNowPlayingInfoPropertyElapsedPlaybackTime:@(30),
                                    MPMediaItemPropertyArtwork : artwork
                                    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
