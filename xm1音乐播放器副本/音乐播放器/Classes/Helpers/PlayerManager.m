//
//  PlayerManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager()
//播放器-->全局变量,如果有俩个AVPlayer的话,就会播放俩个音乐//播放器是私有的
@property(nonatomic,strong)AVPlayer *player;
//计时器
@property(nonatomic,assign)NSTimer *timer;

@end

static PlayerManager *manager = nil;
@implementation PlayerManager
//单例方法
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =[PlayerManager new];
    });
    return manager;
    
    
    


}
#pragma ===========添加到通知中心的用来切换歌曲的
-(instancetype)init{
    
    self = [super init];
    if (self) {
        //添加通知休息,当self发送AVPlayerItemDidPlayToEndTimeNotification时,触发playerDidPlayEnd事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

-(void)playerDidPlayEnd:(NSNotification *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPiayEnd)]) {
        //接受到item播放结束后让代理干一些事,代理会怎么干,播放器不需要知道
        [self.delegate playerDidPiayEnd];
        
        
        
    }
    
}



#pragma mark -对外方法
-(void)playWithUrlString:(NSString *)urlStr{
    
    //如果是切换歌曲,要先把正在播放的观察移除掉
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    //创建一个item
    AVPlayerItem *item =[AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    //对item添加观察
    //观察 item 的状态
    [item  addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    
    
    //直接播放当前播放的页面
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    
}
//写完这个在.H中写个属性
-(void)play{
    [self.player play];
    _isPlaying =YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSceonds) userInfo:nil repeats:YES];
    
}

-(void)playingWithSceonds{
    
   // NSLog(@"%lld",self.player.currentTime.value/self.player.currentTime.timescale);
    if (self.delegate &&[self.delegate  respondsToSelector:@selector(playerPlayingWithTime:)]) {
     NSTimeInterval time = self.player.currentTime.value/self.player.currentTime.timescale;
        [self.delegate playerPlayingWithTime:time];
        // self.Img4Pic.transform = CGAffineTransformRotate(self.Img4Pic.transform, M_PI/6);
    }
}

    
    
-(void)pause{
    [self.player pause];
    //暂停的时候标记一下设为NO
    _isPlaying =NO;
    [self.timer invalidate];
    self.timer = nil;
    
    
}
//事件为50秒
-(void)seekTotime:(NSTimeInterval)time{
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            //拖拽成功开始播放
             [self play];
        }
        
    }];
    
    
}
    

#pragma  ===================//赖加载 初始化播放器 不然不播放音乐

-(AVPlayer *)player{
    
    if (!_player) {
        _player =[AVPlayer new];
    }
    return _player;
}

#pragma ------观察响应事件

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    
    NSLog(@"%@",keyPath);
    NSLog(@"%@",change);
    AVPlayerItemStatus status = [change[@"new"]integerValue];
    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            case AVPlayerItemStatusUnknown:
            NSLog(@"资源不对");
            case AVPlayerItemStatusReadyToPlay:
            NSLog(@"准备好了,可以播放了");
            [self pause];
            //开始播放
               [self play];
            break; 
        default:
            break;
    }
}

-(void)changeToVolume:(CGFloat)volume{
    
    self.player.volume = volume;
    
    
    
    
    
}






@end
