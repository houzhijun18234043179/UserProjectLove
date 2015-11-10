
//
//  MusicCell.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "MusicCell.h"
#import "UIImageView+WebCache.h"
@implementation MusicCell


//实现set方法,使用杠和self的区别
-(void)setMusicModel:(MusicModel *)musicModel{
    _musicModel = musicModel;
    
    _nameLabel.text  = musicModel.name;
    _titleLabel.text  = musicModel.singer;
    //这个是图片加载的方法
    //一定记住在来回移动的时候重新走set方法来内存里面在在加载图片
    //这里面有用 po 来调试程序
    [_imgView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl]];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
