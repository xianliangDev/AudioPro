//
//  ViewController.m
//  AudioPro
//
//  Created by xlCoder on 2018/11/19.
//  Copyright © 2018年 XES. All rights reserved.
//

#import "ViewController.h"

#import "AVFoundationEntranceController.h"
#import "AudioUnitController.h"
#import "AudioToolBoxController.h"

#import "UIView+WXAutoLayout.h"
#import <Foundation/NSJSONSerialization.h>

#import "Man.h"
static uint32_t seqNum = 0;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
//    dispatch_source_t _timer;
}

@property (nonatomic, strong) NSArray* dataArray;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerLen;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
//    double delayTime = 0;
//    delayTime = 1.5;
   
//     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_time_t startDelay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC));
//    dispatch_source_set_timer(_timer, startDelay, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(_timer, ^{
//        NSMutableData *formatteData = [NSMutableData dataWithCapacity:0];
//        seqNum ++;
//        NSLog(@"seq----%d",seqNum);
//        [formatteData appendData:DataFromInteger(seqNum)];
//    });
//    dispatch_resume(_timer);
//
//    NSLog(@"---%f",[[NSDate date] timeIntervalSince1970]);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"delayt---%f",[[NSDate date] timeIntervalSince1970]);
//    });
    
    // 获取完整的文件名带后缀
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *midPath = [path stringByAppendingPathComponent:@"correctedVoice"];
//    NSString *correctVoicePath = [midPath stringByAppendingPathComponent:@"test"];
//    NSString * str =@"straaaaa";
//    //
//    NSData *testdata =[str dataUsingEncoding:NSUTF8StringEncoding];
////    NSData *data = [];
//    if (testdata && testdata.length > 0) {
//        NSFileManager *fileM = [NSFileManager defaultManager];
//        [fileM createDirectoryAtPath:midPath withIntermediateDirectories:YES attributes:nil error:nil];
//        BOOL isExist = [fileM fileExistsAtPath:correctVoicePath];
////       NSFileandle *fileHandle =   [NSFileandle fileHandleForWritingAtPath:midPath];
//        if (!isExist) {
//           BOOL isSuccess = [testdata writeToFile:correctVoicePath atomically:YES];
//            NSLog(@"---成功");
//        }
//    }else{
//
//    }
//    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"cash"];
//
//
////    NSMutableData *tmpVoiceData = [voiceData mutableCopy];
//    NSError * error = nil;
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//
//    NSString * str =@"straaaaa";
//
//    NSData *testdata =[str dataUsingEncoding:NSUTF8StringEncoding];
//    BOOL success = [testdata writeToFile:filePath options:NSDataWritingAtomic error:&error];
//    if (success) {
//        NSLog(@"成功存储音频数据");
//    }
//    CGRect react = [UIScreen mainScreen].bounds;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, react.size.width, react.size.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view, typically from a nib.
}


//- (CGFloat)getGoldManHeight{
////    CGFloat goldCoefficient = 0.618;
////    CGFloat totalHeight = 0;
////    CGFloat headToNavelHeight = 0;
////    CGFloat navelTofooterHeight = 0;
////    return <#expression#>
//}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
}
- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}
- (void)recogniazeStart{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTime) userInfo:nil repeats:YES];
    [self.timer fire];
}
- (void)countDownTime{
    if (self.timerLen - 1 > 0) {
        NSLog(@"count");
        self.timerLen --;
    } else{
        NSLog(@"end");
    }
}
NSData * DataFromInteger(uint32_t integer) {
    
    uint32_t time = integer;
    char *p_time = (char *)&time;
    static char str_time[4] = {0};
    for(int i = 4 - 1; i >= 0; i--) {
        str_time[i] = *p_time;
        p_time ++;
    }
    
    
    return [NSData dataWithBytes:&str_time length:4];
}

#pragma mark UITableViewDelegate And UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* sectionArray = self.dataArray[section];
    return sectionArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellId = @"audioFoundationCellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray* sectionArray = self.dataArray[indexPath.section];
    cell.textLabel.text = sectionArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController* viewController = nil;
    switch (indexPath.row) {
        case 0:
            viewController  = [[AVFoundationEntranceController alloc] init];
            break;
        case 1:
            viewController  = [[AudioToolBoxController alloc] init];
            break;
        case 2:
            viewController  = [[AudioUnitController alloc] init];
            break;
  
        default:
            break;
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}
- (NSArray<NSArray*> *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@[@"AVFoundation",@"AudioToolbox",@"AudioUnit"],@[@"降噪/静音/回音消除",@"FFmpeg",@"WebRTC",@"声网"],@[@"踩坑总结"]];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
