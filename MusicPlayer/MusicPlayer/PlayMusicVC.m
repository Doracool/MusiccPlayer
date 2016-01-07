//
//  PlayMusicVC.m
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "PlayMusicVC.h"
#import "PlayerHandel.h"
#import "QYMusic.h"
#import "ParsLrc.h"
#import "NSString+timer.h"
@interface PlayMusicVC ()<UITableViewDataSource,UITableViewDelegate,PlayerPRO>
@property (weak, nonatomic) IBOutlet UISlider *soundSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLab;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *playModelBtn;
@property (nonatomic, strong) NSTimer *time;
@end

@implementation PlayMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    _myTableView.delegate = self;
//    _myTableView.dataSource = self;
    
    _myTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [_myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow: inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [PlayerHandel sharePlayer].delegate = self;
    [self initDataForView];

    _time = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(xuanzhuan) userInfo:nil repeats:YES];
}

-(void)xuanzhuan{
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, M_PI/180);
}

//初始化视图
-(void)initDataForView{
    //初始化Volume
    _soundSlider.maximumValue = 1.0;
    _soundSlider.minimumValue = 0;
    _soundSlider.value = [PlayerHandel sharePlayer].volume;
    
    
    //初始化播放状态
    if ([PlayerHandel sharePlayer].isPlaying) {
        //暂停
        [_playBtn setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
    }else{
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    //初始化进度条
    _progressSlider.maximumValue = [PlayerHandel sharePlayer].countPtime;
    _progressSlider.value = [PlayerHandel sharePlayer].CurrentPTime;
    
    //初始化播放模式
    switch ([PlayerHandel sharePlayer].playerType) {
        case sequenceLoop:
            [_playModelBtn setImage:[UIImage imageNamed:@"danqu"] forState:UIControlStateNormal];
            [PlayerHandel sharePlayer].playerType = singleLoop;
            break;
            
        case singleLoop:
            [_playModelBtn setImage:[UIImage imageNamed:@"suiji"] forState:UIControlStateNormal];
            [PlayerHandel sharePlayer].playerType = Random;
            break;
            
        case Random:
            [_playModelBtn setImage:[UIImage imageNamed:@"shunxu"] forState:UIControlStateNormal];
            [PlayerHandel sharePlayer].playerType = sequenceLoop;
            break;
            
        default:
            break;
    }
    
    //初始化标题
    self.title = [PlayerHandel sharePlayer].songTitle;
    
    //初始化图片
   _imageView.image = [[PlayerHandel sharePlayer] songPicture];
    _imageView.layer.cornerRadius = 100;
    _imageView.layer.masksToBounds = YES;
}

#pragma mark - 播放器协议
-(void)updateProgressForTime:(NSTimeInterval)time
{
    //更新当前的进度条
    _progressSlider.value = time;
    //更新时间
    _currentTimeLab.text = [_currentTimeLab.text valueExchange:time];
}
-(void)updateLrcselectIndex:(NSInteger)index
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [_myTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    //滚动到哪行
    [_myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)finshedPlayNotifig{
    self.title = [PlayerHandel sharePlayer].songTitle;
    self.imageView.image = [PlayerHandel sharePlayer].songPicture;
    [_myTableView reloadData];
}

//音量控制
- (IBAction)volumeChnageValue:(UISlider *)sender {
    [PlayerHandel sharePlayer].volume = sender.value;
    
}
//进度条控制
- (IBAction)progressChangeValue:(UISlider *)sender {
    [PlayerHandel sharePlayer].CurrentPTime = sender.value;
}

// 模式切换
- (IBAction)modelAction:(UIButton *)sender {
    switch ([PlayerHandel sharePlayer].playerType) {
        case sequenceLoop:
            [sender setImage:[UIImage imageNamed:@"danqu"] forState:UIControlStateNormal];
            [PlayerHandel sharePlayer].playerType = singleLoop;
            break;
            
        case singleLoop:
            [sender setImage:[UIImage imageNamed:@"suiji"] forState:UIControlStateNormal];
            [PlayerHandel sharePlayer].playerType = Random;
            break;
            
        case Random:
            [sender setImage:[UIImage imageNamed:@"shunxu"] forState:UIControlStateNormal];
            [PlayerHandel sharePlayer].playerType = sequenceLoop;
            break;
            
        default:
            break;
    }
}

// 暂停和播放
- (IBAction)playOrPause:(UIButton *)sender {
    if ([PlayerHandel sharePlayer].playOrPause) {
        //改变状态
        [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_time setFireDate:[NSDate distantFuture]];
        [PlayerHandel sharePlayer].playOrPause = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
        [_time setFireDate:[NSDate distantPast]];
        [PlayerHandel sharePlayer].playOrPause = YES;
    }
}
//下一曲和上一曲
- (IBAction)nextSong:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
            [[PlayerHandel sharePlayer] previousSong];
            break;
            
        case 11:
            [[PlayerHandel sharePlayer] NextSong];
            break;
        default:
            break;
    }
}

- (IBAction)sound:(UIButton *)sender {
    if (_soundSlider.hidden) {
        _soundSlider.hidden = NO;
    }else{
        _soundSlider.hidden = YES; 
    }
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PlayerHandel sharePlayer].lrcModel.timeArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *QYID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QYID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QYID];
    }
    cell.textLabel.text = [PlayerHandel sharePlayer].lrcModel.lrcDic[[PlayerHandel sharePlayer].lrcModel.timeArr[indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:1.0];
    
    UIView *view = [[UIView alloc] initWithFrame:cell.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    [cell.textLabel setNumberOfLines:0];
    return cell;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [PlayerHandel sharePlayer].delegate = nil;
}

//切换到列表
- (IBAction)ListBtn:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//远程处理事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [PlayerHandel sharePlayer].playOrPause = YES;
            break;
            
        case UIEventSubtypeRemoteControlPause:
            [PlayerHandel sharePlayer].playOrPause = NO;
            break;
            
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
