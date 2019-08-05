//
//  XLCustomCell.m
//  AudioPro
//
//  Created by xlCoder on 2018/11/23.
//  Copyright © 2018年 XES. All rights reserved.
//

#import "XLCustomCell.h"

@implementation XLCustomCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews{
    UILabel *titlelb = [[UILabel alloc] initWithFrame:self.bounds];
    titlelb.textColor = [UIColor whiteColor];
    titlelb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titlelb];
    self.titlelb = titlelb;
    
}
@end
