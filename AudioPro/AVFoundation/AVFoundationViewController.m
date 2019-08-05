//
//  AVFoundationViewController.m
//  AudioPro
//
//  Created by xlCoder on 2018/11/19.
//  Copyright © 2018年 XES. All rights reserved.
//

#import "AVFoundationViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "LCFileManager.h"

#import <AudioToolbox/AudioToolbox.h>
//引入AVPlayerViewController
//#import <AVKit/AVKit.h>

@interface AVFoundationViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>{
    AVAudioSessionChannelDescription*  description;
}
/** AVPlayer
 *1、必须定义成成员变量才可以使用
 *2、既可以播放视频，也可以播放音频
 *3、可以直接播放网络多媒体资源
 *4、单纯的AVPlayer无法完成视频播放，同时需要AVPlayerItem、AVPlayerLayer
 * AVAudioPlayer 没有队列这个东西
 * 1、不能播放pcm文件（ Error Domain=NSOSStatusErrorDomain Code=1954115647 ），可以播放mp3
 * 2、AMR (Adaptive multi-Rate，一种语音格式)
 ALAC (Apple lossless Audio Codec)
 iLBC (internet Low Bitrate Codec，另一种语音格式)
 IMA4 (IMA/ADPCM)
 linearPCM (uncompressed)
 u-law 和 a-law
 MP3 (MPEG-Laudio Layer 3)
 */
@property (nonatomic, strong)AVAudioPlayer *player;//
@property (nonatomic, strong)AVAudioPlayer *anotherPlayer;//
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）

//录音
@property (nonatomic, strong)AVAudioRecorder *recorder;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)UISlider *slider;
@end

@implementation AVFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AVFoundation";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.bounds = CGRectMake(0, 0, 100, 60);
    playBtn.center = CGPointMake(kScreen.width/2, 120);
    [playBtn setTitle:@"播放-AVPlayer" forState:UIControlStateNormal];
    playBtn.backgroundColor = [UIColor orangeColor];
    [playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    UIButton* recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.bounds = CGRectMake(0, 0, 100, 60);
    recordBtn.center = CGPointMake(kScreen.width/2, 200);
    [recordBtn setTitle:@"录音" forState:UIControlStateNormal];
    recordBtn.backgroundColor = [UIColor orangeColor];
    [recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
    
    UIButton* playAnotherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playAnotherBtn.bounds = CGRectMake(0, 0, 100, 60);
    playAnotherBtn.center = CGPointMake(kScreen.width/2, 280);
    [playAnotherBtn setTitle:@"播放录音" forState:UIControlStateNormal];
    playAnotherBtn.backgroundColor = [UIColor orangeColor];
    [playAnotherBtn addTarget:self action:@selector(playRecordFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playAnotherBtn];
    
    UIButton* stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.bounds = CGRectMake(0, 0, 100, 60);
    stopBtn.center = CGPointMake(kScreen.width/2 + 130, 280);
    [stopBtn setTitle:@"停止播放" forState:UIControlStateNormal];
    stopBtn.backgroundColor = [UIColor orangeColor];
    [stopBtn addTarget:self action:@selector(stopPlayMusicBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    //声音播放进度
    UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 360, kScreen.width - 20, 10)];
    [self.view addSubview:slider];
    self.slider = slider;
    
    // Do any additional setup after loading the view.
}

#pragma mark -Button Actions

- (void)playBtnClick{
    //本地播放
    NSString* musicPath = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"mp3"];
    NSURL* musicUrl = [NSURL fileURLWithPath:musicPath];
//    NSURL* remoteUrl = [NSURL URLWithString:@"http://"];//远程资源
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    //设置声音的大小
    player.volume = 0.5;//范围为（0到1）；
    //调节左右声道的大小 -1.0f 完全左声道， 1.0完全右声道
    player.pan = 0.0;
    //设置循环次数，如果为负数，就是无限循环
    player.numberOfLoops =-1;
    //设置播放进度，此方法放置在play前设置 设置播放当前的时间 超过总时长player.duration，播放会从0开始，如果放在play后设置会停止播放
    player.currentTime = 0;
    //是否允许改变播放速率
    player.enableRate = YES;
    //播放速度的调节
//    player.rate
    /**还有一个很强大的功能，就是可以测量音频播放时实时声道的功率大小，这个功能可以用于辅助显示声音的波浪*/
    player.meteringEnabled =  YES;
    //更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
    [player updateMeters];
    //读取每个声道的平均电平和峰值电平，代表每个声道的分贝数,范围在-100～0之间。
    for(int i = 0; i<player.numberOfChannels;i++){
        float power = [player averagePowerForChannel:i];
        float peak = [player peakPowerForChannel:i];
        NSLog(@"-----**%f>>>>>%f",power,peak);
    }
    //获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法
//    - (float)averagePowerForChannel:(NSUInteger)channelNumber    获得指定声道的分贝平均值，注意如果要获得分贝平均值必须在此之前调用updateMeters方法
//    - (float)peakPowerForChannel:(NSUInteger)channelNumber    获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法
//    - (void)updateMeters    更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
    // 以下代码让设备开启录音模式
    //静音模式下要开启这个功能
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    self.player = player;
    if (error) {
        NSLog(@"%@----player error",error.description);
    }
    if ([self.player isPlaying]) {
        [self.player stop];
        [self.player play];
    } else if([self.player prepareToPlay])
        [self.player play];
    
    
    
    
    NSLog(@"rate---%f----%f",self.player.rate,self.player.duration);
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)playRecordFile{
    //本地播放
    NSString* musicPath = [self recordPath];
    NSURL* musicUrl = [NSURL fileURLWithPath:musicPath];
    //    NSURL* remoteUrl = [NSURL URLWithString:@"http://"];//远程资源
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    //设置声音的大小
    player.volume = 0.5;//范围为（0到1）；
    //设置循环次数，如果为负数，就是无限循环
    player.numberOfLoops =-1;
    //设置播放进度，此方法放置在play前设置 设置播放当前的时间 超过总时长player.duration，播放会从0开始，如果放在play后设置会停止播放
    player.currentTime = 0;
    
    if (error) {
        NSLog(@"%@----player error",error.description);
    }
    if ([player isPlaying]) {
        [player stop];
        [player play];
    } else if([player prepareToPlay])
        [player play];
    self.anotherPlayer = player;
    player.pan = 1.0f;
}

- (void)recordBtnClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSURL *pathURL = [NSURL fileURLWithPath:[self recordPath]];
        NSError *error;
        if (@available(iOS 10.0, *)) {
            AudioStreamBasicDescription    _recordFormat;
            memset(&_recordFormat, 0, sizeof(_recordFormat));
            /**mSampleRate
             *1、录音设备在一秒钟内对声音信号的采样次数，采样频率越高声音的还原就越真实越自然
             */
            _recordFormat.mSampleRate = 16000;//采样率
            _recordFormat.mChannelsPerFrame = 2; //声道1:单声道；2:立体声, eg. 1
            //语音每采样点占用位数[8/16/24/32], eg. 16, 线性采样位数  8、16、24、32AVLinearPCMBitDepthKey
            _recordFormat.mBitsPerChannel = 16; //16位
            _recordFormat.mFramesPerPacket = 1;
            _recordFormat.mBytesPerPacket = _recordFormat.mBytesPerFrame = (_recordFormat.mBitsPerChannel / 8) * _recordFormat.mChannelsPerFrame;
            _recordFormat.mFormatID = kAudioFormatLinearPCM;
            if ( _recordFormat.mFormatID == kAudioFormatLinearPCM){
                // if we want pcm, default to signed 16-bit little-endian
                _recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
            }
            AVAudioFormat* format = [[AVAudioFormat alloc] initWithStreamDescription:&_recordFormat];
            self.recorder = [[AVAudioRecorder alloc] initWithURL:pathURL format:format error:&error];
        } else {
            // Fallback on earlier versions
            self.recorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:@{AVFormatIDKey:@(kAudioFormatLinearPCM),AVEncoderAudioQualityKey:@(AVAudioQualityHigh),AVNumberOfChannelsKey:@(2),AVSampleRateKey:@(44100),AVLinearPCMBitDepthKey:@(32)} error:&error];
        }
        // 以下代码让设备开启录音模式
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        
        
        /**还有一个很强大的功能，就是可以测量音频播放时实时声道的功率大小，这个功能可以用于辅助显示声音的波浪*/
        self.recorder.meteringEnabled =  YES;
        //更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
        [self.recorder updateMeters];
//        传入保存这个录音文件的URL路径, setting这个参数是个字典， 里面是一个音频设置信息，字典相对应的key, 可以去参考 AVAudioSettings.h ，值都是NSNumber类型
//        第一个初始化AVAudioRecorder方法中的setting字典一般设置的内容, 可以参考相关术语概念[iOS 音频学习基本术语和概念](http://www.jianshu.com/p/3802d2c6f051)
//                                                                               `AVSampleRateKey: String` 采样率   8000， 44100等
//                                                                               `AVNumberOfChannelsKey: String` 声道数 1为单声道， 2为双声道（立体声）
//                                                                               `AVLinearPCMBitDepthKey: String` 位宽 数据一般为： 8, 16, 24, 32
//                                                                               `AVEncoderAudioQualityKey: String` 录音质量，在`AVAudioQuality`枚举中，值有`min low medium  high  max`四个
//                                                                               `AVLinearPCMIsBigEndianKey: String` 大小端编码：1为大端， 0为小端.   如果你不懂什么是大小端可以看[iOS 关于大小端以及一些数据补位](http://www.jianshu.com/p/79f349409cbf)
//                                                                                                                                                                         ` AVFormatIDKey: String` 录音数据格式 可以参考CoreAudio 里面相关的值
//                                                                                                                                                                         其中 `AVFormatIDKey`的值有
        
        
        if (error) {
            NSLog(@"创建失败，原因是 = %@", error);
        }
        else {
            NSLog(@"创建成功");
        }
        self.recorder.delegate = self;
        if ([self.recorder prepareToRecord]) {//一定要先调用这个顺序
            [self.recorder record];
        }
        
    }
    else {
        [self.recorder stop];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantPast]];
}
- (void)stopPlayMusicBtnClick{
    [self.anotherPlayer stop];
    [self.player stop];
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}
#pragma mark AVAudioPlayerDelegate
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"结束录制，存储地址是%@", [self recordPath]);
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error;
{
    NSLog(@"出现了错误 = %@", error);
}

#pragma mark -tiemrAction
- (void)timerAction{
    self.slider.maximumValue = self.player.duration;
    self.slider.value = self.player.currentTime;
    
//    NSLog(@">>>>>>%f",[self.player averagePowerForChannel:0]);
//    NSLog(@"**>>>>>>%f",[self.player averagePowerForChannel:1]);
    if (!self.recorder) {
        return;
    }
//    self.recorder.meteringEnabled
    [self.recorder updateMeters];
    
    //averagePowerForChannel调用结果
    
    float avg = [self.recorder averagePowerForChannel:0];
    
    //比如把-60作为最低分贝
    
    float minValue = -60;
    
    //把60作为获取分配的范围
    
    float range = 60;
    
    //把100作为输出分贝范围
    
    float outRange = 100;
    
    //确保在最小值范围内
    
    if (avg < minValue)
        
    {
        
        avg = minValue;
        
    }
    
    //计算显示分贝
    
    float decibels = (avg + range) / range * outRange;
    
    NSLog(@"%f",  decibels);
}

- (void)levelTimerCallback:(NSTimer *)timer {
    
    [self.recorder updateMeters];
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels = [self.recorder averagePowerForChannel:0];
    if (decibels < minDecibels){
         level = 0.0f;
    }else if (decibels >= 0.0f){
        level = 1.0f;
    }else{
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        level = powf(adjAmp, 1.0f / root);
    }
    
    NSLog(@"平均值 %f", level * 120);
    
}

#pragma mark -
- (NSString*)recordPath{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"finish.wav"];
    return path;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.player pause];
    self.player = nil;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
