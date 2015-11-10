//
//  DataImage.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "DataImage.h"
#import "MusicModel.h"
//#import "URLS.h"
@interface DataImage ()
@property(nonatomic,strong)NSMutableArray *musicArray;
@end


static DataImage * manager =nil;
@implementation DataImage

//command +control + 上下键切换.h
+(DataImage *)sharedManager{
    
   
    //gcd提供一个单例方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataImage new];
        [manager requestData];
    });
    
    return manager;
}

//-(instancetype)init{
//    if (self  =[super init]) {
//        [self requestData];
//    }
//    return self;
//    
//    
//}


-(void)requestData{
    //在子线程中请求数据,防止假死现象
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url  =[NSURL URLWithString:kMusicListURL];
        
        NSArray *dataArray  =[NSArray arrayWithContentsOfURL:url];
        for (int i = 0; i < dataArray.count; i++) {
            NSLog(@"%@",dataArray[i]);
        //构建model类
            MusicModel *model  =[MusicModel new];
            [model setValuesForKeysWithDictionary:dataArray[i]];
            //把模型里面的值传递给musicArray里面
            [self.musicArray  addObject:model];
        
     
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!self.myUpdataUI) {
                NSLog(@"block 没有代码");
            }else{
                
                self.myUpdataUI();
                
                
            }
        });
        
        
       });
    
    
}


//完成以后在自定义里面调用
-(MusicModel *)musicModelWithIndex:(NSInteger)index{
    
    return self.allMusic[index];
    
    
}

#pragma mark----赖加载

-(NSMutableArray *)musicArray{
    //这里面用_musicArray不代表循环引用
    if (!_musicArray) {
        _musicArray  =[NSMutableArray array];
    }
    return _musicArray;
    
}

-(NSArray *)allMusic{
    
    return self.musicArray;
    
}



@end
