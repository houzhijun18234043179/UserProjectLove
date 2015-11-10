//
//  DataImage.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
//创建block
typedef void(^UpdataUI) ();

@interface DataImage : NSObject
//声明block属性
@property(nonatomic,copy)UpdataUI myUpdataUI;
@property(nonatomic,strong)NSArray *allMusic;
//


/**
 *   创建单例对象
 *
 *   @return 单例
 */
+(DataImage*)sharedManager;

-(MusicModel *)musicModelWithIndex:(NSInteger)index;





@end
