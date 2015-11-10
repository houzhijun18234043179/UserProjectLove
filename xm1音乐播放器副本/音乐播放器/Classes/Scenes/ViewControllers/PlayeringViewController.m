

//
//  PlayeringViewController.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/7.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "PlayeringViewController.h"
#import "PlayerManager.h"
#import "DataImage.h"
#import "lyricManager.h"
#import "lyricMusicModel.h"
@interface PlayeringViewController ()<playerManagerDelegate,UITableViewDelegate,UITableViewDataSource>
//记录当前播放的索引
@property(nonatomic,assign)NSInteger currentIndex;
//记录当前正在播放的音乐
@property(nonatomic,strong)MusicModel *currerModel;
#pragma 拖得控件

@property (strong, nonatomic) IBOutlet UILabel *Lab4SongName;
@property (strong, nonatomic) IBOutlet UILabel *Lab4SingerName;
@property (strong, nonatomic) IBOutlet UIImageView *Img4Pic;
@property (strong, nonatomic) IBOutlet UILabel *Lab4PlayerTime;
@property (strong, nonatomic) IBOutlet UILabel *Lab4LastTime;
@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;
@property (strong, nonatomic) IBOutlet UISlider *sliderVolmer;
@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;
@property (strong, nonatomic) IBOutlet UITableView *tabelView4Lyric;


#pragma mark-----控件事件

- (IBAction)action4Prew:(id)sender;
- (IBAction)action4PlayOrPause:(UIButton *)sender;
- (IBAction)action4Next:(UIButton *)sender;
- (IBAction)action4ChangeTime:(id)sender;
//音量
- (IBAction)action4ChangerVolume:(id)sender;

@end
//先初始化控制器再用控制器承接出主入口等得数据
static PlayeringViewController *playingVC =nil;

static NSString *cellIdentifier = @"cell";
@implementation PlayeringViewController

 +(instancetype)sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //在main sb拿到我们用的视图控制器
        playingVC =[sb instantiateViewControllerWithIdentifier:@"playingVC"];
        
    });
    
    
    return playingVC;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果一样什么都不做
    if (_index == _currentIndex) {
        return;
    }
    //如果不等于
        _currentIndex = _index;
        
    [self startPlay];
    
}

-(void)startPlay{
    //取出播放的model
    [[PlayerManager sharedManager]playWithUrlString:self.currerModel.mp3Url];
    
    [self buildUI];
        
    }
  
- (IBAction)Action4Back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    
    
}

//确保当前播放的音乐是最新的
-(MusicModel *)currerModel{
    MusicModel *model =[[DataImage sharedManager]musicModelWithIndex:self.currentIndex];
    return model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置代理为自己的播放器,帮播放器干一些自己的事
    [PlayerManager sharedManager].delegate  =self;
    
    
    _currentIndex = -1;
    //切圆角
    self.Img4Pic.layer.masksToBounds = YES;
    self.Img4Pic.layer.cornerRadius = 120;
    //注册cell
    [self.tabelView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    //
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//播放器播放下一首(代理的方法)
-(void)playerDidPiayEnd{
//    _currentIndex++;
//    [self startPlay];
    [self action4Next:nil];
}


//播放器每0.1秒会让代理(也就是这个页面)执行一下事件
-(void)playerPlayingWithTime:(NSTimeInterval)time{
    //在代理里面获取的值
    self.slider4Volume.value = time;
    self.Lab4PlayerTime.text = [self stringWitnTime:time];
    //剩余时间
    NSTimeInterval time2 = [self.currerModel.duration integerValue]/1000-time;
    self.Lab4LastTime.text = [self stringWitnTime:time2] ;
    //每0.1秒旋转一度
    self.Img4Pic.transform = CGAffineTransformRotate(self.Img4Pic.transform, M_PI/180);
    //根据当前播放时间获取应该播放的那那句歌词
    NSInteger index =[[lyricManager sharedManager]indexWith:time];
    NSIndexPath *path =[NSIndexPath indexPathForRow:index inSection:0];
    //让tableView选中我们找到的歌词
    [self.tabelView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

#pragma mark------私有方法
//根据时间获取到字符串
-(NSString *)stringWitnTime:(NSTimeInterval)time{
    NSInteger miuntes = time/60;
    NSInteger seconds = (int)time %60;
    return [NSString stringWithFormat:@"%ld:%ld",(long)miuntes,(long)seconds];
    
    
}



//上一首
- (IBAction)action4Prew:(id)sender {
    _currentIndex--;
    if (_currentIndex == -1 ) {
        _currentIndex = [DataImage sharedManager].allMusic.count - 1;
    }
    
    [self startPlay];
    
}
//暂停或者播放事件
- (IBAction)action4PlayOrPause:(id)sender {
    
    //判断是否在播放
    if ([PlayerManager sharedManager].isPlaying) {
        //如果正在播放
        [[PlayerManager sharedManager] pause] ;
        
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        //脏停状态:开始播放,并改变BTU为为暂停
        [[PlayerManager sharedManager]play];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
    
}
//下一首
- (IBAction)action4Next:(UIButton *)sender {
//    
//    //在
//    [[PlayerManager sharedManager] pause];
    _currentIndex++;
    //如果是当前播放的音乐等于数组元素的个数,
    if (_currentIndex == [DataImage sharedManager].allMusic.count) {
        //直接返回第一首
        _currentIndex  =0;
    }
    //播放下一首
    [self startPlay];
}

-(void)buildUI{
    
    self.Lab4SingerName.text = self.currerModel.singer;
    self.Lab4SongName.text  = self.currerModel.name;
    [self.Img4Pic sd_setImageWithURL:[NSURL URLWithString:self.currerModel.picUrl]];
 //更改button
    [self.btn4PlayOrPause setTitle:@"暂停" forState:UIControlStateNormal];
    //改变精度条的最大值
    self.slider4Volume.maximumValue  =[self.currerModel.duration integerValue]/1000;
    self.slider4Volume.value  = 0;
    //更改旋转的角度
    self.Img4Pic.transform = CGAffineTransformMakeRotation(0);
    
    //解析歌词
    [[lyricManager sharedManager] loadLyricWith:self.currerModel.lyric];
    //刷新数据
    [self.tabelView4Lyric reloadData];
   
    
    
}


//改变播放的进度
- (IBAction)action4ChangeTime:(id)sender {
    UISlider *slider = sender;
    //调用单例里面的接口
    [[PlayerManager sharedManager]seekTotime:slider.value];
    
    
    
}
//改变音量大小
- (IBAction)action4ChangerVolume:(id)sender {
     UISlider *slider = sender;
    [[PlayerManager sharedManager]changeToVolume:slider.value];

}


#pragma mark_____-----------UItabelViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //这里的数组是不可变的 别人不可以修改
    return [lyricManager sharedManager].alllyric.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    lyricMusicModel *lyric =[lyricManager sharedManager].alllyric[indexPath.row];
    //设置标题
    cell.textLabel.text =lyric.lyricContext;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
    
}








@end
