


//
//  lyricMusicModel.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "lyricMusicModel.h"

@implementation lyricMusicModel
//自定义初始化方法
-(instancetype)initWithTime:(NSTimeInterval)time
                      lyric:(NSString *)lyric{
    
    if (self  =[super init]) {
        _time = time;
        _lyricContext = lyric;
    }
    return self;
    
}




@end
