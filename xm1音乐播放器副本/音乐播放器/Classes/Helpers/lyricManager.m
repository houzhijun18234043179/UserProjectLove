//
//  lyricManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "lyricManager.h"
#import "lyricMusicModel.h"

@interface lyricManager()
//添加歌词数组
@property(nonatomic,strong)NSMutableArray *lyrics;

@end



static lyricManager *manager = nil;
@implementation lyricManager


+(instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =[lyricManager new];
    });
    return manager;
}
//在单例里面解析歌词

-(void)loadLyricWith:(NSString *)lyricStr{
    
     //首先分行
    NSMutableArray *lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"]mutableCopy];
    //移除最后的的歌词
    [lyricStringArray removeLastObject];
    //现将前面的歌词移除在添加
    [self.lyrics removeAllObjects];
    
    for (NSString *str  in lyricStringArray) {
        NSLog(@"str:%@",str);
//        if ([str isEqualToString:@""]) {
//            continue;
//        }
        
        //2.分开时间和歌词
     NSArray *timeAndLyric = [str componentsSeparatedByString:@"]"];
       //3.去掉时间左边的"]"
    NSString *time = [timeAndLyric[0] substringFromIndex:2];
    //time = 02:32.08
        //截取时间获取的俩个元素分和秒
        NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
        
        NSInteger minute = [minuteAndSecond[0]integerValue];
        //秒
        double second = [minuteAndSecond[1]doubleValue];
        
        
        lyricMusicModel *model =[[lyricMusicModel alloc]initWithTime:(minute * 60 +second) lyric:timeAndLyric[1]];
        //添加元素到数组中国
        [self.lyrics addObject:model];
 
        
    }
    
    
}


-(NSMutableArray *)lyrics{
    
    if (!_lyrics) {
        _lyrics =[NSMutableArray new];
    }
    return _lyrics;
}


//写get方法

-(NSArray *)alllyric{
    
    
    return self.lyrics;
    
}
//获取索引的
-(NSInteger)indexWith:(NSTimeInterval)time{
    NSInteger index = 0;
    
    //遍历数组.找到还没有播放的那个歌词
    for (int i = 0; i < self.lyrics.count; i++) {
        lyricMusicModel *model = self.lyrics[i];
        if (model.time > time) {
            //注意如果是第零个元素,而且元素时间比播放的时间大,i-1就会小于0,这一昂TabelView就会crash
           index =  ( i - 1 >0)?i - 1 :0 ;
            //一定要break,要不就会循环下去
            break;
        }
        
    }
    return index;
    
}




@end
