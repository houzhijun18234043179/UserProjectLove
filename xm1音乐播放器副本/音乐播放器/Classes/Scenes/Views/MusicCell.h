//
//  MusicCell.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//需要申明一个类的属性用来承接值
#import "MusicModel.h"
@interface MusicCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

//定义的一个属性
@property(nonatomic,retain)MusicModel *musicModel;


@end
