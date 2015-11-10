//
//  PlayeringViewController.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/7.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayeringViewController : UIViewController


+(instancetype)sharedPlayingPVC;
//播放第几首歌曲的意思
@property(nonatomic,assign)NSInteger index;



@end
