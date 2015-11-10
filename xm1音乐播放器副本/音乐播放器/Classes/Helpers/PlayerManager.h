//
//  PlayerManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//设置代理进行切换歌曲
@protocol playerManagerDelegate <NSObject>
//当播放一首结束后,让代理去做的事情
-(void)playerDidPiayEnd;
//播放一致在重复这个方法
-(void)playerPlayingWithTime:(NSTimeInterval)time;


@end

@interface PlayerManager : NSObject


@property(nonatomic,assign)BOOL isPlaying;
//设置代理的属性(手写代码,单例,tabelView的代理)
@property(nonatomic,assign)id<playerManagerDelegate>delegate;

+(instancetype)sharedManager;

//给一个连接,让AVPlayer播放
-(void)playWithUrlString:(NSString *)urlStr;
//播放
-(void)play;
//暂停
-(void)pause;
-(void)seekTotime:(NSTimeInterval)time;
//改变
-(void)changeToVolume:(CGFloat)volume;



@end
