//
//  lyricManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lyricManager : NSObject

+(instancetype)sharedManager;
//对外的接口
-(void)loadLyricWith:(NSString *)lyricStr;
//对外的歌词数组
@property(nonatomic,strong)NSArray *alllyric;

/**
 *   根据播放时间获取到歌词的索引
 *
 *   @param time <#time description#>
 *
 *   @return <#return value description#>
 */

-(NSInteger)indexWith:(NSTimeInterval)time;

@end
