//
//  AVFoundationEntranceController.m
//  AudioPro
//
//  Created by xlCoder on 2018/11/23.
//  Copyright © 2018年 XES. All rights reserved.
//

#import "AVFoundationEntranceController.h"
#import "XLCustomCell.h"

#import "AVFoundationViewController.h"
#import "AVQueueViewController.h"
@interface AVFoundationEntranceController ()
@property (nonatomic, strong) NSArray<NSString*> *dataArray;
@end

@implementation AVFoundationEntranceController

static NSString * const reuseIdentifier = @"CellAVFoundation";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    [self.collectionView registerClass:[XLCustomCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (XLCustomCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [UIColor redColor];
    cell.titlelb.text =  self.dataArray[indexPath.row];
    return cell;
}
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView API_AVAILABLE(tvos(10.2)){
    return self.dataArray;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController* viewController = nil;
    switch (indexPath.row) {
        case 0:
            viewController  = [[AVFoundationViewController alloc] init];
            break;
        case 1:
            viewController  = [[AVQueueViewController alloc] init];
            break;
        case 2:
//            viewController  = [[AudioUnitController alloc] init];
            break;
            
        default:
            break;
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (NSArray<NSString*>*)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"AVAudioPlayer/Record",@"AVAudioQueue"];
    }
    return _dataArray;
}
@end
